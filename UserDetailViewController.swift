//
//  UserDetailViewController.swift
//  AlphaANativeApp
//
//  Created by Emiko Clark on 7/25/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import SDWebImage

class UserDetailViewController: UIViewController {
    
    var basicUser: User?
    var artistID: String?
    var collectorID: String?
    
    var isArtist: Bool = false
    var hasArtwork: Bool = false
    var hasFavorites: Bool = false
    var hasBio: Bool = false
    
    let searchManager = SearchManager()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bkgPic: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userCollectionsButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var currentChildController: UIViewController?

    @IBOutlet var containerViewHeight: NSLayoutConstraint!
    
    var detailedUser: User? {
        willSet {
            
            // stop activity indicator
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            
            // set images and UI properties
            
            if (isArtist == true) {
                if newValue?.avatar!.range(of:"graph.facebook.com") != nil {
                    self.userProfileImageView.sd_setImage(with: URL(string: (newValue?.avatar)!), placeholderImage: #imageLiteral(resourceName: "profilePlaceholder"))
                } else {
                    // append baseurl to avatar url
                    self.userProfileImageView.sd_setImage(with: URL(string: Alphaa.baseImageURL +  (newValue?.avatar)!) , placeholderImage: #imageLiteral(resourceName: "profilePlaceholder"))
                }
                
                let bkgpicUrlString = Alphaa.baseImageURL + (newValue?.cover)!
                bkgPic.sd_setImage(with: URL(string: bkgpicUrlString), placeholderImage: #imageLiteral(resourceName: "bkpicPlaceholder"))
                
                userNameLabel.text = (newValue?.name)!
            }
        }
    }
    
    var collector: Collector? {
        willSet {
            
            // stop activity indicator
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            
            // set images and UI properties
            
            if newValue?.avatar!.range(of:"graph.facebook.com") != nil {
                self.userProfileImageView.sd_setImage(with: URL(string: (newValue?.avatar)!), placeholderImage: #imageLiteral(resourceName: "profilePlaceholder"))
            } else {
                // append baseurl to avatar url
                self.userProfileImageView.sd_setImage(with: URL(string: Alphaa.baseImageURL +  (newValue?.avatar)!) , placeholderImage: #imageLiteral(resourceName: "profilePlaceholder"))
            }
            
            let bkgpicUrlString = Alphaa.baseImageURL + (newValue?.cover)!
            bkgPic.sd_setImage(with: URL(string: bkgpicUrlString), placeholderImage: #imageLiteral(resourceName: "bkpicPlaceholder"))
            
            userNameLabel.text = (newValue?.name)!
        }
    }
    
    var aboutView = UserAboutViewController()
    var artView = ArtistArtworkCollectionViewController()
    var emptyCollectionView = EmptyCollectionViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // begin activity indicator
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = .blue
        activityIndicator.startAnimating()
        
        searchManager.artistDelegate = self
        searchManager.collectorDelegate = self
        searchManager.artworkDelegate = self
        
        userProfileImageView.layer.masksToBounds = true
        userProfileImageView.layer.borderWidth = 2
        userProfileImageView.layer.borderColor = UIColor.white.cgColor
        
        userCollectionsButton.layer.borderWidth = 1
        userCollectionsButton.layer.borderColor = UIColor.lightGray.cgColor
        
        aboutButton.layer.borderWidth = 1
        aboutButton.layer.borderColor = UIColor.lightGray.cgColor
        
        // default: make art button active
        userCollectionsButton.setTitleColor(.white, for: .normal)
        userCollectionsButton.backgroundColor = .lightGray
        aboutButton.setTitleColor(.lightGray, for: .normal)
        aboutButton.backgroundColor = .white
        
        
        if (isArtist == true) {
            // is artist
            
            // set button title
            userCollectionsButton.setTitle("Art", for: .normal)
            aboutView.isArtist = true
            artView.isArtist = true
            emptyCollectionView.isArtist = true
            // get specific artist info
            searchManager.getArtistInfo((artistID)!, completion: { (artist) in
                self.updateUI(withDetailedUser: artist)
            })
            
        } else  {
            // is collector
            userCollectionsButton.setTitle("Favorites", for: .normal)
            aboutView.isArtist = false
            artView.isArtist = false
            emptyCollectionView.isArtist = false
            // get specific collector info
            searchManager.getCollectorInfo((collectorID)!)
        }
        
        if basicUser?.bio != nil {
            aboutView.userBio = detailedUser?.bio!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.size.height/2
        userProfileImageView.contentMode = .scaleAspectFill
        self.navigationController?.hidesBarsOnTap = false
    }
    
    
    //MARK: - CUSTOM
    
    func layoutChildContent(childVC: UIViewController){
        
        currentChildController?.willMove(toParentViewController: nil)
        currentChildController?.view.removeFromSuperview()
        currentChildController?.removeFromParentViewController()
        
        self.addChildViewController(childVC)
        containerView.addSubview(childVC.view)
        
        childVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        childVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        
        childVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        
        childVC.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        
        childVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        
        if let childCollectionVC = childVC as? ArtistArtworkCollectionViewController {
            _ = childCollectionVC.view
            childCollectionVC.collectionView.layoutIfNeeded()
            
            containerViewHeight.constant = childCollectionVC.collectionView.collectionViewLayout.collectionViewContentSize.height + 20
        } else {
            containerViewHeight.constant = childVC.view.bounds.height
        }
        childVC.didMove(toParentViewController: self)
        currentChildController = childVC
    }

    
    @IBAction func aboutButtonTapped(_ sender: UIButton) {
        // show user's bio
        
        // make about button active
        aboutButton.setTitleColor(.white, for: .normal)
        aboutButton.backgroundColor = .lightGray
        userCollectionsButton.setTitleColor(.lightGray, for: .normal)
        userCollectionsButton.backgroundColor = .white
        
        if (isArtist == true) {
            // is artist
            aboutView.isArtist = true
        } else {
            // is a collector
            aboutView.isArtist = false
        }
        
        if basicUser?.bio != nil {
            aboutView.userBio = detailedUser?.bio!
        }
        
        layoutChildContent(childVC: aboutView)
    }
    
    @IBAction func userCollectionButtonTapped(_ sender: UIButton) {
        aboutView.view.removeFromSuperview()
        emptyCollectionView.view.removeFromSuperview()
        
        // make art button active
        userCollectionsButton.setTitleColor(.white, for: .normal)
        userCollectionsButton.backgroundColor = .lightGray
        aboutButton.setTitleColor(.lightGray, for: .normal)
        aboutButton.backgroundColor = .white
        
        if (isArtist == true) {
            // is artist
            artView.isArtist = true
            
            if hasArtwork == true {
                // artist has artwork, put in artview collection view
                layoutChildContent(childVC: artView)

                artView.view.isHidden = false
            } else {
                // no artwork, put in emptyCollectionview
                layoutChildContent(childVC: emptyCollectionView)

                
                emptyCollectionView.isArtist = true
                emptyCollectionView.view.isHidden = false
            }
        } else {
            // is a collector
            artView.isArtist = false
            
            if (hasFavorites == true) {
                // collector has favorites

                layoutChildContent(childVC: artView)
                artView.view.isHidden = false
            } else {
                // has no favorites
                
                layoutChildContent(childVC: emptyCollectionView)
                emptyCollectionView.view.isHidden = false
                emptyCollectionView.isArtist = false
            }
        }
        
        scrollView.backgroundColor = .cyan
        print("scrollViewHeight:", scrollView.contentSize)
        
    }
}



extension UserDetailViewController: reloadArtistInfoDataDelegate {
    func updateUI(withDetailedUser detailedUser: Artist) {
        
        hasArtwork = false
        self.detailedUser = detailedUser
        self.artView.detailedUser = detailedUser
        
        // check if artist has artworks
        if (detailedUser.artistArtworksArray.count > 0) {
            //  artist has artworks
            hasArtwork = true
 
            layoutChildContent(childVC: artView)
            artView.collectionView.reloadData()
            layoutChildContent(childVC: artView)
            
        } else {
            // swap view to notify that artist has no uploaded artwork
            emptyCollectionView.isArtist = true
            layoutChildContent(childVC: emptyCollectionView)
        }
        
        print("detailedUser: Artist", detailedUser)
    }
}


extension UserDetailViewController: reloadCollectorInfoDataDelegate  {
    
    func updateUI(withCollector detailedUser: Collector) {
        hasFavorites = false
        self.collector = detailedUser
        self.artView.collector = collector
        
        // check if collector has favorites
        if ((collector?.favoritesArray?.count)! > 0) {
            //  collector has favorites
            hasFavorites = true
            artView.isArtist = false
            
            layoutChildContent(childVC: artView)
            artView.collectionView.reloadData()
            layoutChildContent(childVC: artView)
            
        } else {
            
            // swap view to notify that artist has no uploaded artwork
            emptyCollectionView.isArtist = false
            layoutChildContent(childVC: emptyCollectionView)
        }
        
        print("detailedUser: Collector", detailedUser)

        print("scrollViewHeight:", scrollView.contentSize)
    }
    
}


extension UserDetailViewController: reloadWithArtworkDataDelegate {
    
    func updateUI(withArtworkData artwork: Artwork) {
        
        // update
        let imageDetailVC = ImageDetailViewController()
        imageDetailVC.currentArtwork = artwork
        self.navigationController?.pushViewController(imageDetailVC, animated: true)
    }
}


