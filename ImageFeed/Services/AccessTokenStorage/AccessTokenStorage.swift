//
//  AccessTokenStorage.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 22.02.24.
//

import Foundation

protocol AccessTokenStorageProtocol: AnyObject {
    func fetchAccessToken() throws -> String
}

final class AccessTokenStorage: AccessTokenStorageProtocol {
    
    private enum Constants {
        static let infoDictionary = Bundle.main.infoDictionary
    }
    
    func fetchAccessToken() throws -> String {
        guard let accessToken = Constants.infoDictionary?["PEXEL_ACCESS_TOKEN"] as? String else {
            throw AccessTokenStorageError.tokenNotFound
        }
        return accessToken
    }
}
