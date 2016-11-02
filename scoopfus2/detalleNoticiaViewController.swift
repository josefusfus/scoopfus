//
//  detalleNoticiaViewController.swift
//  scoopfus2
//
//  Created by jose luis saez sanchez on 2/11/16.
//  Copyright © 2016 JoseFusFus. All rights reserved.
//

import UIKit

class detalleNoticiaViewController: UIViewController {
    
    var model: AutorRecord?
    var client: MSClient?

    @IBOutlet weak var titlelbl: UILabel! {
        
        didSet{
        titlelbl.text = model?["title"] as! String?
            }
    }
    
    @IBOutlet weak var autorlbl: UILabel!{
        didSet{
            
            guard let author = model?["author"], !(author is NSNull) else {
                
                return
            }
        
                autorlbl.text = author as? String
            
        }
    }
    
    
    @IBOutlet weak var textoNoticialbl: UITextView!{
        
        didSet{
            
            guard  let text = model?["text"], !(text is NSNull) else {
                return
            }
            
            textoNoticialbl.text = text as? String
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
   
}
