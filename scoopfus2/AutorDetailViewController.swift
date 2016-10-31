//
//  AutorDetailViewController.swift
//  scoopfus2
//
//  Created by jose luis saez sanchez on 30/10/16.
//  Copyright © 2016 JoseFusFus. All rights reserved.
//

import UIKit

class AutorDetailViewController: UIViewController {

    var model: AutorRecord?
    var client: MSClient?
    
    @IBOutlet weak var namelbl: UILabel! {
        didSet{
        namelbl.text = model?["name"] as! String?
        }
    }
    
    @IBOutlet weak var secondlbl: UILabel!{
        didSet{
            secondlbl.text = model?["secondname"] as! String?
            
        }
    }
    
    @IBOutlet weak var styletxt: UITextField! {
        didSet{
            guard let estilo = model?["style"], !(estilo is NSNull) else {
                
                return
            }
            
            styletxt.text = estilo as? String
        }
    }
    
    
    @IBOutlet weak var idiomatxt: UITextField! {
                didSet {
            guard let idioma = model?["idioma"], !(idioma is NSNull) else {
    
                return
            }
    
            idiomatxt.text = idioma as? String
    }
}

    
    
    @IBAction func updateNewDataAutor(_ sender: AnyObject) {
        
        updateAutor()
        
        
    }
    
    @IBAction func callCustomApiAction(_ sender: AnyObject) {
        
        callCustomApi()
        
        
    }
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
           // callCustomApi()

        // Do any additional setup after loading the view.
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateAutor() {
        
        let tableAz = client?.table(withName: "Autores")
        
        // check de datos
        model!["style"] = styletxt.text as AnyObject?
        model!["idioma"] = idiomatxt.text as AnyObject?
        
        
        tableAz?.update(model!, completion: { (result, error) in
        
            if let _ = error {
                
                print(error)
                return
            }
        
            
            print(result)
        })
        
    }
    
    func callCustomApi() {
        
        
        client?.invokeAPI("customapi1",
                          body: nil,
                          httpMethod: "GET",
                          parameters: ["nombre" : namelbl.text],
                          headers: nil,
                          completion: { ( result, response, error) in
                            
                            
                            if let _ = error {
                                
                                print(error)
                                return
                            }
                            
                            
                            print(result)
                            
                        
        
                        })
        
        
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
