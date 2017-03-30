//
//  Address.swift
//  json_test
//
//  Created by Dino Alves on 2017/03/30.
//  Copyright © 2017 Dino Alves. All rights reserved.
//

import Foundation

// Model used to represent the physical address of the user
// TODO: Look at making the Address a struct so that it is passed by value and not refernce as this could breakt he functionality
class Address {
    var street: String = "No street name supplied!" // Street address
    var suite: String = "No suite name supplied!" // Suite name
    var city: String = "No city name supplied!" // Name of city
    var zipcode: String = "No zipcode supplied!" // Zipcode
    var geo = Geo() // Geo location of address. Set to default
    
    /**
     Default init
     */
    init() {
        // Do nothing
    }
    
    /**
     Init
     
     - parameters:
        - street: Street address name
        - suite: Suite name
        - city: City name
        - zipcode: Zipcode number
        - geo: Geo-location co-ordinates supplied as a Geo object with latitude and longitude
     */
    init(street: String, suite: String, city: String, zipcode: String, geo: Geo) {
        self.street = street
        self.suite = suite
        self.city = city
        self.zipcode = zipcode
        self.geo = geo
    }
}
