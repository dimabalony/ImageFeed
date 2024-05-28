//
//  ImageFeedItem.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 18.05.24.
//

import UIKit

struct ImageFeedItem {
    let id: Int
    let authorsName: String
    let previewURL: URL
    let height: Int
    let width: Int
    let imageProvider: ImageProviderProtocol
}

extension ImageFeedItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(authorsName)
        hasher.combine(previewURL)
        hasher.combine(height)
        hasher.combine(width)
    }
    
    static func == (lhs: ImageFeedItem, rhs: ImageFeedItem) -> Bool {
        lhs.authorsName == rhs.authorsName &&
        lhs.previewURL == rhs.previewURL
    }
}

