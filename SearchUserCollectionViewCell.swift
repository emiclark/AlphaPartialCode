//
//  SearchUserCollectionViewCell.swift
//  AlphaANativeApp
//
//  Created by Emiko Clark on 7/25/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class SearchUserCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userProfileView: UIView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // size and round the corner of artistProfileView and clipToBounds instead of artistProfileImageView
        
        let width = userProfileView.frame.size.width
        userProfileView.frame.size.width = width
        userProfileView.frame.size.height = width
        userProfileView.layer.cornerRadius = width / 2
        userProfileView.clipsToBounds = true
        
    }
    
}
