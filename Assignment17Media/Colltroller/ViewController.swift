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
    
    
    @IBOutlet weak var remindLabel: UILabel!
    
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
    
    var isFetching: Bool = false
    
    var nextPage: Int? = 1
    
    let provider = UserProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboradWhenTappedAround()
        
        setUpCollectionView()
    }
    
    
    @IBAction func clickSreachBtn(_ sender: Any) {
        if searchBarTextField.text?.isEmpty == false {
            guard let text = searchBarTextField.text else { return }
            userInfoItems = []
            searchUsers(text: text, paging: 1)
        }
    }
    
    private func searchUsers(text: String, paging: Int) {
        isFetching = true
        provider.fetchSreachResults(keyworkd: text, paging: paging) { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let data):
                if data.results.totalCount != 0 {
                    strongSelf.remindLabel.isHidden = true
                    strongSelf.userInfoItems += data.results.items
                    
                    guard let paging = data.paging else { return }
                    strongSelf.nextPage = paging
                    strongSelf.isFetching = false
                    
                    print("---------paging----------")
                    print("fetch new paging \(paging)")
                } else {
                    strongSelf.remindLabel.isHidden = false
                    strongSelf.remindLabel.text = "No result of \(text)"
                }
                
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView.contentSize.height - collectionView.contentOffset.y < 1650,
            nextPage != nil,
            isFetching == false {
            guard let text = searchBarTextField.text, let paging = nextPage else { return }
            self.searchUsers(text: text, paging: paging)
        }
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
