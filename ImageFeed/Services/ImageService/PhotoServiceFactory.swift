//
//  PhotoServiceFactory.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 22.02.24.
//

import Foundation

protocol PhotoServiceFactoryProtocol: AnyObject {
    func makePhotoService() -> PhotoService
}

final class PhotoServiceFactory: PhotoServiceFactoryProtocol {
    
    let accessTokenStorageFactory: AccessTokenStorageFactoryProtocol
    
    init(accessTokenStorageFactory: AccessTokenStorageFactoryProtocol) {
        self.accessTokenStorageFactory = accessTokenStorageFactory
    }
    
    func makePhotoService() -> PhotoService {
        let accessTokenStorage = accessTokenStorageFactory.makeAccessTokenStorage()
        return PexelsAPIService(accessTokenStorage: accessTokenStorage)
    }
}
