//
//  PhotoSource.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 18.05.24.
//

import Foundation

struct PhotoSource: Codable {
    let original: URL
    let large2x: URL
    let large: URL
    let medium: URL
    let small: URL
    let portrait: URL
    let landscape: URL
    let tiny: URL
}
