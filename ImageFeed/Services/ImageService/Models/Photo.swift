//
//  Photo.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 18.05.24.
//

import Foundation

struct Photo: Codable {
    let id: Int
    let width: Int
    let height: Int
    let photographer: String
    let src: PhotoSource
    let liked: Bool
    let alt: String
}
