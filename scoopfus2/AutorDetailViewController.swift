//
//  AutorDetailViewController.swift
//  scoopfus2
//
//  Created by jose luis saez sanchez on 30/10/16.
//  Copyright © 2016 JoseFusFus. All rights reserved.
//

import UIKit
import CoreLocation

class AutorDetailViewController: UIViewController, CLLocationManagerDelegate {

    var model: AutorRecord?
    var client: MSClient?
    var container: AZSCloudBlobContainer?
    var locationManager : CLLocationManager?
    var location : CLLocation = CLLocation(latitude: 0, longitude: 0)

    
    let blobClient: AZSCloudBlobClient = (try! AZSCloudStorageAccount(credentials: AZSStorageCredentials(accountName: "practicafusstorage", accountKey: "X9E6W8pcuZWZOSlKiy49KA4cl9RSRP25Uctz0uSF0EefXfgdB8O8DKDYimAIuWZfR25tABXYjsrIzdTAM4rxPA=="), useHttps: true)).getBlobClient()
    
    
    //let client : MSClient = MSClient(applicationURLString: "https://scoopfus1-practica.azurewebsites.net")
    
   // let accountKey = "X9E6W8pcuZWZOSlKiy49KA4cl9RSRP25Uctz0uSF0EefXfgdB8O8DKDYimAIuWZfR25tABXYjsrIzdTAM4rxPA=="
    
    // let accountName = "practicafusstorage"
    let blobContainer = "fuspracticacontainer"
    
    //let account : AZSCloudStorageAccount
    
    
       //   let credentials = AZSStorageCredentials(accountName: accountName, accountKey: accountKey)
        // account = try! AZSCloudStorageAccount(credentials: credentials, useHttps: true)
   
    
    
    
   

    
       @IBOutlet weak var titulotxt: UITextField! {
        didSet{
            
            guard let estilo = model?["title"], !(estilo is NSNull) else {
                
                return
            }
            
            titulotxt.text = estilo as? String
        }
    }

    
    @IBOutlet weak var textoNoticiatxt: UITextField! {
                didSet {
                    
            guard let contenido = model?["text"], !(contenido is NSNull) else {
    
                return
            }
    
            textoNoticiatxt.text = contenido as? String
    }
}

    
    @IBOutlet weak var autortxt: UITextField!
    
    @IBAction func addNewNews(_ sender: AnyObject) {
        
      addNewAutor(titulotxt.text!, text: textoNoticiatxt.text!, autor: autortxt.text!)
        
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.startUpdatingLocation()
    
    }
    
    
    // Localización actual
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager?.stopUpdatingLocation()
        self.locationManager = nil
        if let lastLocation:CLLocation = locations.last {
            self.location = lastLocation
        }
    }
    
    @IBAction func selectedImage(_ sender: AnyObject) {
        
        // Crear una instancia de UIImagePicker
        let picker = UIImagePickerController()
        
        // Configurarlo
    
        if UIImagePickerController.isCameraDeviceAvailable(.rear){
            picker.sourceType = .camera
        }else{
            // me conformo con el carrete */
            picker.sourceType = .photoLibrary
       
        }
        
        
        picker.delegate = self
        
        // Mostrarlo de forma modal
        self.present(picker, animated: true) {
            // Por si quieres hacer algo nada más
            // mostrarse el picker
        }

        
    
}







    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func addNewAutor(_ title: String, text: String, autor: String) {
        
      /*  let imageData = UIImageJPEGRepresentation(["image"] as! UIImage, 0.85)
        
        let urlBlob = UUID().uuidString
        
        self.uploadBlob(data: imageData!, nameFile: urlBlob) */
        
        let tableMS = client?.table(withName: "Noticias")
        
        tableMS?.insert(["title" : title,
                         "text": text,
                         "author": autor,
                         "published": false,
                         //"image":photoImageView.image
                         "latitude" : self.location.coordinate.latitude,
                         "longitude" : self.location.coordinate.longitude]) { (result, error) in
            
            if let _ = error {
                
                print(error)
                return
            }
            //self.readAllItemsInTable()
            print(result as Any)
            
            
        }
        
    }
    
    
    /*
    func uploadBlob(data:Data, nameFile: String){
        
        let client : AZSCloudBlobClient? = (try! AZSCloudStorageAccount(credentials: AZSStorageCredentials(accountName: "practicafusstorage", accountKey: "X9E6W8pcuZWZOSlKiy49KA4cl9RSRP25Uctz0uSF0EefXfgdB8O8DKDYimAIuWZfR25tABXYjsrIzdTAM4rxPA=="), useHttps: true)).getBlobClient()
    
        let container = client?.containerReference(fromName: blobContainer)
        
        container?.createContainerIfNotExists(with: .container, requestOptions: nil, operationContext: nil, completionHandler: { (error, status) in
            
            if let _ = error{
                print(error)
                return
            }
            let blob = container?.blockBlobReference(fromName: nameFile )
            blob?.upload(from: data) { (e) in
                if e != nil{
                    print(error)
                    return
                }
            }
        })
    }

    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


    extension AutorDetailViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            
            let size = CGSize(width: 600, height: 600);
            
            let photo = info[UIImagePickerControllerOriginalImage] as! UIImage?
            
            photoImageView.image = photo
            
            self.dismiss(animated: true) {
                //
            }
            
        }
}



