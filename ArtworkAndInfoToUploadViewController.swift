//
//  ArtworkAndInfoToUploadViewController.swift
//  AlphaANativeApp
//
//  Created by Emiko Clark on 8/1/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

// MARK: - Protocols

protocol UploadArtworkDelegate: class {
    func cancelPickSourceVCFromUploadArtworkVC()
}

class ArtworkAndInfoToUploadViewController: UIViewController, UITextViewDelegate  {
    
    // MARK: - Properties

    // outlets
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var contentview: UIView!
    @IBOutlet weak var selectedArtwork: UIImageView!
    @IBOutlet weak var artworkTitle: UITextField!
    @IBOutlet weak var artworkDescription: UITextView?
    @IBOutlet weak var submitForVotingButton: UIButton!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var medium: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var width: UITextField!
    @IBOutlet weak var metatagsTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // buttons
    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var abstractButton: UIButton!
    @IBOutlet weak var representativeButton: UIButton!
    @IBOutlet weak var photographicButton: UIButton!
    @IBOutlet weak var figurativeButton: UIButton!
    @IBOutlet weak var experimentalButton: UIButton!
    @IBOutlet weak var landscapeButton: UIButton!
    @IBOutlet weak var portraitButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var currentButton = UIButton()
    var postUploadArtworkData = [String:Any]()
    var selectedImage = UIImage()
    var pickSourceVC = PickUploadSourceViewController()
    var artViewVC = ArtistArtView()
    var uploadArtworkDelegate: UploadArtworkDelegate?
    var metatags = [String]()
    var hasCategorySelected = false
    var hasVotingSelected = false
    
    // MARK: - View Load Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the activity indicator
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = .blue
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
        // setup tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
        // add cancel button to navbar
        self.navigationItem.title = "Upload Artwork"
        let cancelButton = UIButton(type: .custom)
        cancelButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        cancelButton.tintColor = UIColor.black
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font =  Alphaa.fontMarkR18
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
        self.navBar.setItems([navigationItem], animated: true)
        
        // set hastag converting delegate
        metatagsTextView.delegate = self
        
