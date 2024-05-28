//
//  ImageDetailPresenter.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 22.02.24.
//

import Foundation

protocol ImageDetailPresenterProtocol {
    func viewDidLoad()
    func closeButtonTapped()
}

final class ImageDetailPresenter {
    
    private let photo: Photo
    private let imageProvider: ImageProviderProtocol
    private let imageDetailCoordinator: ImageDetailCoordinator
    private weak var view: ImageDetailView?
    
    init(photo: Photo, imageProvider: ImageProviderProtocol, imageDetailCoordinator: ImageDetailCoordinator) {
        self.photo = photo
        self.imageProvider = imageProvider
        self.imageDetailCoordinator = imageDetailCoordinator
    }
    
    func setupView(_ view: ImageDetailView) {
        self.view = view
    }
}

extension ImageDetailPresenter: ImageDetailPresenterProtocol {
    func viewDidLoad() {
        imageProvider.fetchImage(for: photo.src.original) { [weak self] result in
            switch result {
            case let .success(image):
                self?.view?.populateImage(image)
            case let .failure(error):
                print(error.localizedDescription)
                // MARK: Handle Error
            }
        }
    }
    
    func closeButtonTapped() {
        imageProvider.cancelPreparingImage(for: photo.src.original)
        imageDetailCoordinator.closeDetail()
    }
}
