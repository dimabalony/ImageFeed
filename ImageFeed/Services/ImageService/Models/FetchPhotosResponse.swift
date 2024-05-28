//
//  FetchPhotosResponse.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 18.05.24.
//

import Foundation

struct FetchPhotosResponse: Codable {
    let page: Int
    let perPage: Int
    let photos: [Photo]
}
