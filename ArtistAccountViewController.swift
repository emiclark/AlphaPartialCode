//
//  ArtistAccountViewController.swift
//  testingTabbedViewcontroller
//
//  Created by Juliana Strawn on 5/11/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class ArtistAccountViewController: UIViewController {
    
    // MARK: Properties

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var artButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var dashBoardButton: UIButton!
    @IBOutlet weak var votesButton: UIButton!
    @IBOutlet weak var salesButton: UIButton!
    @IBOutlet weak var viewsButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emptyStateView: UIView!

    var containviewHeight: CGFloat = 0.0
    var currentUser: User?
    var hasLoggedIn = false
    var isArtist: Bool = false
    var isCollector: Bool = false
    var blackTintView : UIView!
    
    lazy var editPopUp: EditPopUpView = {
        let editView = EditPopUpView()
        return editView
    }()
    
    // Child VC's
    
    var currentChildController: UIViewController?
    var newChildVC: UIViewController?
    var artViewVC = ArtistArtView()
    var aboutView = ArtistAboutViewController()
    
    // this VC has art and about buttons
    //    var aboutView = UserAboutViewController()
    
    var votesView = VotesChildViewController()
    var salesView = SalesChildViewController()
    var viewsView = ViewsChildViewController()
    var pickUploadSourceVC = PickUploadSourceViewController()
    var accountVC   = AccountViewController()
    var searchManager = SearchManager()
    
    //MARK: - View Load Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artViewVC.artViewControllerDelegate = self
        
        // check if user logs/logged in
        hasLoggedIn = UserAuth.isLoggedIn()
        
        // Present empty state if user has not logged in.
        if hasLoggedIn == false {
            self.emptyStateView.isHidden = true
            
            // gray out all buttons
            artButton.layer.borderWidth = 1
            artButton.layer.backgroundColor = UIColor.lightGray.cgColor
            artButton.layer.borderColor = UIColor.white.cgColor
            artButton.setTitleColor(UIColor.white, for: .normal)
            
            aboutButton.layer.borderWidth = 1
            aboutButton.layer.borderColor = UIColor.white.cgColor
            aboutButton.layer.backgroundColor = UIColor.lightGray.cgColor
            aboutButton.setTitleColor(UIColor.white, for: .normal)
            
            dashBoardButton.layer.borderWidth = 1
            dashBoardButton.layer.borderColor = UIColor.white.cgColor
            dashBoardButton.layer.backgroundColor = UIColor.lightGray.cgColor
            dashBoardButton.setTitleColor(UIColor.white, for: .normal)
            
            showViewControllerForEmptyState()
            
        } else   {

            // user logged in. Is artist. hide emptyStateView
            
            self.emptyStateView.isHidden = true
            
            // user has logged in. populate with user info
            self.navigationController?.navigationBar.topItem?.title = "Account"
            self.navigationController?.navigationBar.isTranslucent = false
            
            presentAndLayoutChildContent(childVC: aboutView)
            
            profileImageView.layer.borderWidth = 2
            profileImageView.layer.borderColor = UIColor.white.cgColor
            
            
            artButton.layer.borderWidth = 1
            artButton.layer.borderColor = UIColor.lightGray.cgColor
            aboutButton.layer.borderWidth = 1
            aboutButton.layer.borderColor = UIColor.lightGray.cgColor
            
            dashBoardButton.layer.borderWidth = 1
            dashBoardButton.layer.borderColor = UIColor.lightGray.cgColor
            
            votesButton.layer.borderWidth = 1
            votesButton.layer.borderColor = #colorLiteral(red: 0.3178564341, green: 0.8038745241, blue: 0.7011438201, alpha: 1).cgColor
            salesButton.layer.borderWidth = 1
            salesButton.layer.borderColor = #colorLiteral(red: 0.3178564341, green: 0.8038745241, blue: 0.7011438201, alpha: 1).cgColor
            viewsButton.layer.borderWidth = 1
            viewsButton.layer.borderColor = #colorLiteral(red: 0.3178564341, green: 0.8038745241, blue: 0.7011438201, alpha: 1).cgColor
            
            showViewControllerForLoggedInUser()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.artViewVC.artViewControllerDelegate = self
        
        self.navigationController?.hidesBarsOnTap = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
     }
    
    //MARK: - Show VC's Methods
    
    // show empty state view controller if user chooses not to login. disable all buttons.
    func showViewControllerForEmptyState() {
        // disable all buttons and profile image, gray out all buttons
        artButton.layer.borderWidth = 1
        artButton.layer.backgroundColor = UIColor.lightGray.cgColor
        artButton.layer.borderColor = UIColor.white.cgColor
        artButton.setTitleColor(UIColor.white, for: .normal)
        
        aboutButton.layer.borderWidth = 1
        aboutButton.layer.borderColor = UIColor.white.cgColor
        aboutButton.layer.backgroundColor = UIColor.lightGray.cgColor
        aboutButton.setTitleColor(UIColor.white, for: .normal)
        
        dashBoardButton.layer.borderWidth = 1
        dashBoardButton.layer.borderColor = UIColor.white.cgColor
        dashBoardButton.layer.backgroundColor = UIColor.lightGray.cgColor
        dashBoardButton.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    // show view controller w/ artist's image, name and bkg picture immediately after login.
    func showViewControllerForLoggedInUser() {
        
        // user has logged in. display artist's profile pictures, bio, edit button, &artworks
        self.navigationController?.navigationBar.topItem?.title = "Account"
        self.navigationController?.navigationBar.isTranslucent = false
        
        // set bool: logged in as artist if using UserAboutViewController
        // aboutView.isArtist = true
        
        self.contentView.addSubview(aboutView.view)
        currentChildController = aboutView
        presentAndLayoutChildContent(childVC: aboutView)
        
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        
        artButton.layer.borderWidth = 1
        artButton.layer.borderColor = UIColor.lightGray.cgColor
        aboutButton.layer.borderWidth = 1
        aboutButton.layer.borderColor = Alphaa.blueColorA
        aboutButton.backgroundColor = Alphaa.blueColorB
        
        dashBoardButton.layer.borderWidth = 1
        dashBoardButton.layer.borderColor = UIColor.lightGray.cgColor
        
        votesButton.layer.borderWidth = 1
        votesButton.layer.borderColor = #colorLiteral(red: 0.3178564341, green: 0.8038745241, blue: 0.7011438201, alpha: 1).cgColor
        salesButton.layer.borderWidth = 1
        salesButton.layer.borderColor = #colorLiteral(red: 0.3178564341, green: 0.8038745241, blue: 0.7011438201, alpha: 1).cgColor
        viewsButton.layer.borderWidth = 1
        viewsButton.layer.borderColor = #colorLiteral(red: 0.3178564341, green: 0.8038745241, blue: 0.7011438201, alpha: 1).cgColor
        
        // show image and background image
        let profileUrlString = Alphaa.baseImageURL + (UserAuth.user?.avatar)!
        let profileURL = URL(string: profileUrlString)
        
        let coverUrlString = Alphaa.baseImageURL + (UserAuth.user?.cover)!
        let coverURL = URL(string: coverUrlString)

        profileImageView.sd_setImage(with: profileURL, placeholderImage:  UIImage(named:"profilePlaceholder"))
        coverImageView.sd_setImage(with: coverURL, placeholderImage: UIImage(named:"profilePlaceholder"))
    }
    
    
    //This method is responsible for swapping out child view controllers, and constraining them dynamically so the scroll view will adjust.
    
    func presentAndLayoutChildContent(childVC: UIViewController){
        newChildVC = childVC
        currentChildController?.willMove(toParentViewController: nil)
        currentChildController?.view.removeFromSuperview()
        currentChildController?.removeFromParentViewController()
        self.addChildViewController(childVC)
        containerView.addSubview(childVC.view)
        
        childVC.view.translatesAutoresizingMaskIntoConstraints = false
        childVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        childVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        childVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        
        //if its in the 'dashboard', top constraint has to be lower
        
        if childVC is VotesChildViewController || childVC is ViewsChildViewController || childVC is SalesChildViewController {
            
            childVC.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: votesButton.frame.height + 32).isActive = true
        } else {
            childVC.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        }
        
        //if it has a collectionView, base the height off of the collection view
        if let childCollectionVC = childVC as? ArtistArtView {
            // has collection view.
            _ = childCollectionVC.view
            childCollectionVC.collectionView.layoutIfNeeded()
            
            childVC.view.bounds =  childCollectionVC.view.bounds
            
            // MYSTERY?? removing this line causes the VC to shrink everytime you click away and return to it.
            childVC.view.frame = (newChildVC?.view.frame)!

        } else if let childCollectionVC = childVC as? ViewsChildViewController {
            _ = childCollectionVC.view
            childCollectionVC.collectionView.layoutIfNeeded()
            // MYSTERY?? removing this line causes the VC to shrink everytime you click away and return to it.
            childVC.view.bounds = (newChildVC?.view.bounds)!

        } else {
            // MYSTERY?? removing this line causes the VC to shrink everytime you click away and return to it.
            childVC.view.bounds = (newChildVC?.view.bounds)!
        }
        childVC.didMove(toParentViewController: self)
        currentChildController = childVC
        
        // set userBio if it exists in artistAboutVC
        if childVC == aboutView {
            aboutView.userBio = currentUser?.bio
        }
    }
    
    //MARK: - Button Tapped Methods
    
    @IBAction func artButtonPressed(_ sender: Any) {
        
        // present view only for logged in artists. hi-lites art button and de-hilights other buttons. presents artViewVC.
        if hasLoggedIn == true {
            
            artButton.backgroundColor = .lightGray
            artButton.setTitleColor(.white, for: .normal)
            aboutButton.backgroundColor = .white
            aboutButton.layer.borderColor = UIColor.lightGray.cgColor
            aboutButton.setTitleColor(.lightGray, for: .normal)
            
            // a future feature
            dashBoardButton.backgroundColor = .white
            dashBoardButton.setTitleColor(.lightGray, for: .normal)
            
            votesButton.isHidden = true
            salesButton.isHidden = true
            viewsButton.isHidden = true
            
            artViewVC.userid = currentUser?.id
            presentAndLayoutChildContent(childVC: artViewVC)
            
        }
    }
    
    @IBAction func aboutButtonPressed(_ sender: Any) {
        
        // present view only for logged in artists to show their bio
        if hasLoggedIn == true {
            
            artButton.backgroundColor = .white
            artButton.setTitleColor(.lightGray, for: .normal)
            aboutButton.backgroundColor = .lightGray
            aboutButton.setTitleColor(.white, for: .normal)
            dashBoardButton.backgroundColor = .white
            dashBoardButton.setTitleColor(.lightGray, for: .normal)
            
            votesButton.isHidden = true
            salesButton.isHidden = true
            viewsButton.isHidden = true
            presentAndLayoutChildContent(childVC: aboutView)
        }
    }
    
    //MARK: - Future Features - Button Tapped
    
    // future feature
    @IBAction func dashBoardButtonPressed(_ sender: Any) {
        
        // present view only for logged in artists to show analytics on votes, sales and views.
        if hasLoggedIn == true {
            
            artButton.backgroundColor = .white
            artButton.setTitleColor(.lightGray, for: .normal)
            aboutButton.backgroundColor = .white
            aboutButton.setTitleColor(.lightGray, for: .normal)
            dashBoardButton.backgroundColor = .lightGray
            dashBoardButton.setTitleColor(.white, for: .normal)
            
            votesButton.backgroundColor = #colorLiteral(red: 0.3178564341, green: 0.8038745241, blue: 0.7011438201, alpha: 1)
            votesButton.setTitleColor(.white, for: .normal)
            salesButton.backgroundColor = .white
            salesButton.setTitleColor(#colorLiteral(red: 0.3178564341, green: 0.8038745241, blue: 0.7011438201, alpha: 1), for: .normal)
            viewsButton.backgroundColor = .white
            viewsButton.setTitleColor(#colorLiteral(red: 0.3178564341, green: 0.8038745241, blue: 0.7011438201, alpha: 1), for: .normal)
            
            votesButton.isHidden = false
            salesButton.isHidden = false
            viewsButton.isHidden = false
            
            presentAndLayoutChildContent(childVC: votesView)
        }
    }
    
    // future feature
    @IBAction func votesButtonPressed(_ sender: Any) {
        print("votes pressed")
        
        votesButton.backgroundColor = #colorLiteral(red: 0.3178564341, green: 0.8038745241, blue: 0.7011438201, alpha: 1)
        votesButton.setTitleColor(.white, for: .normal)
        salesButton.backgroundColor = .white
        salesButton.setTitleColor(#colorLiteral(red: 0.3178564341, green: 0.8038745241, blue: 0.7011438201, alpha: 1), for: .normal)
        viewsButton.backgroundColor = .white
        viewsButton.setTitleColor(#colorLiteral(red: 0.3178564341, green: 0.8038745241, blue: 0.7011438201, alpha: 1), for: .normal)
        
        presentAndLayoutChildContent(childVC: votesView)
    }
    
    // future feature
    @IBAction func salesButtonPressed(_ sender: Any) {
        
        votesButton.backgroundColor = .white
        votesButton.setTitleColor(#colorLiteral(red: 0.3178564341, green: 0.8038745241, blue: 0.7011438201, alpha: 1), for: .normal)
        salesButton.backgroundColor = #colorLiteral(red: 0.3178564341, green: 0.8038745241, blue: 0.7011438201, alpha: 1)
        salesButton.setTitleColor(.white, for: .normal)
        viewsButton.backgroundColor = .white
        viewsButton.setTitleColor(#colorLiteral(red: 0.3178564341, green: 0.8038745241, blue: 0.7011438201, alpha: 1), for: .normal)
        
        presentAndLayoutChildContent(childVC: salesView)
    }
    
    // future feature
    @IBAction func viewsButtonPressed(_ sender: Any) {
        
        votesButton.backgroundColor = .white
        votesButton.setTitleColor(#colorLiteral(red: 0.3178564341, green: 0.8038745241, blue: 0.7011438201, alpha: 1), for: .normal)
        salesButton.backgroundColor = .white
        salesButton.setTitleColor(#colorLiteral(red: 0.3178564341, green: 0.8038745241, blue: 0.7011438201, alpha: 1), for: .normal)
        viewsButton.backgroundColor = #colorLiteral(red: 0.3178564341, green: 0.8038745241, blue: 0.7011438201, alpha: 1)
        viewsButton.setTitleColor(.white, for: .normal)
        
        presentAndLayoutChildContent(childVC: viewsView)
    }
    
    // future feature
    @IBAction func editButtonPressed(_ sender: Any) {
        
        if hasLoggedIn {
            // shows user the edit menu
            blackTintView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            blackTintView.alpha = 0.3
            blackTintView.backgroundColor = UIColor.black
            
            self.view.addSubview(blackTintView)
            
            editPopUp.frame = CGRect(x: view.frame.midX - view.frame.width * 0.40,
                                     y: view.frame.midY - view.frame.height * 0.25,
                                     width: view.frame.width * 0.8,
                                     height: view.frame.height * 0.40)
            
            self.view.addSubview(editPopUp)

        }
        
           }
    
    //MARK: - Touch Events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if editPopUp.superview != nil {
            editPopUp.removeFromSuperview()
            blackTintView.removeFromSuperview()
        }
    }
}

//MARK: - Extensions and Delegates




extension ArtistAccountViewController: ChildArtViewControllerDelegate {
    
    func UploadArtworkButtonTapped(childViewController: ArtistArtView) {
        
        // present popup view controller to select image from camera/photolibrary when upload button is clicked in the ArtViewVC
        pickUploadSourceVC.modalTransitionStyle = .crossDissolve
        pickUploadSourceVC.modalPresentationStyle = .overFullScreen

        self.present(pickUploadSourceVC, animated: false, completion: nil)
    }
}

extension ArtistAccountViewController: UploadArtworkDelegate {
    
    func cancelPickSourceVCFromUploadArtworkVC(){
        // this class dismisses the picker view controller instead of the pickerVC
        let uploadArtworkVC = ArtworkAndInfoToUploadViewController()
        uploadArtworkVC.uploadArtworkDelegate = self as UploadArtworkDelegate
        
        self.pickUploadSourceVC.dismiss(animated: false, completion: nil)
    }
}
