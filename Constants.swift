//
//  Constants.swift
//  AlphaANativeApp
//
//  Created by Emiko Clark on 6/19/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import Foundation

// alphaa key to make network calls to test server
let apiKey = "da39a3ee5e6b4b0d3255bfef95601890afd80709"


// alpha a related constants
struct Constants {
    
    // notification name constants
    static let userLoggedInNotification = Notification.Name(rawValue: "UserLoggedInNotification")
    static let updateScrollView = Notification.Name(rawValue: "updateScrollView")
    
    // base url string for making API calls to test server
    static let baseTestServerURL = "https://beta-api.alphaainc.com/v3.0/app/"
}

enum Alphaa {
    
    // base url for images to test server
    static let baseImageURL = "https://beta-assets.alphaainc.com/media/w640/"
    
    // the alphaa green color definition
    static let blueColorA = UIColor(red:0.16, green:0.70, blue:0.74, alpha:1.0).cgColor
    static let blueColorB = UIColor(red:0.16, green:0.70, blue:0.74, alpha:1.0)

    // the alphaa font definitions
    static let fontMarkR18 = UIFont(name: "Mark-Regular", size: 18.0)
    static let fontMarkR20 = UIFont(name: "Mark-Regular", size: 20.0)
    
    // maximum width and height of images the server allows from camera/photo library when uploading artwork
    static let MAX_IMAGE_WIDTH  = 2000
    static let MAX_IMAGE_HEIGHT = 2000
}

extension Notification.Name {
    // notification names
    static let REFRESH_NOTIFICATION = NSNotification.Name("RefreshCVNotification")
}



