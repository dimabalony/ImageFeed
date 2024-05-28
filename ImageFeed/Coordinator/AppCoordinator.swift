//
//  AppCoordinator.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 22.02.24.
//

import UIKit

protocol ImageFeedCoordinator {
    func showImageDetail(for photo: Photo)
}

protocol ImageDetailCoordinator {
    func closeDetail()
}

final class AppCoordinator {
    
    private let window: UIWindow
    private let imageFeedFactory: ImageFeedFactoryProtocol
    private let imageDetailFactory: ImageDetailFactoryProtocol
    private weak var rootViewController: UIViewController?
    
    init(window: UIWindow,
         imageFeedFactory: ImageFeedFactoryProtocol,
         imageDetailFactory: ImageDetailFactoryProtocol) {
        self.window = window
        self.imageFeedFactory = imageFeedFactory
        self.imageDetailFactory = imageDetailFactory
    }
    
    func start() {
        let imageFeed = imageFeedFactory.makeImageFeed(coordinator: self)
        window.rootViewController = imageFeed
        rootViewController = imageFeed
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: ImageFeedCoordinator {
    func showImageDetail(for photo: Photo) {
        let imageDetail = imageDetailFactory.makeImageDetail(for: photo, coordinator: self)
        rootViewController?.present(imageDetail, animated: true)
    }
}

extension AppCoordinator: ImageDetailCoordinator {
    func closeDetail() {
        rootViewController?.dismiss(animated: true)
    }
}
