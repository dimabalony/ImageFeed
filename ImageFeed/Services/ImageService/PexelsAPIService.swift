//
//  PexelsAPIService.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 9.02.24.
//

import Foundation

typealias FetchPhotosCompletion = (Result<FetchPhotosResponse, PhotoServiceError>) -> Void

final class PexelsAPIService {
    
    private enum Constants {
        static let scheme = "https"
        static let host = "api.pexels.com"
        static let curatedPhotosPath = "/v1/curated"
        static let authorizationHeader = "Authorization"
        
        static let queryPageParameter = "page"
    }
    
    private let accessTokenStorage: AccessTokenStorageProtocol
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    init(accessTokenStorage: AccessTokenStorageProtocol) {
        self.accessTokenStorage = accessTokenStorage
    }
}

extension PexelsAPIService: PhotoService {
    
    func fetchPhotos(at page: Int, completion: @escaping FetchPhotosCompletion) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.curatedPhotosPath
        urlComponents.queryItems = [
            URLQueryItem(name: Constants.queryPageParameter, value: "\(page)")
        ]
        
        guard let url = urlComponents.url else {
            completion(.failure(.urlConstructingFailed))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        let accessToken: String
        do {
            accessToken = try accessTokenStorage.fetchAccessToken()
        } catch _ as AccessTokenStorageError {
            completion(.failure(.accessTokenMissed))
            return
        } catch {
            completion(.failure(.unknown(error: error)))
            return
        }
        
        urlRequest.addValue(accessToken, forHTTPHeaderField: Constants.authorizationHeader)
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, urlResponse, error in
            if let error {
                completion(.failure(.unknown(error: error)))
                return
            }
            
            guard let self, (urlResponse as? HTTPURLResponse)?.statusCode == 200, let data else {
                completion(.failure(.unsuccessCode))
                return
            }
            
            guard let photosResponse = try? self.jsonDecoder.decode(FetchPhotosResponse.self, from: data) else {
                completion(.failure(.decodingFailed))
                return
            }
            
            completion(.success(photosResponse))
        }.resume()
    }
}
