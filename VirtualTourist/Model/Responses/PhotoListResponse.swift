//
//  PhotoListResponse.swift
//  VirtualTourist
//
//  Created by Shin Negishi on 3/14/20.
//  Copyright © 2020 6A. All rights reserved.
//

import Foundation

struct PhotoMeta: Codable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
}

struct PhotoList: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [PhotoMeta]
}

struct PhotoListResponse: Codable {
    let photos: PhotoList
    let stat: String
}


//https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg


//jsonFlickrApi({"photos":{"page":1,"pages":825,"perpage":250,"total":"206004","photo":[{"id":"49661111586","owner":"13722695@N00","secret":"014ce177b9","server":"65535","farm":66,"title":"Bay Area","ispublic":1,"isfriend":0,"isfamily":0},

//{"id":"49661111606","owner":"13722695@N00","secret":"8c14a52c95","server":"65535","farm":66,"title":"Bay Area","ispublic":1,"isfriend":0,"isfamily":0},{"id":"49661392132","owner":"13722695@N00","secret":"67a16e3332","server":"65535","farm":66,"title":"Bay Area","ispublic":1,"isfriend":0,"isfamily":0},{"id":"49660926906","owner":"31603030@N08","secret":"be159b6a6b","server":"65535","farm":66,"title":"Flower beds in San Francisco's Golden Gate Park 200228-121602 cw50 C4","ispublic":1,"isfriend":0,"isfamily":0},
    
