//
//  PhotoServiceError.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 22.02.24.
//

import Foundation

enum PhotoServiceError: Error {
    case urlConstructingFailed
    case accessTokenMissed
    case unsuccessCode
    case decodingFailed
    
    case unknown(error: Error)
}
