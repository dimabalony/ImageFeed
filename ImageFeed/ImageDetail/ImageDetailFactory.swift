//
//  ImageDetailFactory.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 22.02.24.
//

import UIKit

protocol ImageDetailFactoryProtocol: AnyObject {
    func makeImageDetail(for photo: Photo, coordinator: ImageDetailCoordinator) -> UIViewController
}

final class ImageDetailFactory {
    private let imageProvider: ImageProviderProtocol
    
    init(imageProvider: ImageProviderProtocol) {
        self.imageProvider = imageProvider
    }
}

extension ImageDetailFactory: ImageDetailFactoryProtocol {
    func makeImageDetail(for photo: Photo, coordinator: ImageDetailCoordinator) -> UIViewController {
        let imageDetailPresenter = ImageDetailPresenter(photo: photo, imageProvider: imageProvider, imageDetailCoordinator: coordinator)
        let imageDetailViewController = ImageDetailViewController(presenter: imageDetailPresenter)
        imageDetailPresenter.setupView(imageDetailViewController)
        return imageDetailViewController
    }
}
