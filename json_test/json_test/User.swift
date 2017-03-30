//
//  User.swift
//  json_test
//
//  Created by Dino Alves on 2017/03/30.
//  Copyright © 2017 Dino Alves. All rights reserved.
//

import Foundation

// Model used to represent each user
class User {
    
    var id: Int? // Unique ID representing the user. Optional as this cannot not be defaulted
    var name: String = "User's name not supplied!" // Name of the user
    var username: String = "Username not supplied!" // Username of the user
    var email: String = "No e-mail supplied!" // E-mail address of user
    var address = Address() // User's physical address
    var phone: String = "No phone number supplied!" // User's phone number
    var website: String = "Website link not supplied!" // User's website link
    var company = Company() // User's associated company
    
    /**
     Default init
     */
    init() {
        // Do nothing
    }
    
    /**
     Inits
     
     - paramters:
        - id: Unique user ID
        - name: User's name
        - username: Username of the user
        - email: E-mail address of user
        - address: User's physical address
        - phone: User's phone number
        - website: User's website link
        - company: User's associated company
     */
    init(id: Int, name: String, username: String, email: String, address: Address,
         phone: String, website: String, company: Company) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.address = address
        self.phone = phone
        self.website = website
        self.company = company
    }
}
