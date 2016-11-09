//
//  CeldaNoticiasTableViewCell.swift
//  scoopfus2
//
//  Created by jose luis saez sanchez on 5/11/16.
//  Copyright © 2016 JoseFusFus. All rights reserved.
//

import UIKit

class CeldaNoticiasTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBOutlet weak var imagenNoticia: UIImageView!
    
    
    @IBOutlet weak var tituloNoticia: UILabel!
    
    
    @IBOutlet weak var situacionNoticia: UILabel!
    
    @IBOutlet weak var estadoBotonPublicar: UIButton!
    
    @IBAction func publicarNoticia(_ sender: AnyObject) {
        
        
    }
    
    
    
}
