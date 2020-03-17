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
        static let base = "https://www.flickr.com/services"
        static let formatParam = "?format=json"
        static let jsonCallbackParam = "&nojsoncallback=1"
        static let apiKeyParam = "&api_key=\(Auth.apiKey)"
        
        case getPhotoList
        
        var stringValue: String {
            switch self {
            case .getPhotoList:
                return Endpoints.base + "/rest/\(Endpoints.formatParam)\(Endpoints.jsonCallbackParam)&method=flickr.photos.search" + Endpoints.apiKeyParam
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
    
    class func getPhotoList(latitude: Double, longitutde: Double, completion: @escaping ([PhotoMeta], Error?) -> Void) {

        let urlString = Endpoints.getPhotoList.stringValue + "&lat=\(latitude)&lon=\(longitutde)"
        let url = URL(string: urlString)!
        let ResponseType = PhotoListResponse.self
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            print(String(reflecting: data))
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject.photos.photo, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        task.resume()
    }
    
    //jsonFlickrApi({"photos":{"page":1,"pages":825,"perpage":250,"total":"206004","photo":[{"id":"49661111586","owner":"13722695@N00","secret":"014ce177b9","server":"65535","farm":66,"title":"Bay Area","ispublic":1,"isfriend":0,"isfamily":0},
//{"id":"49660072626","owner":"51035555243@N01","secret":"64707f4e17","server":"65535","farm":66,"title":"Polaroid Cowboy","ispublic":1,"isfriend":0,"isfamily":0},{"id":"49660350507","owner":"51035555243@N01","secret":"97679e9803","server":"65535","farm":66,"title":"Folsom Street Fair","ispublic":1,"isfriend":0,"isfamily":0}]},"stat":"ok"})
    
    
    
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
