//
//  VirtualTouristClient.swift
//  VirtualTourist
//
//  Created by Shin Negishi on 3/14/20.
//  Copyright © 2020 6A. All rights reserved.
//

import Foundation

class VirtualTouristClient {
    
    struct Auth {
        static var apiKey = "bcf0d9b944325351f2f9775555130fcb"
        static var secret = "3def64b7ace06eda"
    }
    
    enum Endpoints {
        static let base = "https://www.flickr.com/services/rest/?method="
        static let apiKeyParam = "&api_key=\(Auth.apiKey)"
        
        case getPhotoList
        
        var stringValue: String {
            switch self {
            case .getPhotoList:
                return Endpoints.base + "flickr.photos.geo.photosForLocation" + Endpoints.apiKeyParam
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    @discardableResult
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        return task
    }
    
    class func getPhotoList(latitude: Double, longitutde: Double, completion: @escaping ([String], Error?) -> Void) {

        let url = URL(string: Endpoints.getPhotoList.stringValue + "&lat=\(latitude)&lon=\(longitutde)")!
        let ResponseType = PhotoListResponse.self
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            print(String(reflecting: data))
//            let decoder = JSONDecoder()
            do {
                let responseObject = [""] //try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        task.resume()
    }
    
//<photos page="2" pages="89" perpage="10" total="881">
//    <photo id="2636" owner="47058503995@N01"
//        secret="a123456" server="2" title="test_04"
//        ispublic="1" isfriend="0" isfamily="0" />
//    <photo id="2635" owner="47058503995@N01"
//        secret="b123456" server="2" title="test_03"
//        ispublic="0" isfriend="1" isfamily="1" />
//    <photo id="2633" owner="47058503995@N01"
//        secret="c123456" server="2" title="test_01"
//        ispublic="1" isfriend="0" isfamily="0" />
//    <photo id="2610" owner="12037949754@N01"
//        secret="d123456" server="2" title="00_tall"
//        ispublic="1" isfriend="0" isfamily="0" />
//</photos>
    
    
    class func getPhotoData() {
        //        https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
        //            or
        //        https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
        //            or
        //        https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{o-secret}_o.(jpg|gif|png)

        let url = URL(string: "https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg" + Endpoints.apiKeyParam)
        
        // TODO write down the process of GET request
    }
}
