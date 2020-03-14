//
//  PhotoViewController.swift
//  VirtualTourist
//
//  Created by Shin Negishi on 3/9/20.
//  Copyright © 2020 6A. All rights reserved.
//

import UIKit
import MapKit

class PhotoViewController: UIViewController {
    
    // MARK: - Properties
    
    var photos = ["https://"]
    var latitude = 0.0
    var longitude = 0.0
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: check if there are saved images in CoreData.
        // use DataController and FetchedController
        
        // TODO download Photo images from Flickr if there are saved images in CoreData.
        VirtualTouristClient.getPhotoList(latitude: latitude, longitutde: longitude, completion: photoListResponseHandler(photoList:error:))
//        VirtualTouristClient.getPhotoData()
    }
    
    func photoListResponseHandler(photoList: [String], error: Error?) {
        
    }
    
    @IBAction func newCollectionButtonTapped() {
        // TODO show CollectionView of photo images which you can choose as many as you hope.
        
    }
    
}


extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count // TODO change the actual variable
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as UICollectionViewCell
        
        // TODO If there are some images which are saved in CoreData, you should show them in CollectionView. If not, you should insert "No Images" label.
        
//        cell. = UIImage(named: "VirtualTourist")
        
        
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO add images to Photo Album if NewCollection button was pushed
        
        // TODO remove images from Photo Album before pushing NewCollection button.
        
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
}
