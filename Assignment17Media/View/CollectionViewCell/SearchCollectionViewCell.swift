//
//  SearchCollectionViewCell.swift
//  Assignment17Media
//
//  Created by Fu-Chiung HSU on 2019/6/4.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatrImage: UIImageView!
    
    @IBOutlet weak var loginNameLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func loadCell(userInfo: UserInfoObject) {
        avatrImage.loadImage(userInfo.avatarUrl)
        loginNameLable.text = userInfo.login
    }
}
