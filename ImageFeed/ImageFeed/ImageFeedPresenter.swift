//
//  ImageFeedPresenter.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 9.02.24.
//

import Foundation

protocol ImageFeedPresenterProtocol {
    func viewDidLoad()
    func willDisplayItem(at index: Int)
    func prefetchItems(at indexes: [Int])
    func didSelectItem(at index: Int)
    func refreshItems()
}

final class ImageFeedPresenter {
    
    private enum Constants {
        static let nearestItemToStartLoadNext = 5
    }
    
    private let photoService: PhotoService
    private let imageProvider: ImageProviderProtocol
    private let imageFeedCoordinator: ImageFeedCoordinator
    
    private weak var view: ImageFeedView?
    
    private var currentPage = 1
    private var loadInProgress = false
    private var photos = [Photo]()
    
    init(photoService: PhotoService, imageProvider: ImageProviderProtocol, imageFeedCoordinator: ImageFeedCoordinator) {
        self.photoService = photoService
        self.imageProvider = imageProvider
        self.imageFeedCoordinator = imageFeedCoordinator
    }
    
    func setupView(_ view: ImageFeedView) {
        self.view = view
    }
}

extension ImageFeedPresenter: ImageFeedPresenterProtocol {
    func viewDidLoad() {
        loadItems(at: currentPage) { [weak self] photos in
            guard let self else { return }
            self.appendPhotos(photos)
        }
        
        currentPage += 1
    }
    
    func prefetchItems(at indexes: [Int]) {
        let prefetchURLs: [URL] = indexes.compactMap { [weak self] in
            guard let self, photos.endIndex > $0 else { return nil }
            return photos[$0].src.large
        }
        
        prefetchURLs.forEach { [weak self] url in
            self?.imageProvider.prepareImage(for: url)
        }
    }
    
    func willDisplayItem(at index: Int) {
        
        let nearestItem = Constants.nearestItemToStartLoadNext
        
        let lowIndex = index - nearestItem < 0 ? 0 : index - nearestItem
        let upIndex = index + nearestItem
        
        guard !photos.indices.contains(lowIndex) || !photos.indices.contains(upIndex) else {
            return
        }
        
        loadItems(at: currentPage) { [weak self] photos in
            guard let self else { return }
            self.appendPhotos(photos)
        }
        
        currentPage += 1
    }
    
    func didSelectItem(at index: Int) {
        imageFeedCoordinator.showImageDetail(for: photos[index])
    }
    
    func refreshItems() {
        photos = []
        currentPage = 1
        
        loadItems(at: currentPage) { [weak self] photos in
            guard let self else { return }
            self.refreshPhotos(photos)
        }
        
        currentPage += 1
    }
}

private extension ImageFeedPresenter {

    func loadItems(at page: Int, completion: @escaping ([Photo]) -> ()) {
        guard !loadInProgress else { return }
        
        loadInProgress = true
        
        photoService.fetchPhotos(at: page) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case let .success(response):
                completion(response.photos)
                self.loadInProgress = false
            case let .failure(error):
                self.loadInProgress = false
                print(error.localizedDescription)
                // MARK: Handle Error
            }
        }
    }
    
    func refreshPhotos(_ photos: [Photo]) {
        self.photos = photos
        
        let items = photos.map { photo in
            ImageFeedItem(
                id: photo.id,
                authorsName: photo.photographer,
                previewURL: photo.src.large,
                height: photo.height,
                width: photo.width,
                imageProvider: imageProvider)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.reload(items)
        }
    }
    
    func appendPhotos(_ photos: [Photo]) {
        self.photos += photos
        
        let items = photos.map { photo in
            ImageFeedItem(
                id: photo.id,
                authorsName: photo.photographer,
                previewURL: photo.src.large,
                height: photo.height,
                width: photo.width,
                imageProvider: imageProvider)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.append(items)
        }
    }
}
