//
//  ViewController.swift
//  Assignment17Media
//
//  Created by Fu-Chiung HSU on 2019/6/3.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    var userInfoItems: [UserInfoObject] = [UserInfoObject(login: "wujunchuan", url: "https://api.github.com/users/wujunchuan", avatarUrl: "https://avatars1.githubusercontent.com/u/7511631?v=4"), UserInfoObject(login: "wujunchuan", url: "https://api.github.com/users/wujunchuan", avatarUrl: "https://avatars1.githubusercontent.com/u/7511631?v=4"), UserInfoObject(login: "wujunchuan", url: "https://api.github.com/users/wujunchuan", avatarUrl: "https://avatars1.githubusercontent.com/u/7511631?v=4"), UserInfoObject(login: "wujunchuan", url: "https://api.github.com/users/wujunchuan", avatarUrl: "https://avatars1.githubusercontent.com/u/7511631?v=4"), UserInfoObject(login: "wujunchuan", url: "https://api.github.com/users/wujunchuan", avatarUrl: "https://avatars1.githubusercontent.com/u/7511631?v=4"), UserInfoObject(login: "wujunchuan", url: "https://api.github.com/users/wujunchuan", avatarUrl: "https://avatars1.githubusercontent.com/u/7511631?v=4"), UserInfoObject(login: "wujunchuan", url: "https://api.github.com/users/wujunchuan", avatarUrl: "https://avatars1.githubusercontent.com/u/7511631?v=4"), UserInfoObject(login: "wujunchuan", url: "https://api.github.com/users/wujunchuan", avatarUrl: "https://avatars1.githubusercontent.com/u/7511631?v=4"), UserInfoObject(login: "wujunchuan", url: "https://api.github.com/users/wujunchuan", avatarUrl: "https://avatars1.githubusercontent.com/u/7511631?v=4"), UserInfoObject(login: "wujunchuan", url: "https://api.github.com/users/wujunchuan", avatarUrl: "https://avatars1.githubusercontent.com/u/7511631?v=4"), UserInfoObject(login: "wujunchuan", url: "https://api.github.com/users/wujunchuan", avatarUrl: "https://avatars1.githubusercontent.com/u/7511631?v=4"), UserInfoObject(login: "wujunchuan", url: "https://api.github.com/users/wujunchuan", avatarUrl: "https://avatars1.githubusercontent.com/u/7511631?v=4")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
    
    private func setUpCollectionView() {
        
        collectionView.jq_registerCellWithNib(
            identifier: String(describing: SearchCollectionViewCell.self),
            bundle: nil)
        
        setUpCollectionViewLayout()
    }
    
    private func setUpCollectionViewLayout() {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(width: Int(UIScreen.main.bounds.width), height: 110)
        
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        flowLayout.minimumLineSpacing = 0
        
        flowLayout.minimumInteritemSpacing = 0
        
        collectionView.collectionViewLayout = flowLayout
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userInfoItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SearchCollectionViewCell.self), for: indexPath)
        
        guard let searchCell = cell as? SearchCollectionViewCell else { return cell }
        
        let userInfo = userInfoItems[indexPath.item]
        
        searchCell.loadCell(userInfo: userInfo)
        
        return searchCell
    }
    
    
}
