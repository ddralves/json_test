//
//  Company.swift
//  json_test
//
//  Created by Dino Alves on 2017/03/30.
//  Copyright © 2017 Dino Alves. All rights reserved.
//

import Foundation

// TODO: Look at making the Company a struct so that it is passed by value and not refernce as this could breakt he functionality
class Company {
    var name: String = "No company name supplied!"
    var catchPhrase: String = "No catch phrase supplied!"
    var bs: String = "No bs supplied!"
    
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
        - bs: Bs of company
     */
    init(name: String, catchPhrase: String, bs: String) {
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
    }
}
