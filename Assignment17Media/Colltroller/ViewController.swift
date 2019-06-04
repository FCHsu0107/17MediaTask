//
//  ViewController.swift
//  Assignment17Media
//
//  Created by Fu-Chiung HSU on 2019/6/3.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBarTextField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    var userInfoItems: [UserInfoObject] = [] {
        didSet {
            reloadData()
        }
    }
    
    var searchParameter: SearchParameter?
    
    let provider = UserProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboradWhenTappedAround()
        
        setUpCollectionView()
    }
    
    
    @IBAction func clickSreachBtn(_ sender: Any) {
        if searchBarTextField.text?.isEmpty == false {
            guard let text = searchBarTextField.text else { return }
            searchParameter?.keyword = text
            searchUsers(text: text)
        }
    }
    
    private func searchUsers(text: String) {
        provider.fetchSreachResults(keyworkd: text, paging: 1) { [weak self] (result) in
            switch result {
            case .success(let data):
                self?.userInfoItems = data.results.items
                print("-----paging------")
                guard let paging = data.paging else { return }
                self?.searchParameter?.paging = paging
                print(self?.searchParameter?.paging)
                
            case .failure(let error):
                print(error)
            }
        }
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
    
    private func reloadData() {
        guard Thread.isMainThread == true else {
            DispatchQueue.main.async { [weak self] in
                self?.reloadData()
            }
            return
        }
        
        collectionView.reloadData()
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
