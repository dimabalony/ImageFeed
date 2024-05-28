//
//  ImageProviderFactory.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 20.05.24.
//

import Foundation

protocol ImageProviderFactoryProtocol: AnyObject {
    func makeImageProvider() -> ImageProviderProtocol
}

final class ImageProviderFactory: ImageProviderFactoryProtocol {
    func makeImageProvider() -> ImageProviderProtocol {
        ImageProvider()
    }
}

