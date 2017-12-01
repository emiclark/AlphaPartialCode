//
//  ArtistArtView.swift
//  AlphaANativeApp
//
//  Created by Aditya Narayan on 5/22/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

// MARK:- Protocols

protocol ChildArtViewControllerDelegate: class {
    func UploadArtworkButtonTapped(childViewController: ArtistArtView)
}

import UIKit
import WebKit

class ArtistArtView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - Properties

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var uploadArtButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cvHeightConstraint: NSLayoutConstraint!
    
    var artworkArray: [Artist.ArtistArtwork]?
    var userid: String?
    var searchManager = SearchManager()
    weak var artViewControllerDelegate: ChildArtViewControllerDelegate?

    // MARK: - View Load Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the activity indicator
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = .blue
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        // delegates
        collectionView.delegate = self
        collectionView.dataSource = self
        searchManager.loadCVDataDelegate = self
        
        // register this VC as an observer. To be notified when the artworkArray (that includes new uploaded artwork) has been downloaded
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCVNotification(notification:)), name: .REFRESH_NOTIFICATION, object: nil)
        
        collectionView.register( UINib(nibName: "ArtCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        // make a call to get all artist's artwork
        searchManager.getArtistArtworks(userid!)
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        self.cvHeightConstraint.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    

    // MARK: - Collection Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if artworkArray?.count == nil {
            return 0
        } else {
            return (artworkArray?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let artworkImgURL = Alphaa.baseImageURL +  (artworkArray?[indexPath.row].img)!
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ArtCollectionViewCell
        cell.imageView.sd_setImage(with: URL(string: artworkImgURL), placeholderImage: UIImage(named: "artworkPlaceholder"))
        cell.textLabel.text = artworkArray?[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // show image details of the selected cell
        let imageDetailVC = ImageDetailViewController()
        imageDetailVC.artworkID = artworkArray?[indexPath.row].id
        self.navigationController?.pushViewController(imageDetailVC, animated: true)
    }
    
    // MARK: - Buttons Tapped Methods

    @IBAction func uploadArtPressed(_ sender: Any) {
        // tapping upload Artwork button sends a message to the parent VC (AccountArtistViewController) to display the picker view controller. picker view controller allows user to upload and image from the library or take a photo.
        artViewControllerDelegate?.UploadArtworkButtonTapped(childViewController: self)
    }
    
    // MARK: - Notification Methods

    func refreshCVNotification(notification:Notification) -> Void {
        // reload is triggered when new artwork is uploaded after making a call to download new array of artworks

        collectionView.reloadData()
        
        // update collectionView height
        resizeCollectionViewSize()

    }

    func resizeCollectionViewSize(){
        // update height of collection view and update parent's containerviewHeight
        let artistAccountVC = ArtistAccountViewController()
        cvHeightConstraint.constant =  self.collectionView.collectionViewLayout.collectionViewContentSize.height
        
        // update parentVC containerview height to show full content in scrollview
        artistAccountVC.containviewHeight = cvHeightConstraint.constant
    
        self.view.layoutIfNeeded()
    }
    
    deinit {
        // removes this notification from the NotificationCenter
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Extensions & Delegates

extension ArtistArtView: LoadCVDataDelegate {
    // loads collectionview Data before uploading any artwork
    
    func loadCVWithArtworkDelegate(withArtworkArray artworkArray: [Artist.ArtistArtwork]) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        self.artworkArray = artworkArray
        
        self.collectionView.reloadData()
        
        // update collectionView height
        resizeCollectionViewSize()
        
        self.view.layoutIfNeeded()
    }
}
