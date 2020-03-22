//
//  PinViewController.swift
//  VirtualTourist
//
//  Created by Shin Negishi on 3/9/20.
//  Copyright © 2020 6A. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PinViewController: UIViewController {

    // MARK: - Properties
    
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Pin>!
    
    var latitude = 0.0
    var longitude = 0.0
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Life Cycle

    fileprivate func setUpFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "pins")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed. \(error.localizedDescription)")
        }
    }
    
    fileprivate func setDefaultCenterAndSizeOnMap() {
        latitude = UserDefaults.standard.double(forKey: "DefaultLatitude")
        longitude = UserDefaults.standard.double(forKey: "DefaultLongitude")
        let latitudeDelta = UserDefaults.standard.double(forKey: "DefaultLatDelta")
        let longitudeDelta = UserDefaults.standard.double(forKey: "DefaultLonDelta")
        let centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let viewRegion = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(viewRegion, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        let mapPress = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(_:)))
        mapPress.minimumPressDuration = 0.3
        mapView.addGestureRecognizer(mapPress)
        
        setDefaultCenterAndSizeOnMap()
    }
    
    fileprivate func setLoadedPins() {
        let pins = fetchedResultsController.fetchedObjects ?? []
        var annotations = [MKPointAnnotation]()
        for pin in pins {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpFetchedResultsController()
        
        setLoadedPins()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }

    deinit {
        let centerCoordinate = mapView.region.center
        let latitude: Double = centerCoordinate.latitude
        let longitude: Double = centerCoordinate.longitude
        let span = mapView.region.span
        let latitudeDelta: Double = span.latitudeDelta
        let longitudeDelta: Double = span.longitudeDelta
        
        UserDefaults.standard.set(latitude, forKey: "DefaultLatitude")
        UserDefaults.standard.set(longitude, forKey: "DefaultLongitude")
        UserDefaults.standard.set(latitudeDelta, forKey: "DefaultLatDelta")
        UserDefaults.standard.set(longitudeDelta, forKey: "DefaultLonDelta")
    }
}

extension PinViewController: MKMapViewDelegate {

    @objc func addAnnotation(_ recognizer: UIGestureRecognizer) {
        let touchedAt = recognizer.location(in: mapView) // adds the location on the view it was pressed
        let newCoordinates : CLLocationCoordinate2D = mapView.convert(touchedAt, toCoordinateFrom: mapView) // will get coordinates

        let pin = Pin(context: dataController.viewContext)
        pin.latitude = newCoordinates.latitude
        pin.longitude = newCoordinates.longitude
        pin.creationDate = Date()
        try? dataController.viewContext.save()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: "PhotoViewIdentifier", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let photoVC = segue.destination as? PhotoViewController {
            if let pins = fetchedResultsController.fetchedObjects {
                let annotation = mapView.selectedAnnotations[0]
                guard let indexPath = pins.firstIndex(where: { (pin) -> Bool in
                    pin.latitude == annotation.coordinate.latitude && pin.longitude == annotation.coordinate.longitude
                }) else {
                    return
                }
                photoVC.dataController = dataController
                photoVC.pin = pins[indexPath]
//                photoVC.latitude = latitude
//                photoVC.longitude = longitude
            }
        }
    }
}

extension PinViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            let pin = controller.object(at: newIndexPath!) as! Pin
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            mapView.addAnnotation(annotation)
            print("pin inserted")
            break
        default:
            break
        }
    }
}
