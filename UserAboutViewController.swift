//
//  UserAboutViewController.swift
//  AlphaANativeApp
//
//  Created by Emiko Clark on 7/25/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class UserAboutViewController: UIViewController {

    @IBOutlet weak var biographyTextView: UITextView!
    
    var userBio: String?
    var isArtist: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        biographyTextView.sizeToFit()
        
        if isArtist! {
            biographyTextView.text = userBio ?? "Artist has not provided a biography."
        } else {
            biographyTextView.text = userBio ?? "Collector has not provided a biography."
   
        }
        
    }

}
