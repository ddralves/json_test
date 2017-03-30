//
//  Geo.swift
//  json_test
//
//  Created by Dino Alves on 2017/03/30.
//  Copyright © 2017 Dino Alves. All rights reserved.
//

import Foundation

// Model used to represent the geo location of an address
// TODO: Look at making the Geo a struct so that it is passed by value and not refernce as this could breakt he functionality
class Geo {
    var lat: String = "No latitude supplied!" // Latitude co-ordinates represented as String
    var lng: String = "No longitude supplied!" // Longitude co-ordinates represented as String
    
    /**
     Default init
     */
    init() {
        // Do nothing
    }
    
    /**
     Init
     
     - parameter lat: Latitude co-ordinate. If none supplied, then default is used.
     - parameter lng: Longitude co-ordinate. If none supplied, then default is used.
     
     TODO: Might not need this init
     */
    init (lat: String, lng: String) {
        self.lat = lat;
        self.lng = lng;
    }
}
