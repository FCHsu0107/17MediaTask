//
//  ViewController.swift
//  Assignment17Media
//
//  Created by Fu-Chiung HSU on 2019/6/3.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBarTextField: UITextField! {
        didSet {
            searchBarTextField.delegate = self
        }
    }
    
    @IBOutlet weak var remindLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var userInfoItems: [UserInfoObject] = [] {
        didSet {
            reloadData()
        }
    }
    
    //判斷是否打api
    var isFetching: Bool = false
    
    //起始頁面
    var nextPage: Int? = 1
    
    var avtivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let provider = UserProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboradWhenTappedAround()
        
        setUpCollectionView()
    }
    
    @IBAction func clickSearchBtn(_ sender: Any) {
        searchAction()
    }
    
    // Action of search user
    private func searchAction() {
        userInfoItems = []
        nextPage = 1
        if searchBarTextField.text?.isEmpty == false {
            avtivityIndicator.loadingView(vc: self)
            remindLabel.isHidden = true
            guard let text = searchBarTextField.text else { return }
            searchUsers(text: text, paging: 1)
        } else {
            remindLabel.isHidden = false
            remindLabel.text = "Please enter the keyword to search users"
        }

    }
    
    // connect GitHub api
    private func searchUsers(text: String, paging: Int) {
        isFetching = true
        
        provider.fetchSearchResults(keyworkd: text, paging: paging) { [weak self] (result) in
            self?.stoppedLoadingView()
            
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let data):
                if data.results.totalCount != 0 {
                    
                    strongSelf.remindLabel.isHidden = true
                    strongSelf.userInfoItems += data.results.items
                    
                    guard let paging = data.paging else { strongSelf.nextPage = nil
                        return }
                    
                    strongSelf.nextPage = paging
                    strongSelf.isFetching = false
                    print("fetch new paging \(paging)")
                    
                } else {
                    
                    strongSelf.remindLabel.isHidden = false
                    strongSelf.remindLabel.text = "No result for \(text)"
                }
                
            case .failure(let error):
                // 處理錯誤
                JQProgressHUD.showFailure(text: error.localizedDescription)
                print(error)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 60, execute: {
                    print("等了60秒了")
                    // 60秒後重打api
                    guard let text = self?.searchBarTextField.text, let paging = self?.nextPage else { return }
                    if paging != 1 {
                        self?.searchUsers(text: text, paging: paging)
                    }
                })
            }
        }
    }
    
    private func setUpCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.jq_registerCellWithNib(
            identifier: String(describing: SearchCollectionViewCell.self),
            bundle: nil)
        
        collectionView.jq_registerCellWithNib(
            identifier: String(describing: FooterCollectionViewCell.self),
            bundle: nil)
        
        setUpCollectionViewLayout()
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
    
    //MARK: - Avtivity Indicator
    private func stoppedLoadingView() {
        DispatchQueue.main.async { [weak self] in 
            self?.avtivityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    //MARK: - Collection View layout
    private func setUpCollectionViewLayout() {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(width: Int(UIScreen.main.bounds.width), height: 110)
        
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        flowLayout.minimumLineSpacing = 0
        
        flowLayout.minimumInteritemSpacing = 0
        
        collectionView.collectionViewLayout = flowLayout
    }
    
}

//MARK: - Collection View
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return userInfoItems.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: SearchCollectionViewCell.self), for: indexPath)

            guard let searchCell = cell as? SearchCollectionViewCell else { return cell }

            let userInfo = userInfoItems[indexPath.item]

            searchCell.loadCell(userInfo: userInfo)

            return searchCell

        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: FooterCollectionViewCell.self), for: indexPath)
            
            guard let footerCell = cell as? FooterCollectionViewCell else { return cell }
            
            footerCell.showEnd(paging: nextPage)
            
            return footerCell
            
        default:
            return UICollectionViewCell()
            
        }
    }
}

extension ViewController: UITextFieldDelegate {
    // tap return to search user
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchBarTextField.resignFirstResponder()
        searchAction()
        return true
    }
}
