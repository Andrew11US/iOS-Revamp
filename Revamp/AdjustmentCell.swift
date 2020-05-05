//
//  AdjustmentCell.swift
//  Revamp
//
//  Created by Andrew on 4/25/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class AdjustmentCell: UITableViewCell {

    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // TODO: - Add adjustment icon
    func configureCell(adjustment: String) {
        
        self.nameLbl.text = adjustment
//        self.iconImg.image = UIImage(named: adjustment.name)
    }

}
