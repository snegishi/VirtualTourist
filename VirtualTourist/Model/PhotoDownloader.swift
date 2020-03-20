//
//  PhotoDownloader.swift
//  VirtualTourist
//
//  Created by Shin Negishi on 3/20/20.
//  Copyright © 2020 6A. All rights reserved.
//

import Foundation

class PhotoDownloader {
    
    // MARK: - Properties
    
    var pin: Pin!
    var photos: [Photo]!
    
    var dataController: DataController!
    
    init(pin: Pin) {
        self.pin = pin
    }
    
    func download() {
        VirtualTouristClient.getPhotoList(latitude: pin.latitude, longitutde: pin.longitude, completion: photoListResponseHandler(photoList:error:))
    }
    
    func photoListResponseHandler(photoList: [PhotoMeta], error: Error?) {
        if error != nil {
            // TODO implement showFailure method
            print(error?.localizedDescription ?? "")
        } else {
            for photoMeta in photoList {
                VirtualTouristClient.getPhotoData(farmId: photoMeta.farm, serverId: photoMeta.server, id: photoMeta.id, secret: photoMeta.secret, completion: photoResponseHandler(image:error:))
            }
        }
    }
    
    func photoResponseHandler(image: Data?, error: Error?) {
        if error != nil {
            print(error?.localizedDescription ?? "")
        } else {
            let photo = Photo(context: dataController.viewContext)
            photo.image = image
            photo.creationDate = Date()
            photo.pin = pin
            try? dataController.viewContext.save()
        }
    }

}
