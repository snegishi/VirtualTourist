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
                return Endpoints.base + "/rest/\(Endpoints.formatParam)\(Endpoints.jsonCallbackParam)&method=flickr.photos.search&per_page=20" + Endpoints.apiKeyParam
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

        let randomNumber = Int.random(in: 1..<200)
        let urlString = Endpoints.getPhotoList.stringValue + "&lat=\(latitude)&lon=\(longitutde)&page=\(randomNumber)"
        let url = URL(string: urlString)!
        let ResponseType = PhotoListResponse.self
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
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
    
    class func getPhotoData(farmId: Int, serverId: String, id: String, secret: String, completion: @escaping (Data?, Error?) -> Void) {
        let urlString = "https://farm\(farmId).staticflickr.com/\(serverId)/\(id)_\(secret).jpg" + Endpoints.apiKeyParam
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(data, nil)
            }
        }
        task.resume()
    }
}
