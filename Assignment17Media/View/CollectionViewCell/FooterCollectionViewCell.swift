//
//  FooterCollectionViewCell.swift
//  Assignment17Media
//
//  Created by Fu-Chiung HSU on 2019/6/4.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class FooterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var footerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func showEnd(paging: Int?) {
        if paging == nil {
            footerLabel.text = "End"
            
        } else if paging == 1 {
            footerLabel.text = ""
            
        } else {
            footerLabel.text = "Loading..."
        }
    }

}
