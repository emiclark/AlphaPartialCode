//
//  ArtistAboutViewController.swift
//  AlphaANativeApp
//
//  Created by Emiko Clark on 11/3/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class ArtistAboutViewController: UIViewController {
    
    @IBOutlet weak var biographyTextView: UITextView!

    @IBOutlet weak var bioHeight: NSLayoutConstraint!
    var userBio: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        biographyTextView.text = userBio ?? "Artist has not provided a biography."
    }
}
