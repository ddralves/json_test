//
//  Geo.swift
//  json_test
//
//  Created by Dino Alves on 2017/03/30.
//  Copyright © 2017 Dino Alves. All rights reserved.
//

import Foundation

// Model used to represent the geo location of an address
class Geo {
    var lat: String = "No latitude supplied!" // Latitude co-ordinates represented as String
    var lng: String = "No longitude supplied!" // Longitude co-ordinates represented as String
    
    /**
     Init for the Geo object.
     
     - parameter lat: Latitude co-ordinate. If none supplied, then default is used.
     - parameter lng: Longitude co-ordinate. If none supplied, then default is used.
     */
    init (lat: String, lng: String) {
        self.lat = lat;
        self.lng = lng;
    }
}
