//
//  SearchViewController.swift
//  testingTabbedViewcontroller
//
//  Created by Juliana Strawn on 5/11/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let collections = ["ARTISTS", "COLLECTORS", "PURCHASE", "VOTE", "EVENTS", "PLACES", "NEAR YOU"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.navigationController?.navigationBar.topItem?.title = "alpha'a"
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false
        collectionView.showsVerticalScrollIndicator = false

        setUpNotificationButton()
        hideKeyboardWhenTappedAround()
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "SearchScreenCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnTap = false
        
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

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchScreenCollectionViewCell
        
        // Configure the cell
        cell.imageView.image = UIImage(named: "art")
        cell.textLabel.text = collections[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: Incorporate logic for showing different types of collection views (artist, event, etc)
        
        switch indexPath.row {
            
            // ARTISTS
        case 0:
//            let searchArtistVC = SearchArtistViewController()
//            searchArtistVC.title = "Search Artists"
//            searchArtistVC.isArtist = true
//            self.navigationController?.pushViewController(searchArtistVC, animated: true)
            
            let searchUserVC = SearchUserViewController()

            searchUserVC.title = "Search Artists"
            searchUserVC.isArtist = true
            self.navigationController?.pushViewController(searchUserVC, animated: true)
            
            // COLLECTORS
        case 1:
//            let searchArtistVC = SearchArtistViewController()
//            searchArtistVC.title = "Search Collectors"
//            searchArtistVC.isArtist = false
//            self.navigationController?.pushViewController(searchArtistVC, animated: true)
            
            let searchUserVC = SearchUserViewController()
            searchUserVC.title = "Search Collectors"
            searchUserVC.isArtist = false
            self.navigationController?.pushViewController(searchUserVC, animated: true)
            
            // PURCHASE
        case 2:
            let shopVC = ShopViewController()
            shopVC.title = "shop"
            self.navigationController?.pushViewController(shopVC, animated: true)


            // VOTE
        case 3:
            let voteVC = VoteViewController()
            voteVC.title = "vote"
            self.navigationController?.pushViewController(voteVC, animated: true)
            
            // EVENTS
        case 4:
            break
            
            // PLACES
        case 5:
            break
            
            // NEAR YOU
        case 6:
            let mapVC = GoogleMapsViewController()
            mapVC.title = "near me"
            self.navigationController?.pushViewController(mapVC, animated: true)


        default: break
            
        }
    }
}
