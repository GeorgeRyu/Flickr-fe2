//
//  mapViewController.swift
//  Flickr-fe
//
//  Created by ryu takahashi on 2017/11/02.
//  Copyright © 2017 ryu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var map: MKMapView!
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = photo.title
        let location = CLLocationCoordinate2DMake(49.28061, -123.122463)
        map.setCenter(location,animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2DMake(49.28061, -123.122463)
        pin.title = photo.title
        pin.subtitle = photo.url_o
        map.addAnnotation(pin)
    }
    
    private func initMap() {
        map = MKMapView()
        map.frame = view.frame
        
        var region = map.region
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        map.setRegion(region,animated:true)
        view.addSubview(map)
    }
}
