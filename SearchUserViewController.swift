//
//  SearchUserViewController.swift
//  AlphaANativeApp
//
//  Created by Emiko Clark on 7/25/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import SDWebImage


class SearchUserViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
        
        @IBOutlet weak var searchBar: UISearchBar!
        @IBOutlet weak var collectionView: UICollectionView!
        @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        
        let artistAndCollectorManager = ArtistAndCollectorManager()
        var isArtist:Bool?
        var pageNum = 1
        
        //Var to keep track of index at which the images are downloaded
        var continuousScrollIndexPath = 0
        
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // begin activity indicator
            activityIndicator.activityIndicatorViewStyle = .whiteLarge
            activityIndicator.color = .blue
            activityIndicator.startAnimating()
            
            // set delegates
            collectionView.delegate = self
            collectionView.dataSource = self as UICollectionViewDataSource
            searchBar.delegate = self
            artistAndCollectorManager.delegate = self
            
            
            // register custom cell for collection view
            let cellNib = UINib.init(nibName: "SearchUserCollectionViewCell", bundle: nil)
            collectionView.register(cellNib, forCellWithReuseIdentifier: "SearchUserCollectionViewCell")
            
            // Do any additional setup after loading the view.
            setUpNotificationButton()
            
            artistAndCollectorManager.getArtistsOrCollectors(page: pageNum, isArtist: isArtist!)
            pageNum += 1
            
            let title = self.navigationItem.title
            
            hideKeyboardWhenTappedAround()
            
            print(title!)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            //self.title = "Search Artists"
        }
        
        
        func setUpNotificationButton() {
            let btn2 = UIButton(type: .custom)
            btn2.setImage(UIImage(named: "bell"), for: .normal)
            btn2.frame = CGRect(x: 0, y: 0, width: 18, height: 20)
            btn2.tintColor = UIColor.black
            
            //btn1.addTarget(self, action: #selector(pushToImageDetailView), for: .touchUpInside)
            
            let item2 = UIBarButtonItem(customView: btn2)
            
            self.navigationItem.setRightBarButton(item2, animated: true)
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        // MARK: UICollectionViewDataSource
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return artistAndCollectorManager.artistAndCollectorProfile.count
        }
        
        
        // MARK: UICollectionViewDelegate
        
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if continuousScrollIndexPath != indexPath.row {
                continuousScrollIndexPath = indexPath.row
                let lastElement = artistAndCollectorManager.artistAndCollectorProfile.count - 3
                if indexPath.row == lastElement {
                    print("Shop:Getting more Artwork! pageNum:",pageNum,"\n")
                    artistAndCollectorManager.getArtistsOrCollectors(page: pageNum, isArtist: isArtist!)
                    pageNum += 1
                }
            } else {
                print("Same Index path was hit!!\n")
            }
            
        }
        
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchUserCollectionViewCell", for: indexPath) as! SearchUserCollectionViewCell
            let profile = artistAndCollectorManager.artistAndCollectorProfile[indexPath.row]
            
            cell.userProfileImageView.sd_setImage(with: profile.avatarURL, placeholderImage: #imageLiteral(resourceName: "profilePlaceholder"))
            
            cell.userName.textColor = UIColor.black
            cell.userName.text = profile.name
            
            return cell
        }
        
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            print("User(\(String(describing: isArtist))) tapped on cell \(indexPath.row)")
            
            // push to userDetailsVC
            let userDetailVC = UserDetailViewController()
            
            // pass artist object to userDetailView
            let userID = artistAndCollectorManager.artistAndCollectorProfile[indexPath.row].id
            
            
            // check if artists or collectors
            if artistAndCollectorManager.artistAndCollectorProfile[indexPath.row].profile == "artist" {
                // is an artist
                userDetailVC.isArtist = true
                userDetailVC.artistID = userID

            } else {
                // is a collector
                userDetailVC.isArtist = false
                userDetailVC.collectorID = userID
            }
            
            
            // present view controller
            self.navigationController?.pushViewController(userDetailVC, animated: true)
            
        }
        
    }
    
extension SearchUserViewController: reloadArtistCollectorProfileDataDelegate {
        func updateUI() {
            
            // stop activity indicator
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            
            collectionView.reloadData()
        }
}

