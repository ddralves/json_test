//
//  ViewController.swift
//  json_test
//
//  Created by Dino Alves on 2017/03/30.
//  Copyright © 2017 Dino Alves. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var userList = [User()]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // IBAction for button used to force a fetch of user list
    @IBAction func fetchUsers(_ sender: UIButton) {
        fetchData() // Invoke fetching of data
    }

    // IBAction for display specific user "Samantha"
    @IBAction func fetchSamantha(_ sender: UIButton) {
    }
    
    // This method sets up and handles the URL request for the json data
    func fetchData() {
        
        // Create URL from constant string
        guard let url = URL(string: USERS_URL_STRING) else {
            print("Failed to create URL from \(USERS_URL_STRING)")
            return
        }
        
        // Setup the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // Make the request
        let task = session.dataTask(with: url) { (data, response, error) in
            
            // Check for error
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            // Since there is no error, we can assume data was retrieved
            self.handleRequest(data: data!)
            
            // TODO: Reload data on the list view here
            
        }
        
        task.resume() // Resume task to fetch data
        
    }
    
    /**
     This function handles parsing of the requested data
     
     - parameter data: Data object to be parsed
     */
    func handleRequest(data: Data) {
        
        do {
            
            // Transform received data into json object
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: AnyObject]]
            
            // Start constructing posts into User list array
            for dictionary in json {
                
                // Create default objects
                let address = Address()
                let geo = Geo()
                let company = Company()
                
                // Retrieve address dictionary and populate variables
                if let addressDictionary = dictionary["address"] as? [String: AnyObject] {
                    address.street = addressDictionary["street"] as! String
                    address.suite = addressDictionary["suite"] as! String
                    address.city = addressDictionary["city"] as! String
                    address.zipcode = addressDictionary["zipcode"] as! String
                    
                    // Retreive geo dictionary and populate variables
                    if let geoDictionary = addressDictionary["geo"] as? [String: AnyObject] {
                        geo.lat = geoDictionary["lat"] as! String
                        geo.lng = geoDictionary["lng"] as! String
                    }
                    
                    address.geo = geo
                    
                }
                
                // Retrieve company dictionary and populate variables
                if let companyDictionary = dictionary["company"] as? [String: AnyObject] {
                    company.name = companyDictionary["name"] as! String
                    company.catchPhrase = companyDictionary["catchPhrase"] as! String
                    company.bs = companyDictionary["bs"] as! String
                }
                
                // Now create the user model and load all variables and objects into it
                let user = User(id: dictionary["id"] as! Int, name: dictionary["name"] as! String, username: dictionary["username"] as! String, email: dictionary["email"] as! String, address: address, phone: dictionary["phone"] as! String, website: dictionary["website"] as! String, company: company)
                
                userList.append(user)
                
                print("user name -> \(user.name)")
                print("street -> \(user.address.street)")
                print("latitude -> \(user.address.geo.lat)")
                print("company name -> \(user.company.name)")
            }
            
            
            
        } catch let error as NSError {
            print("Handle Request failed with error: \(error.debugDescription)")
        }
    }
}

