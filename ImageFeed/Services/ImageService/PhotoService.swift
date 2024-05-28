//
//  PhotoService.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 9.02.24.
//

import Foundation

protocol PhotoService: AnyObject {
    func fetchPhotos(at page: Int, completion: @escaping FetchPhotosCompletion)
}
