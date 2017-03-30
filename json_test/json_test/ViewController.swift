//
//  ViewController.swift
//  json_test
//
//  Created by Dino Alves on 2017/03/30.
//  Copyright © 2017 Dino Alves. All rights reserved.
//

import UIKit

/**
 Main view controller for this project
 */
class ViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField! // E-mail search text field
    
    var userList = [User]() // Create empty array of User objects

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allow user to tap anywhere in the screen to hide keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dissmissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        // Assign text field delegate to handle keyboard enter
        usernameTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // IBAction for button used to force a fetch and display of user list
    @IBAction func fetchUsers(_ sender: UIButton) {
        
        if userList.isEmpty {
            // Invoke fetching of data first and then display the alert
            fetchData(completionHandler: {
                self.displayNameListAlert()
            })
        } else {
            // User list already exists so display alert immediately
            displayNameListAlert()
        }
        
    }

    // IBAction for fetching and displaying specific username "Samantha" email address
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
    
    // IBAction used to search user list for email by means of a supplied username
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchForEmail()
    }
    
    
    /** 
     This function sets up and handles the URL request for the json data. It will then run an optional completion handler if necessary.
     
     - parameter completionHandler: Any closure that needs to run after the data has been fetched successfully
     */
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
                if let addressDictionary = dictionary[USER_ADDRESS_KEY] as? [String: AnyObject] {
                    address.street = addressDictionary[ADDRESS_STREET_KEY] as! String
                    address.suite = addressDictionary[ADDRESS_SUITE_KEY] as! String
                    address.city = addressDictionary[ADDRESS_CITY_KEY] as! String
                    address.zipcode = addressDictionary[ADDRESS_ZIPCODE_KEY] as! String
                    
                    // Retreive geo dictionary and populate variables
                    if let geoDictionary = addressDictionary[ADDRESS_GEO_KEY] as? [String: AnyObject] {
                        geo.lat = geoDictionary[GEO_LAT_KEY] as! String
                        geo.lng = geoDictionary[GEO_LNG_KEY] as! String
                    }
                    
                    address.geo = geo
                    
                }
                
                // Retrieve company dictionary and populate variables
                if let companyDictionary = dictionary[USER_COMPANY_KEY] as? [String: AnyObject] {
                    company.name = companyDictionary[COMPANY_NAME_KEY] as! String
                    company.catchPhrase = companyDictionary[COMPANY_CATCHPHRASE_KEY] as! String
                    company.bs = companyDictionary[COMPANY_BS_KEY] as! String
                }
                
                // Now create the user model and load all variables and objects into it
                let user = User(id: dictionary[USER_ID_KEY] as! Int, name: dictionary[USER_NAME_KEY] as! String, username: dictionary[USER_USERNAME_KEY] as! String, email: dictionary[USER_EMAIL_KEY] as! String, address: address, phone: dictionary[USER_PHONE_KEY] as! String, website: dictionary[USER_WEBSITE_KEY] as! String, company: company)
                
                // Finally add user to the list
                userList.append(user)
            }
        } catch let error as NSError {
            print("Handle Request failed with error: \(error.debugDescription)")
        }
    }
    
    /**
     This function runs through the list of users and finds the e-mail address of the supplied username. It then displays the e-mail via an alert
     
     - parameter withUserName: username to search the list for
     */
    func findUserEmail(withUserName: String) {
        
        // Find first occurance of the username
        guard let user = userList.first(where: {
            $0.username == withUserName
        }) else {
            
            // Init the alert controller
            let alert = UIAlertController(title: "Something is wrong!", message: "E-mail for \(withUserName) not found!", preferredStyle: UIAlertControllerStyle.alert)
            
            // Assign an action button to this alert
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: { (alertAction: UIAlertAction!) in
                // Do nothing
            }))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // Init the alert controller
        let alert = UIAlertController(title: "E-mail for \(user.username) found!", message: user.email, preferredStyle: UIAlertControllerStyle.alert)
        
        // Assign an action button to this alert
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alertAction: UIAlertAction!) in
            // Do nothing
        }))
        
        // Show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     This function will prepare and present a alert with the list of names of all the users in the list
     */
    func displayNameListAlert() {
        
        // Create an empty string to be showed as a message in the alert later
        var message = ""
        
        // Populate the string with user's names and carraige return
        for user in self.userList {
            message += user.name + "\n"
        }
        
        // Init the alert
        let alert = UIAlertController(title: "Fetched Users", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // Assign an action button for this alert
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
            // Do nothing
        }))
        
        // Show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // This function handles the search of emails using the user's username
    func searchForEmail() {
        
        // Hide keyboard
        dissmissKeyboard()
        
        guard let username = usernameTextField.text else {
            let alert = UIAlertController(title: "Something is wrong", message: "No username supplied!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try Again!", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                // Do nothing
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if userList.isEmpty {
            fetchData(completionHandler: {
                self.findUserEmail(withUserName: username)
            })
        }
        else {
            // List already exists. Call findUser immediately
            findUserEmail(withUserName: username)
        }
        
    }
    
    // This function hides the keyboard of the usernameTextField
    func dissmissKeyboard() {
        usernameTextField.endEditing(true)
    }
}

/**
 Extension of ViewController to handle the behaviour of the "return" button on the keyboard for the text field.
 */
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchForEmail()
        dissmissKeyboard()
        return true
    }
}
