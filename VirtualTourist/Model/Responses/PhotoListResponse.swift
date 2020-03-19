//
//  PhotoListResponse.swift
//  VirtualTourist
//
//  Created by Shin Negishi on 3/14/20.
//  Copyright © 2020 6A. All rights reserved.
//

import Foundation

struct PhotoMeta: Codable {
    let id, owner, secret, server, title: String
    let farm, ispublic, isfriend, isfamily: Int
}

struct PhotoList: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [PhotoMeta]
}

struct PhotoListResponse: Codable {
    let photos: PhotoList
    let stat: String
}
