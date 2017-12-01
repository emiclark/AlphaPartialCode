//
//  Artwork.swift
//  AlphaANativeApp
//
//  Created by Emiko Clark on 6/9/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import SwiftyJSON

class Artwork: NSObject {

    let id: String      // ex: "233",
    let uid: String     // ex: "1419",
    var author_name: String     // ex: "Rodrigo Oliveira"
    var author_email: String?
    var author_avatar: String?   // ex: "usuario/avatar/DONwI8Czl2vTRY6.jpg"
    var title: String?
    var img :  String   // ex: "obra/d90ae81cc9e605eb0399a5c17947f2d8bf69d9e7.jpg"
    var artDescription: String?  // ex: "Panning de um skatista a noite no centro de …"
    let category: String    // ex: "Photographic"
    var cat_id: String?      // ex: "5"
    
    var like_count: String?     // ex: "3"
    var share_count: String?    // ex: "0"
    var width:  String?
    var height: String?
    var created: String?     // ex: "2015-10-06 11:23:17"
    var voting_submit: String? // ex: "1"

    var artworkViews : [ArtworkView]?
    var productsArray : [Product]?
    var status: Status?
    var label: Label?
    
    var actualImage: UIImage?
    var profileImage: UIImage?

    struct Product  {
        var alias: String?   // ex: "rush-hour"
        var type:  String?   // ex: "frame"
        var price_br: String?
        var price_us: String?
    }
    
    struct ArtworkView  {
        let id: String?          // ex: "1566"
        let title: String?
        let img: String?         // ex: "obra/53Fc5NUFOmgHmaF.jpg"
        let author_name: String?
        
        init(id: String, title: String, img: String, authorName: String) {
            self.id = id
            self.title = title
            self.img = img
            self.author_name = authorName
        }
    }
    
    
    enum Label: String {
        case nc_prints = "nc_prints"
        case canvas = "canvas"
        case prints = "prints"
    }

    enum Status: String {
        case unsubmitted = "unsubmitted"    // The artist does not want the work to participate in a vote
        case submitted   = "submitted"      // The artist wants the work to participate in a vote
        case voting      = "voting"         // This work is in the current vote
        case voted       = "voted"          // Already participated in a vote
        case production  = "production"     // Has participated and won a vote, and is now available for sale
    }

    // MARK: initializer methods
    
    init?(json: JSON)  {
        // artwork object from json
        guard let id = json["id"].string ,
        let uid = json["uid"].string,
        let authorName = json["author_name"].string else {
            print("error setting id, uid, authorName, authorEmail")
           return nil
        }
        
        guard let authorAvatar = json["author_avatar"].string,
            let title = json["title"].string,
            let img   = json["img"].string,
            let artDescription = json["description"].string,
            let category = json["category"].string else {
                print("error setting title, img, artDescription, category, catID")
                return nil
        }
        
        if let catID = json["cat_id"].string {
            self.cat_id = catID
        }

        guard let likeCount = json["like_count"].string,
            let shareCount = json["share_count"].string else {
                print("error setting likeCount, shareCount")
                return nil
        }
        
        if let width = json["width"].string {
            self.width = width
        } else {
            print("error setting width")
        }
        
        if let status = json["status"].string {
            self.status = Artwork.Status(rawValue: status)
        }
        
        if let height = json["height"].string {
            self.height = height
        } else {
            print("error setting height")
        }
        
        if let created = json["created"].string {
            self.created = created
        } else {
            print("error setting created")
        }
        
        if let votingSubmit = json["voting_submit"].string {
            self.voting_submit = votingSubmit
        } else {
            print("error setting votingSubmit")
        }
        
        // begin initializing
        self.id = id
        self.uid = uid 
        self.author_name = authorName
        self.author_avatar = authorAvatar
        self.title = title
        self.img = img
        self.artDescription = artDescription
        self.category = category
        self.like_count = likeCount
        self.share_count = shareCount

        super.init()
        
        // initialize artwork object
        let artworkViewJson = json["artworkViews"]
        self.artworkViews = createArtworkViewsFromJSONArray(jsonArray: artworkViewJson)
        
        // create and initialize products array if status = "production"
        if self.status == .production {
            
            let productJson = json["products"]
            
           let prodArray = createProductsFromJSONArray(jsonArray: productJson)
            self.productsArray = prodArray
        }
        
        if let label = json["label"].string {
            // initialize label enum
            switch label {
            case Label.nc_prints.rawValue:
                self.label = Artwork.Label(rawValue: "nc_prints" )
                break
            case Label.canvas.rawValue:
                self.label = Artwork.Label(rawValue: "canvas" )
                break
            case Label.prints.rawValue:
                self.label = Artwork.Label(rawValue: "prints" )
                break
            default:
                self.label = Artwork.Label(rawValue: "")
                print("error initializing enum Label")
                break
            }
        } else {
            print("error setting label")
        }
        
        if let status = json["status"].string {
            self.status = .production
            
            // initialize status enum
            switch status {
            case Status.unsubmitted.rawValue:
                self.status = Artwork.Status(rawValue: "unsubmitted")
                break
            case Status.submitted.rawValue:
                self.status = Artwork.Status(rawValue: "submitted")
                break
            case Status.voting.rawValue:
                self.status = Artwork.Status(rawValue: "voting")
                break
            case Status.voted.rawValue:
                self.status = Artwork.Status(rawValue: "voted")
                break
            case Status.production.rawValue:
                self.status = Artwork.Status(rawValue: "production")
                break
            default:
                self.status = Artwork.Status(rawValue: "")
                print("error initializing status")
                break
            }
        } else {
            print("error setting status")
        }
    }
    
    convenience init(artworkArray: [JSON]) {
        
        var artworkViewArray = [ArtworkView]()
        self.init(artworkArray: artworkArray)
        
        for artworkItem in artworkArray {
            
            guard let id = artworkItem["id"].string,
                let title = artworkItem["title"].string,
                let img = artworkItem["img"].string,
                let authorName = artworkItem["author_name"].string else {
                    print("Error initializing id, title, img, author name")
                    return
            }
            let artworkView = ArtworkView(id: id, title: title, img: img, authorName: authorName)
            artworkViewArray.append(artworkView)
            self.artworkViews = artworkViewArray
        }
    }
    
    // MARK: Helper init methods
    
    func createArtworkViewsFromJSONArray(jsonArray: JSON) -> [ArtworkView] {
        
        var artworkViews = [ArtworkView]()
        
        for (_,artworkDict):(String, JSON) in jsonArray {
            let id = artworkDict["id"].string
            let title = artworkDict["title"].string
            let img = artworkDict["img"].string
            let authorName = artworkDict["author_name"].string
            
            let artView = ArtworkView.init(id: id!, title: title!, img: img!, authorName: authorName!)
            artworkViews.append(artView)
        }
        return artworkViews
    }
    
    
    func createProductsFromJSONArray(jsonArray: JSON) -> [Product]{
        var productsArray = [Product]()
        
        for (_,productDict):(String, JSON) in jsonArray {
            guard let alias = productDict["alias"].string,
                let type  = productDict["type"].string,   // ex: "frame"
                let priceBR = productDict["price_br"].string,
                let priceUS = productDict["price_us"].string else {
                    print("error initializing product for productsArray")
                    continue
            }
            
            let product = Product.init(alias: alias, type: type, price_br: priceBR, price_us: priceUS)
            productsArray.append(product)
        }
        return productsArray
    }
}

