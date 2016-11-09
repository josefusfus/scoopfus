//
//  AutorTableViewController.swift
//  scoopfus2
//
//  Created by jose luis saez sanchez on 28/10/16.
//  Copyright © 2016 JoseFusFus. All rights reserved.
//

import UIKit


//typealias AutorRecord = Dictionary<String, AnyObject>

class AutorTableViewController: UITableViewController {
    
    
    var client: MSClient = MSClient(applicationURL: URL(string: "https://scoopfus1-practica.azurewebsites.net")!)

    var model: [Dictionary<String, AnyObject>]? = []
    
    
    let blobClient: AZSCloudBlobClient = (try! AZSCloudStorageAccount(credentials: AZSStorageCredentials(accountName: "practicafusstorage", accountKey: "X9E6W8pcuZWZOSlKiy49KA4cl9RSRP25Uctz0uSF0EefXfgdB8O8DKDYimAIuWZfR25tABXYjsrIzdTAM4rxPA=="), useHttps: true)).getBlobClient()
    
    let blobContainer = "fuspracticacontainer"
    
    var predicate : NSPredicate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let _ = client.currentUser {
       
        readAllItemsInTable()
            
        } else {
            
            doLoginInFacebook()
            
        }
    }
    
    func doLoginInFacebook(){
        
        client.login(withProvider: "facebook", parameters: nil, controller: self, animated: true) { (user, error) in
         
            if let _ = error {
                
                print(error)
                return
            }
            
            if let _ = user {
                
                self.readAllItemsInTable()
            }
            
        }
    }

       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Insert en la tabla de autores
    /*
    func addNewAutor(_ title: String, text: String, autor: String) {
        
        let tableMS = client.table(withName: "Noticias")
        
        tableMS.insert(["title" : title, "text": text, "author": autor]) { (result, error) in
            
            if let _ = error {
                
                print(error)
                return
            }
            self.readAllItemsInTable()
            print(result)
            
            
            }
        
        }  */
    
    
    func readAllItemsInTable() {
        
        predicate = NSPredicate(format: "userid == %@", (client.currentUser?.userId!)!)
        
        client.invokeAPI("readAllRecords", body: nil, httpMethod: "GET", parameters:["userid": (client.currentUser?.userId!)!] , headers: nil) { (result,response,error) in
            
            if let _ = error {
                
                print(error)
                return
            }
            
            if !(self.model?.isEmpty)!{
                
                self.model?.removeAll()
            }
            
            if let _ = result {
                
                let json = result as! [AutorRecord]
                
                for item in json {
                    
                    self.model?.append(item)
                }
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                }
            }
        }

        
        /*     tableMS.read(with: predicate) { (result, error) in
         
         if let _ = error {
         
         print(error)
         return
         }
         
         if let items = result {
         
         for item in items.items! {
         
         self.model?.append(item as! [String : AnyObject])
         }
         
         DispatchQueue.main.async {
         
         self.tableView.reloadData()
         }
         }
         
         } */
    }

    
        func deleteRecord(_ item: AutorRecord) {
            
            let tableMS = client.table(withName: "Noticias")
            
            tableMS.delete(item) { (reult, error) in
                
                if let _ = error {
                    print(error)
                    return
                }
                
                // refrescar la tabla
                self.readAllItemsInTable()
            }
            
            
        }

    
    func download(blob b:String, _ completion:  @escaping (Any)->()) {
        
        let container = blobClient.containerReference(fromName: blobContainer)
        
        let blob = container.blockBlobReference(fromName: b)
        
        blob.downloadToData { (error, data) in
            if let _ = error{
                print(error)
                return
            }
            completion(data)
        }
    }

        
  
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if (model?.isEmpty)!{
            return 0
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (model?.isEmpty)!{
        return 0
        }
        
        return (model?.count)!
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELDANOTICASAUTOR", for: indexPath) as! CeldaNoticiasTableViewCell

        // Configure the cell...

        var item = model?[indexPath.row]
        
        cell.tituloNoticia?.text = item?["title"] as! String?
        
        /*
        self.download(blob: item.imageURL) { (data) in
            item.blob = data as? Data
            cell.ImageNew.image = UIImage(data: data as! Data)
        } */
        
        
        
        let publicada = item?["published"] as! Bool?
        
        if publicada == true {
            
            cell.situacionNoticia.text = "Publicada"
            cell.estadoBotonPublicar.setTitle("Dar de baja", for: .normal)
            
        }else{
            cell.situacionNoticia.text = "No publicada"
            cell.estadoBotonPublicar.setTitle("Publicar", for: .normal)
        }
        
        return cell

    }
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            let item = self.model?[indexPath.row]
            
            self.deleteRecord(item!)
            self.model?.remove(at: indexPath.row)
            
            tableView.endUpdates()

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = model?[indexPath.row]
        
        performSegue(withIdentifier: "detalleNoticia", sender: item)
    }
    
     */
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "nuevaNoticia"{
            
            let vc = segue.destination as? AutorDetailViewController
            
            vc?.client = client
            vc?.model = sender as? AutorRecord
            
            
        
    }
   

}
 
    


}
