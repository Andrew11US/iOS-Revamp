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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(adjustment: String) {
        
        self.nameLbl.text = adjustment
    }

}
