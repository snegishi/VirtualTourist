//
//  PhotoViewController.swift
//  VirtualTourist
//
//  Created by Shin Negishi on 3/9/20.
//  Copyright © 2020 6A. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoViewController: UIViewController {
    
    // MARK: - Properties
    
    var pin: Pin!
    
    var dataController: DataController!
    
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    
    var photos = ["https://"]
//    var latitude = 0.0
//    var longitude = 0.0
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newCollectionButton: UIButton!
    
    // MARK: - Life Cycle
    
    fileprivate func setUpFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed. \(error.localizedDescription)")
        }
    }
    
    fileprivate func centerTheSelectedLocationOnMap() {
        let centerCoordinate = CLLocationCoordinate2DMake(pin.latitude, pin.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let viewRegion = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(viewRegion, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = centerCoordinate
        mapView.addAnnotation(annotation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpFetchedResultsController()
        
        centerTheSelectedLocationOnMap()
        
        let photos = fetchedResultsController.fetchedObjects
        if photos!.count == 0 {
            DispatchQueue.main.async {
                self.setDownloadingIn(true)
                print("start download")
            }
            let photoDownloader = PhotoDownloader(pin: pin)
            photoDownloader.dataController = dataController
            photoDownloader.download()
            
            // TODO execute the following code after donwloading images
            DispatchQueue.main.async {
                self.setDownloadingIn(false)
                print("end download")
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
        
    @IBAction func newCollectionButtonTapped() {
        // TODO show CollectionView of photo images which you can choose as many as you hope.
        
    }
    
    func setDownloadingIn(_ downloadingIn: Bool) {
        if downloadingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        newCollectionButton.isEnabled = !downloadingIn
    }
}


extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let aPhoto = fetchedResultsController.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell ", for: indexPath) as! PhotoCell
        
        // TODO If there are some images which are saved in CoreData, you should show them in CollectionView. If not, you should insert "No Images" label.

        cell.photoImageView?.image = UIImage(data: aPhoto.image!)
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

extension PhotoViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
//            collectionView.reloadData()
            collectionView.insertItems(at: [newIndexPath!])
            print("photo inserted")
            break
//        case .delete:
//            // TODO remove the chosen images
//            break
        default:
            break
        }
    }
}
