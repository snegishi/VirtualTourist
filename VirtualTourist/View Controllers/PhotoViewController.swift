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
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Life Cycle
    
    fileprivate func centerTheSelectedLocationOnMap() {
        let centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let viewRegion = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(viewRegion, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = centerCoordinate
        mapView.addAnnotation(annotation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerTheSelectedLocationOnMap()
        
        // TODO: check if there are saved images in CoreData.
        // use DataController and FetchedController
        
        // TODO download Photo images from Flickr if there are saved images in CoreData.
        VirtualTouristClient.getPhotoList(latitude: latitude, longitutde: longitude, completion: photoListResponseHandler(photoList:error:))
    }
    
    func photoListResponseHandler(photoList: [PhotoMeta], error: Error?) {
        if error != nil {
            // TODO implement showFailure method
            print(error?.localizedDescription ?? "")
        } else {
            for photoMeta in photoList {
                print("photometa: id=\(photoMeta.id), secret=\(photoMeta.secret), server=\(photoMeta.server), farm=\(photoMeta.farm), title=\(photoMeta.title)")
                //        VirtualTouristClient.getPhotoData()
            }
        }
    }
    
    @IBAction func newCollectionButtonTapped() {
        // TODO show CollectionView of photo images which you can choose as many as you hope.
        
    }
    
}


extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15 //photos.count // TODO change the actual variable
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! PhotoCell
        
        // TODO If there are some images which are saved in CoreData, you should show them in CollectionView. If not, you should insert "No Images" label.

//        cell.photoImageView?.image = UIImage(named: "VirtualTourist")
        print("collectionView method passed.")
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO add images to Photo Album if NewCollection button was pushed
        
        // TODO remove images from Photo Album before pushing NewCollection button.
        
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
}
