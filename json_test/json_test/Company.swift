//
//  Company.swift
//  json_test
//
//  Created by Dino Alves on 2017/03/30.
//  Copyright © 2017 Dino Alves. All rights reserved.
//

import Foundation

// Model used to represent the company that is associated with each user
// TODO: Look at making the Company a struct so that it is passed by value and not refernce as this could breakt he functionality
class Company {
    var name: String = "No company name supplied!"
    var catchPhrase: String = "No catch phrase supplied!"
    var bs: String = "No business slogan supplied!"
    
    /**
     Default init
     */
    init() {
        // Do nothing
    }
    
    /**
     Init
     
     - parameters:
        - name: Name of company
        - catchPhrase: Catchphrase of company
        - bs: Business slogan of company
     
     TODO: Might not need this init
     */
    init(name: String, catchPhrase: String, bs: String) {
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
    }
}
