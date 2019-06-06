//
//  AvtivityIndicator.swift
//  Assignment17Media
//
//  Created by Fu-Chiung HSU on 2019/6/6.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    
    func loadingView(vc: UIViewController) {
        self.center = vc.view.center
        self.hidesWhenStopped = true
        self.style = .gray
        vc.view.addSubview(self)
        self.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
}
