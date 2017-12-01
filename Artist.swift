//
//  Artist.swift
//  AlphaANativeApp
//
//  Created by Emiko Clark on 7/6/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import SwiftyJSON

class Artist: User {

    var socialPages: SocialPages? = nil
    var bio_video: String? = nil   // "https://player.vimeo.com/video/203781973"
    var followeds: String? = nil
    var followers: String? = nil
    var favoritesArray: [Favorite]?
    var artistArtworksArray = [ArtistArtwork]()
    var artistBio:String?
    
    struct SocialPages {
        let facebook: String?
        let pinterest: String?
        let instagram: String?
        let twitter: String?
        let site: String?
        let blog: String?
        
        init(facebook: String, pinterest: String, instagram: String, twitter: String, site: String, blog: String) {
            self.facebook = facebook
            self.pinterest = pinterest
            self.instagram = instagram
            self.twitter = twitter
            self.site = site
            self.blog = blog
        }
    }
    
    struct Favorite {
        var id: String
        var img: String     // "obra/71oSquhyMmwqW38.jpg"
    
        init(id: String, img: String) {
            self.id = id
            self.img = img
        }
    }
    
    struct ArtistArtwork  {
        let id: String         // "1566"
        let title: String
        let img: String        // "obra/53Fc5NUFOmgHmaF.jpg",
        let like_count: String?
        let created: String?
        let share_count: String?

        
        init(id: String, title: String, img: String, like_count: String, created: String, share_count: String) {
            self.id = id
            self.title = title
            self.img = img
            self.like_count = like_count
            self.created = created
            self.share_count = share_count
        }
    }
    
    // MARK: initializer
    
    init?(json: JSON) {

        if let bio_video = json["bio_video"].string {
            self.bio_video = bio_video
        }
        
        if let followeds = json["followeds"].string {
            self.followeds = followeds
        }
    
        if let followers = json["followers"].string {
            self.followers = followers
        }
        
        let bio = json["bio"].stringValue
        if bio != "" {
            self.artistBio = bio
        } else {
            self.artistBio = "This Artist has no bio."
        }
        
        self.favoritesArray = [Favorite]()
        self.artistArtworksArray = [ArtistArtwork]()

        super.init(userJson: json)
        
        // initialize the artist artworks array
        let artworkArrJson = json["artworks"]
        self.artistArtworksArray = initArtistArtworksArray(json: artworkArrJson)
        
        // initialize favorites array
        let favoritesJson = json["favorites"]
        self.favoritesArray = initFavoritesArray(json: favoritesJson)
    }
 
    func initFavoritesArray(json: JSON) -> [Favorite] {
        // initialize favoritesArray
        var favArray = [Favorite]()
        
        for (_,favInfo):(String, JSON) in json {
            
            guard let favId = favInfo["id"].string,
                let favImg = favInfo["img"].string else {
                print("error setting favorite id and img")
                continue
            }
            let favorite = Favorite.init(id: favId, img: favImg)
            favArray.append(favorite)
        }
        return favArray
    }
    
    func initArtistArtworksArray(json: JSON) -> [ArtistArtwork] {
        // initialize artist's artwork array
        var artworksArray = [ArtistArtwork]()
        
        for(_, artworkInfo):(String, JSON) in json {
            guard let id = artworkInfo["id"].string,
                let title = artworkInfo["title"].string,
                let img = artworkInfo["img"].string,
                let likeCount = artworkInfo["like_count"].string,
                let created = artworkInfo["created"].string,
                let shareCount = artworkInfo["share_count"].string else {
                continue
            }
            let artwork = ArtistArtwork(id: id, title: title, img: img, like_count: likeCount, created: created, share_count: shareCount)
            artworksArray.append(artwork)
        }
        return artworksArray
    }
}


