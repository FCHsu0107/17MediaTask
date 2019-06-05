//
//  JGProgressHUDWrapper.swift
//  Assignment17Media
//
//  Created by Fu-Chiung HSU on 2019/6/5.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import JGProgressHUD

enum HUDType {
    
    case success(String)
    
    case failure(String)
    
}

class JQProgressHUD {
    
    static let shared = JQProgressHUD()
    
    private init() {}
    
    let hub = JGProgressHUD(style: .dark)
    
    var view: UIView {
        return AppDelegate.shared.window!.rootViewController!.view
    }
    
    static func show(type: HUDType) {
        switch type {
        case .failure(let text):
            showFailure(text: text)
            
        case .success(let text):
            showSuccess(text: text)
        }
    }
    
    
    static func showSuccess(text: String = "Success") {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                showSuccess(text: text)
            }
            return
        }
        
        shared.hub.textLabel.text = text
        
        shared.hub.indicatorView = JGProgressHUDSuccessIndicatorView()
        
        shared.hub.show(in: shared.view, animated: true)
        
        shared.hub.dismiss(afterDelay: 1)
    }
    
    static func showFailure(text: String = "Failure") {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                showFailure(text: text)
            }
            return
        }
        shared.hub.textLabel.text = text
        
        shared.hub.indicatorView = JGProgressHUDErrorIndicatorView()
        
        shared.hub.show(in: shared.view, animated: true)
        
        shared.hub.dismiss(afterDelay: 5)
    }
    
}
