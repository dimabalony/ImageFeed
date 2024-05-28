//
//  AccessTokenStorageFactory.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 22.02.24.
//

import Foundation

protocol AccessTokenStorageFactoryProtocol: AnyObject {
    func makeAccessTokenStorage() -> AccessTokenStorageProtocol
}

final class AccessTokenStorageFactory: AccessTokenStorageFactoryProtocol {
    func makeAccessTokenStorage() -> AccessTokenStorageProtocol {
        AccessTokenStorage()
    }
}
