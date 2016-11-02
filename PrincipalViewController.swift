//
//  PrincipalViewController.swift
//  scoopfus2
//
//  Created by jose luis saez sanchez on 31/10/16.
//  Copyright © 2016 JoseFusFus. All rights reserved.
//

import UIKit


typealias AutorRecord = Dictionary<String, AnyObject>

class PrincipalViewController: UIViewController {
    
    
    var client: MSClient = MSClient(applicationURL: URL(string: "https://scoopfus1-practica.azurewebsites.net")!)
    
    var model: [Dictionary<String, AnyObject>]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
           
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  

    @IBAction func loginAutor(_ sender: AnyObject) {
        
        if let _ = client.currentUser {
            
            self.performSegue(withIdentifier: "authenticatedview", sender: self)
            
        } else {
            
            client.login(withProvider: "facebook", parameters: nil, controller: self, animated: true) { (user, error) in
                
                if let _ = error {
                    let alert = UIAlertController(title: "Login Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
                        (action) -> Void in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                if let _ = user {
                    
                 //   MSAITelemetryManager.trackEvent(withName: "User logged with Facebook", properties: ["userid": user!.userId! ])
                    
                    self.performSegue(withIdentifier: "authenticatedview", sender: self)
                }
            }
        }
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
