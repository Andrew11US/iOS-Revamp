//
//  HistoryCell.swift
//  Revamp
//
//  Created by Andrew on 4/25/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class HistoryCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.layer.cornerRadius = CGFloat(5)
        self.imageView.layer.cornerRadius = CGFloat(10)
    }
    
    func configureCell(historyImage: HistoryImage) {
        self.nameLbl.text = historyImage.name
        self.imageView.image = historyImage.image
    }

}
