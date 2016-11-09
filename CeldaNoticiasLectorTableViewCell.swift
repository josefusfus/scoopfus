//
//  CeldaNoticiasLectorTableViewCell.swift
//  scoopfus2
//
//  Created by jose luis saez sanchez on 9/11/16.
//  Copyright © 2016 JoseFusFus. All rights reserved.
//

import UIKit

class CeldaNoticiasLectorTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var imageviewCeldaNoticia: UIImageView!
    

    @IBOutlet weak var titleCeldaNoticia: UILabel!
    
    
    @IBOutlet weak var autorCeldaNoticia: UILabel!
}
