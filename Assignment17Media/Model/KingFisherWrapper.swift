//
//  KingFisherWrapper.swift
//  Assignment17Media
//
//  Created by Fu-Chiung HSU on 2019/6/3.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func loadImage(_ urlString: String) {
        
        let url = URL(string: urlString)
        
        self.kf.setImage(with: url)
        
    }
    
}
