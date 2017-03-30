//
//  ViewController.swift
//  json_test
//
//  Created by Dino Alves on 2017/03/30.
//  Copyright © 2017 Dino Alves. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userList = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // IBAction for button used to force a fetch of user list
    @IBAction func fetchUsers(_ sender: UIButton) {
        fetchData(completionHandler: nil) // Invoke fetching of data
        
        let alert = UIAlertController(title: "Fetched Users", message: "Users that have been fetched", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
            // Do nothing
        }))
        self.present(alert, animated: true, completion: nil)
    }

    // IBAction for display specific user "Samantha"
    @IBAction func fetchSamantha(_ sender: UIButton) {
        
        // Check if user list is empty. If so, then fetch data first and use completion handler to call the findUser method
        if userList.isEmpty {
            fetchData(completionHandler: {
                self.findUserEmail(withUserName: "Samantha")
            })
        }
        else {
            // List already exists. Call findUser immediately
            findUserEmail(withUserName: "Samantha")
        }
        
    }
    
    func findUserEmail(withUserName: String) {
        
        // Find first occurance of the username
        guard let user = userList.first(where: {
            $0.username == withUserName
        }) else {
            print("Username not found!")
            return
        }
        
        let alert = UIAlertController(title: "E-mail for \(user.username) found!", message: user.email, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alertAction: UIAlertAction!) in
            // Do nothing
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // This method sets up and handles the URL request for the json data
    func fetchData(completionHandler: ((Void) -> Void)?) {
        
        // Give user feedback by means of a loading indicator that will stop animating once data has been obtained and parsed
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 50, y: 10, width: 37, height: 37))
        loadingIndicator.center = self.view.center // Align position
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating()
        self.view.addSubview(loadingIndicator) // Add to main view
        
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
            
            // Only stop loading indicator and run completion handler after data has been fetched
            DispatchQueue.main.async {
                loadingIndicator.stopAnimating()
                // Run the completion handler only if it is not nil
                if completionHandler != nil {
                    completionHandler!()
                }
            }
            
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

