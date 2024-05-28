//
//  ImageProvider.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 19.05.24.
//

import UIKit

typealias ImageCompletion = (Result<UIImage, ImageProviderError>) -> ()

protocol ImageProviderProtocol: AnyObject {
    func prepareImage(for url: URL)
    func cancelPreparingImage(for url: URL)
    func fetchImage(for url: URL, completion: @escaping ImageCompletion)
}

final class ImageProvider {
    private let cache: NSCache<AnyObject, UIImage> = {
        let cache = NSCache<AnyObject, UIImage>()
        cache.countLimit = 100
        return cache
    }()
    private let lock = NSLock()
    private var dataTasks = [URL: URLSessionDataTask]()
}

extension ImageProvider: ImageProviderProtocol {
    
    func prepareImage(for url: URL) {
        guard cache.object(forKey: url as AnyObject) == nil else { return }
        let dataTask = makeDataTask(for: url)
        dataTask.resume()
        lock.lock(); defer { lock.unlock() }
        dataTasks[url] = dataTask
    }
    
    func cancelPreparingImage(for url: URL) {
        dataTasks[url]?.cancel()
        lock.lock(); defer { lock.unlock() }
        dataTasks.removeValue(forKey: url)
    }
    
    func fetchImage(for url: URL, completion: @escaping ImageCompletion) {
        lock.lock(); defer { lock.unlock() }
        
        if let image = cache.object(forKey: url as AnyObject) {
            completion(.success(image))
            return
        }
        
        let dataTask = makeDataTask(for: url, completion: completion)
        dataTask.resume()
        dataTasks[url] = dataTask
    }
}

private extension ImageProvider {
    func makeDataTask(for url: URL, completion: ImageCompletion? = nil) -> URLSessionDataTask {
        let urlRequest = URLRequest(url: url)
        
        return URLSession.shared.dataTask(with: urlRequest, completionHandler: { [weak self] data, response, error in
            self?.lock.lock(); defer { self?.lock.unlock() }
            self?.dataTasks.removeValue(forKey: url)
            
            guard let self, let data, let image = UIImage(data: data)  else {
                if let error = error as? NSError, error.code == -999 {
                    return
                }
                
                DispatchQueue.main.async {
                    completion?(.failure(.unknown(error: error)))
                }
                return
            }
            self.cache.setObject(image, forKey: url as AnyObject)
            DispatchQueue.main.async {
                completion?(.success(image))
            }
        })
    }
}