        setupView()
    }
    
    func setupView() {
        
        // put blue border around all buttons
        voteButton.layer.borderWidth = 1
        voteButton.layer.borderColor = Alphaa.blueColorA
        voteButton.layer.backgroundColor = UIColor.white.cgColor
        abstractButton.layer.borderWidth = 1
        abstractButton.layer.borderColor = Alphaa.blueColorA
        abstractButton.layer.backgroundColor = UIColor.white.cgColor
        representativeButton.layer.borderWidth = 1
        representativeButton.layer.borderColor = Alphaa.blueColorA
        representativeButton.layer.backgroundColor = UIColor.white.cgColor
        photographicButton.layer.borderWidth = 1
        photographicButton.layer.borderColor = Alphaa.blueColorA
        photographicButton.layer.backgroundColor = UIColor.white.cgColor
        figurativeButton.layer.borderWidth = 1
        figurativeButton.layer.borderColor = Alphaa.blueColorA
        figurativeButton.layer.backgroundColor = UIColor.white.cgColor
        experimentalButton.layer.borderWidth = 1
        experimentalButton.layer.borderColor = Alphaa.blueColorA
        experimentalButton.layer.backgroundColor = UIColor.white.cgColor
        landscapeButton.layer.borderWidth = 1
        landscapeButton.layer.borderColor = Alphaa.blueColorA
        landscapeButton.layer.backgroundColor = UIColor.white.cgColor
        portraitButton.layer.borderWidth = 1
        portraitButton.layer.borderColor = Alphaa.blueColorA
        portraitButton.layer.backgroundColor = UIColor.white.cgColor
        
        // put border around textview
        artworkTitle.layer.borderWidth = 1
        artworkTitle.layer.cornerRadius = 4
        artworkTitle.layer.borderColor = UIColor.lightGray.cgColor
        artworkDescription?.layer.borderWidth = 1
        artworkDescription?.layer.cornerRadius = 4
        artworkDescription?.layer.borderColor = UIColor.lightGray.cgColor
        metatagsTextView?.layer.borderWidth = 1
        metatagsTextView?.layer.cornerRadius = 4
        metatagsTextView?.layer.borderColor = UIColor.lightGray.cgColor
        
        // show selected image
        selectedArtwork.contentMode = .scaleAspectFit
        selectedArtwork.image = selectedImage
    }
    
    // MARK: - Button Tapped Methods

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        
        // cancel picker view
        self.dismiss(animated: true, completion: nil)
        pickSourceVC.hideView = true
        self.uploadArtworkDelegate?.cancelPickSourceVCFromUploadArtworkVC()
    }

    @IBAction func votingButtonTapped(_ sender: UIButton) {
        // allows the artwork to be included in voting cycle
        
        // change button state
        sender.isSelected = !sender.isSelected

        if(sender.isSelected == true)  {
            //  select button
            sender.layer.backgroundColor = Alphaa.blueColorA
            postUploadArtworkData["voting_submit"] = true
        } else  {
            // deselected button
            sender.layer.backgroundColor = UIColor.white.cgColor
            postUploadArtworkData["voting_submit"] = false
        }
    }
    
    @IBAction func selectArtworkCategory(button: UIButton) {
        // allows only one button to be highlighted and category to be set for artwork category. Deselects previously selected button and highlights the new one.
        
        button.isSelected = !button.isSelected

        if button === currentButton { return }
        
        // clear previously selected button
        currentButton.layer.backgroundColor = UIColor.white.cgColor
        
        // add the code to set the attributes of 'button'
        button.layer.backgroundColor = Alphaa.blueColorA
        
        // assigns the category of artwork, only one can be selected
        switch button.tag {
            
        case 1:
            print("abstractButton")
            if button.isSelected {
                postUploadArtworkData["category"] = "Abstract"
                hasCategorySelected = true
            }
        case 2:
            print("representativeButton")
            if button.isSelected {
                postUploadArtworkData["category"] = "Representative"
                hasCategorySelected = true
            }
        case 3:
            print("photographicButton")
            if button.isSelected {
                postUploadArtworkData["category"] = "Photographic"
                hasCategorySelected = true
            }
        case 4:
            print("figurativeButton")
            if button.isSelected {
                postUploadArtworkData["category"] = "Figurative"
                hasCategorySelected = true
            }
        case 5:
            print("experimentalButton")
            if button.isSelected {
                postUploadArtworkData["category"] = "Experimental"
                hasCategorySelected = true
            }
        case 6:
            print("landscapeButton")
            if button.isSelected {
                postUploadArtworkData["category"] = "Landscape"
                hasCategorySelected = true
            }
        case 7:
            print("portraitButton")
            if button.isSelected {
                postUploadArtworkData["category"] = "Portrait"
                hasCategorySelected = true
            }
        default:
            print("default")
            // send alert that a category is required
            showAlertBox(title: "Artwork Category Required", msg: "Please select a category")

        }
        currentButton = button
    }
    
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        // minimally validates required fields and creates postUploadArtworkData dictionary with artwork info about, converts image file to base64,  and sends a POST request to the server. Returns a success or failure message in alert box.
        
        var hasTitle = false
        var hasDescription = false
        var hasYear = false
        var hasMedium = false
        var hasWidth = false
        var hasHeight = false

        if (artworkTitle.text?.characters.count)! > 0 {
            hasTitle = true
        }

        if (artworkDescription?.text.characters.count)! > 0 {
            hasDescription = true
        }
        
        if (year.text?.characters.count)! > 0 {
            // ??? do we need a check for a valid year
            hasYear = true
        }

        if (medium.text?.characters.count)! > 0 {
            hasMedium = true
        }

        if (width.text?.characters.count)! > 0 {
            hasWidth = true
        }

        if (height.text?.characters.count)! > 0 {
            hasHeight = true
        }
        
        // if required fields are filled, and all checks pass then create json
        
        if (hasTitle && hasDescription && hasCategorySelected && hasYear && hasMedium && hasWidth && hasHeight) {
            
            // create json object to upload
            postUploadArtworkData["title"] = artworkTitle.text
            postUploadArtworkData["description"] = artworkDescription?.text
            postUploadArtworkData["year"] = year.text
            postUploadArtworkData["medium"] = medium.text
            postUploadArtworkData["width"] = width.text
            postUploadArtworkData["height"] = height.text
            
            // set voting
            if postUploadArtworkData["voting_submit"] == nil {
                postUploadArtworkData["voting_submit"] = false
            } else {
                postUploadArtworkData["voting_submit"] = true
            }
            
            // include metatags
            postUploadArtworkData["metatags"] = self.metatags
            
            //format selected image for json
            let imageData = UIImageJPEGRepresentation(selectedArtwork.image!, 1.0)
            let base64String = (imageData! as NSData).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            let fullBase64String = "data:image/jpeg;base64," + base64String as String
            postUploadArtworkData["file"] = fullBase64String

            // start activity indicator to show upload processes in progress
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        
            // POST artwork data to server
            AccountArtistManager.uploadArtwork(params: postUploadArtworkData, completion: { (success) in
                
                //stop activity indicator - process complete
                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = true
                
                // prepare alert message for success or failed upload
                if success {
                    //present success alert
                    self.showAlertBox(title: "Success!", msg: "Artwork has uploaded and is being processed." )
                } else {
                    //present failure alert from presenting
                    self.showAlertBox(title: "Failed!", msg: "Try uploading the artwork again.")
                }
            })
        }
    }
    
    // MARK: - Misc Methods

    func tap(gesture: UITapGestureRecognizer) {
        // dismiss keyboard when in a textfield
//        artworkTitle.resignFirstResponder()
//        artworkDescription?.resignFirstResponder()
//        year.resignFirstResponder()
//        medium.resignFirstResponder()
//        width.resignFirstResponder()
//        height.resignFirstResponder()
//        metatagsTextView.resignFirstResponder()
        
        [artworkTitle, year, medium, width,height].forEach{$0.resignFirstResponder()}
        [artworkDescription, metatagsTextView].forEach{$0?.resignFirstResponder()}
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Handle hiding the keyboard.
        self.view.endEditing(true)
    }

    func showAlertBox(title: String, msg: String) {
        // show alert box to show success or fail message of the upload
        let alertBox = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in

            self.dismiss(animated: true, completion: {
                // dismiss the picker view
                self.uploadArtworkDelegate?.cancelPickSourceVCFromUploadArtworkVC()
            })
        }
        alertBox.addAction(okAction)
        self.present(alertBox, animated: true, completion: nil)
    }
    
    // MARK: - Hashtag Methods

    func textViewDidChange(_ textView: UITextView) {
        // creates hashtags for artwork
        turnHashtagsBlue()
    }
    
    func turnHashtagsBlue() {
        // changes text typed in the textview into blue hashtags and puts them into the textview
        let text = metatagsTextView.text! as NSString
        self.metatags = text.components(separatedBy: " ")
        
        let myBlackAttribute = [ NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName : UIFont.systemFont(ofSize: 17) ]
        
        let myAttrString = NSMutableAttributedString(string: text as String, attributes: myBlackAttribute )
        
        for word in self.metatags {
            if word.hasPrefix("#"){
                let matchRange:NSRange = text.range(of: word)
                
                myAttrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: matchRange)
            }
        }
        
        // set attributed text on a UILabel
        metatagsTextView.attributedText = myAttrString
    }
}


