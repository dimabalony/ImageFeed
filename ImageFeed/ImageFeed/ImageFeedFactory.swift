//
//  ImageFeedFactory.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 22.02.24.
//

import UIKit

protocol ImageFeedFactoryProtocol: AnyObject {
    func makeImageFeed(coordinator: ImageFeedCoordinator) -> UIViewController
}

final class ImageFeedFactory {
    private let photoServiceFactory: PhotoServiceFactoryProtocol
    private let imageProvider: ImageProviderProtocol
    
    init(photoServiceFactory: PhotoServiceFactoryProtocol, imageProvider: ImageProviderProtocol) {
        self.photoServiceFactory = photoServiceFactory
        self.imageProvider = imageProvider
    }
}

extension ImageFeedFactory: ImageFeedFactoryProtocol {
    func makeImageFeed(coordinator: ImageFeedCoordinator) -> UIViewController {
        let photoService = photoServiceFactory.makePhotoService()
        let imageFeedPresenter = ImageFeedPresenter(photoService: photoService,
                                                    imageProvider: imageProvider,
                                                    imageFeedCoordinator: coordinator)
        let imageFeedViewController = ImageFeedViewController(presenter: imageFeedPresenter)
        imageFeedPresenter.setupView(imageFeedViewController)
        return imageFeedViewController
    }
}
