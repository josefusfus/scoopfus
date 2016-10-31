//
//  AnonymousTableViewController.swift
//  scoopfus2
//
//  Created by jose luis saez sanchez on 31/10/16.
//  Copyright © 2016 JoseFusFus. All rights reserved.
//

import UIKit

//typealias AutorRecord = Dictionary<String, AnyObject>


class AnonymousTableViewController: UITableViewController {
    
    var client: MSClient = MSClient(applicationURL: URL(string: "https://scoopfus1-practica.azurewebsites.net")!)
    
    var model: [Dictionary<String, AnyObject>]? = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        readAllItemsInTable()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    
    
    func readAllItemsInTable() {
        
        client.invokeAPI("readAllRecords", body: nil, httpMethod: "GET", parameters: nil, headers: nil) { (result,response,error) in
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdanoticia", for: indexPath)
        
        // Configure the cell...
        
        let item = model?[indexPath.row]
        
        cell.textLabel?.text = item?["name"] as! String?
        
        return cell
        
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = model?[indexPath.row]
        
        performSegue(withIdentifier: "detalleNoticia", sender: item)
    }
    
    
   

    // MARK: - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 
    if segue.identifier == "detalleNoticia"{
 
        let vc = segue.destination as? AutorDetailViewController
 
        vc?.client = client
        vc?.model = sender as? AutorRecord
 
 
        }
 
 
    }
 
 }
