//
//  ImageDetailViewController.swift
//  AlphaANativeApp
//
//  Created by Juliana Strawn on 5/17/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import SDWebImage

class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var artworkTitleLabel: UILabel!
    @IBOutlet weak var artworkTypeLabel: UILabel!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var likesHeart: UIImageView!
    @IBOutlet weak var imageDescriptionLabel: UILabel!
    @IBOutlet weak var artistProfileImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistBiographyLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var moreOptions: UIImageView!
    
    @IBOutlet weak var addToCart: UIButton!
    
    // login popup
    var customPopupView : UIView!
    var loginPopup: UIView!
    var popupLabel: UILabel!
    var popupText: UILabel!
    var cancelButton: UIButton!
    var loginButton: UIButton!
    
    var imageIsLiked: Bool!
    var didComeFromCollectionView: Bool!
    
    var artworkID: String?
    var artistID: String?
    
    var currentProduct: Product?
    
    let searchManager = SearchManager()
    
    var currentArtwork: Artwork?
    var currentArtistArtwork: Artist.ArtistArtwork?
    
    let shoppingCartManager = ShoppingCartDAO.sharedManager
    
    var canAddToCart = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchManager.artworkDelegate = self
        
        //set properties
        // begin activity indicator
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = .blue
        activityIndicator.startAnimating()
        
        // tap artwork to see full view
        artworkImageView.isUserInteractionEnabled = true
        let viewImageTap = UITapGestureRecognizer(target: self, action:  #selector(showFullImage))
        artworkImageView.addGestureRecognizer(viewImageTap)
        
        // tap heart to like
        imageIsLiked = false
        
        likesHeart.isUserInteractionEnabled = true
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(sendLike))
        likesHeart.addGestureRecognizer(likeTap)
        
        artistProfileImage.isUserInteractionEnabled = true
        let artistTap = UITapGestureRecognizer(target: self, action: #selector(pushToArtistProfile))
        artistProfileImage.addGestureRecognizer(artistTap)
        
        moreOptions.isUserInteractionEnabled = true
        let moreTap = UITapGestureRecognizer(target: self, action: #selector(presentMoreOptions))
        moreOptions.addGestureRecognizer(moreTap)
        
        setUpNotificationButton()
        
        // get artwork by id
        if currentArtwork != nil {
            artworkID = currentArtwork?.id
        }
        
        searchManager.getArtWorkWithId(id: artworkID!)
        
        if canAddToCart {
            self.addToCart.isHidden = false
        } else {
            self.addToCart.isHidden = true
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnTap = false
        
    }
    
    @IBAction func addToCartButton(_ sender: Any) {
        print("Purchasing this Artwork!")
        let shoppingCart = ShoppingCartViewController()
        shoppingCart.navigationItem.title = "alpha'a"
        let newItem = ShoppingCartItem(image: artworkImageView.image!, title: artworkTitleLabel.text!, artist: artistNameLabel.text!, price: Double((currentProduct?.price_us)!), id: artworkID!)
        self.shoppingCartManager.addItem(item: newItem)
        self.navigationController?.pushViewController(shoppingCart, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // tap artist photo to go to profile
        profileImageView.frame.size.height = view.frame.width * 0.35
        profileImageView.frame.size.width = view.frame.width * 0.35
        profileImageView.layer.cornerRadius = CGFloat(profileImageView.frame.width / 2)
        profileImageView.clipsToBounds = true
        
    }
    
    func setupImageDetail() {
        
        // populate profile and artwork using SDWebImages
        print("setupImageDetail:",currentArtwork!)
        
        // picture is from facebook, use facebook url
        if currentArtwork?.author_avatar!.range(of:"graph.facebook.com") != nil {
            artistProfileImage.sd_setImage(with: URL(string: (currentArtwork?.author_avatar!)!), placeholderImage: #imageLiteral(resourceName: "profilePlaceholder"))
        } else {
            // append baseurl to profile url
            artistProfileImage.sd_setImage(with: URL(string: Alphaa.baseImageURL +  (currentArtwork?.author_avatar)!) , placeholderImage: #imageLiteral(resourceName: "profilePlaceholder"))
        }
        
        let artworkImgURL = URL(string: Alphaa.baseImageURL + (currentArtwork?.img)!)
        artworkImageView.sd_setImage(with: artworkImgURL)
        
        artworkTitleLabel.text = currentArtwork?.title
        artworkTypeLabel.text = currentArtwork?.category
        numberOfLikesLabel.text = currentArtwork?.like_count
        //likesHeart.image =
        imageDescriptionLabel.text = currentArtwork?.artDescription
        artistNameLabel.text = currentArtwork?.author_name
        
        //>> refactor when bio data becomes available with artwork data <<
        let bio = ""
        artistBiographyLabel.text = bio.isEmpty == true ? "Artist has not provided a bio." : bio
//        if bio.isEmpty {
//            artistBiographyLabel.text = "Artist has not provided a bio."
//        } else {
//            artistBiographyLabel.text = bio
//        }

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
    
    func showFullImage() {
        let fullImageVC = FullImageViewController()
        let artworkImgURL = URL(string: Alphaa.baseImageURL + (currentArtwork?.img)!)
        fullImageVC.currentImageUrl = artworkImgURL
        
        fullImageVC.currentImageTitle = currentArtwork?.title
        self.navigationController?.pushViewController(fullImageVC, animated: false)
    }
    
    func sendLike() {
        let userIsLoggedIn = UserAuth.isLoggedIn()
        userIsLoggedIn == true ? handleLike() : loadLoginPopup()
    }
    
    func handleLike() {
        NetworkServices.likeArtwork(artworkId: Int(artworkID!)!) { (action) in
            DispatchQueue.main.async {
                self.likesHeart.image = action == "like" ? UIImage(named: "Heart - color") : UIImage(named: "Heart - black")
            }
        }
//        imageIsLiked = !imageIsLiked
    }
    
    func pushToArtistProfile() {
        
        if (didComeFromCollectionView != true) {
            let userDetailVC = UserDetailViewController()
            userDetailVC.artistID = currentArtwork?.uid
            userDetailVC.isArtist = true
            userDetailVC.hasArtwork = true
            self.navigationController?.pushViewController(userDetailVC, animated: true)
        }
        
    }
    
    
    func presentMoreOptions() {
        if artworkImageView.image != nil {

        let moreView = MoreOptionsViewController()
        moreView.modalPresentationStyle = .overFullScreen
        
        moreView.currentImage = artworkImageView.image!
        moreView.currentTitle = artworkTitleLabel.text!
        
        self.present(moreView, animated: true, completion: nil)
        }

    }
    
    
    // MARK: login popup logic
    
    func loadLoginPopup() {
        
        customPopupView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        customPopupView.alpha = 0.3
        customPopupView.backgroundColor = UIColor.black
        
        self.view.addSubview(customPopupView)
        
        loginPopup = UIButton(frame: CGRect(x: view.frame.midX - view.frame.width * 0.35,
                                            y: view.frame.midY - view.frame.height * 0.30,
                                            width: view.frame.width * 0.7,
                                            height: view.frame.height * 0.30))
        loginPopup.backgroundColor = UIColor.white
        loginPopup.layer.cornerRadius = 2
        loginPopup.alpha = 0.9
        self.view.addSubview(loginPopup)
        
        popupLabel = UILabel(frame: CGRect(x: view.frame.midX - view.frame.width * 0.35,
                                           y: view.frame.midY - view.frame.height * 0.28,
                                           width: loginPopup.frame.width,
                                           height: 30))
        popupLabel.text = "You are logged off"
        popupLabel.textAlignment = .center
        popupLabel.font = UIFont(name: "Mark-Regular", size: 20.0)
        popupLabel.textColor = UIColor(red:0.16, green:0.70, blue:0.74, alpha:1.0)
        self.view.addSubview(popupLabel)
        
        popupText = UILabel(frame: CGRect(x: view.frame.midX - view.frame.width * 0.35,
                                          y: view.frame.midY - view.frame.height * 0.23,
                                          width: loginPopup.frame.width,
                                          height: 60))
        popupText.text = "You need to be logged in. \nDo you want to do it now?"
        popupText.font = UIFont(name: "Mark-Regular", size: 18.0)
        popupText.numberOfLines = 0
        popupText.textAlignment = .center
        popupText.textColor = UIColor.lightGray
        self.view.addSubview(popupText)
        
        cancelButton = UIButton(frame: CGRect(x: view.frame.midX - view.frame.width * 0.33,
                                              y: view.frame.midY / 1.20,
                                              width: loginPopup.frame.width * 0.45,
                                              height: 50))
        cancelButton.backgroundColor = UIColor.white
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font =  UIFont(name: "Mark-Regular", size: 18.0)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonWasPressed), for: .touchUpInside)
        self.view.addSubview(cancelButton)
        
        loginButton = UIButton(frame: CGRect(x: view.frame.midX * 1.03,
                                             y: view.frame.midY / 1.20,
                                             width: loginPopup.frame.width * 0.45,
                                             height: 50))
        loginButton.backgroundColor = UIColor(red:0.16, green:0.70, blue:0.74, alpha:1.0)
        loginButton.setTitle("OK", for: .normal)
        loginButton.titleLabel?.font =  UIFont(name: "Mark-Regular", size: 18.0)
        loginButton.addTarget(self, action: #selector(loginButtonWasPressed), for: .touchUpInside)
        self.view.addSubview(loginButton)
        
    }
    
    func cancelButtonWasPressed() {
        customPopupView.removeFromSuperview()
        loginPopup.removeFromSuperview()
        popupLabel.removeFromSuperview()
        popupText.removeFromSuperview()
        cancelButton.removeFromSuperview()
        loginButton.removeFromSuperview()
        
    }
    
    
    func loginButtonWasPressed() {
        let accountVC = AccountViewController()
        self.present(accountVC, animated: true) {
            self.customPopupView.removeFromSuperview()
            self.loginPopup.removeFromSuperview()
            self.popupLabel.removeFromSuperview()
            self.popupText.removeFromSuperview()
            self.cancelButton.removeFromSuperview()
            self.loginButton.removeFromSuperview()
        }
    }
    
    
}


extension ImageDetailViewController: reloadWithArtworkDataDelegate {
    
    func updateUI(withArtworkData artwork: Artwork) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        self.currentArtwork = artwork
        setupImageDetail()
        
    }
}

