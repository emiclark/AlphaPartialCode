//
//  SearchManager.swift
//  AlphaANativeApp
//
//  Created by Emiko Clark on 6/12/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: - Delegates

// delegates for artists
protocol reloadArtistInfoDataDelegate {
    func updateUI(withDetailedUser detailedUser: Artist)
}

protocol reloadWithArtworkDataDelegate {
    func updateUI(withArtworkData artwork: Artwork)
}

protocol LoadCVDataDelegate {
    func loadCVWithArtworkDelegate(withArtworkArray artworkArray: [Artist.ArtistArtwork])
}

// delegates for collectors
protocol reloadCollectorInfoDataDelegate {
    func updateUI(withCollector detailedUser: Collector)
}



class SearchManager {

    var user: User?
    var artist: Artist?
    var collector: Collector?
    var artwork: Artwork?

    var artistDelegate: reloadArtistInfoDataDelegate?
    var collectorDelegate: reloadCollectorInfoDataDelegate?
    var artworkDelegate: reloadWithArtworkDataDelegate?
    var loadCVDataDelegate: LoadCVDataDelegate?
    
    
    // MARK: Methods for the Search Tab
    

    func getArtistArtworksAfterUploadArtwork(_ userId: String) {
        // get info for a specific artist and create artist object
        NetworkServices.getArtistInfo(id: userId, completion: { (jsonData) in
            
            print("userid: ",userId)
            
            let json = JSON(data: jsonData)
            
            // parse json and create artist info object to populate userDetailVC
            let userJson = json["details"]
            print(userJson)
            
            let artistInfo = Artist(json: userJson)
            
            if let artistInfo = artistInfo {
                self.artist = artistInfo
                DispatchQueue.main.async {
                    self.loadCVDataDelegate?.loadCVWithArtworkDelegate(withArtworkArray: artistInfo.artistArtworksArray)
                }
            } else {
                print("Failed to create new artist object from JSON dictionary")
            }
        })
    }
    
    func getArtistArtworks(_ userId: String) {
        // get info for a specific artist and create artist object
        NetworkServices.getArtistInfo(id: userId, completion: { (jsonData) in
            
            print("data returned from NetworkServices.getArtistInfo() for  userid: ",userId)
            
            let json = JSON(data: jsonData)
            
            // parse json and create artist info object to populate userDetailVC
            let userJson = json["details"]
            print(userJson)
            
            let artistInfo = Artist(json: userJson)
            
            if let artistInfo = artistInfo {
                self.artist = artistInfo
                
                DispatchQueue.main.async {
                    self.loadCVDataDelegate?.loadCVWithArtworkDelegate(withArtworkArray: artistInfo.artistArtworksArray)
                }
            } else {
                print("Failed to create new artist object from JSON dictionary")
            }
        })
    }
    
    func getArtistInfo(_ userId: String, completion:@escaping (Artist) -> ()) {
        // get info for a specific artist and create artist object
        NetworkServices.getArtistInfo(id: userId, completion: { (jsonData) in
            
            let json = JSON(data: jsonData)
            
            // parse json and create artist info object to populate userDetailVC
            let userJson = json["details"]
            print(userJson)
            
            let artistInfo = Artist(json: userJson)
            
            if let artistInfo = artistInfo {
                self.artist = artistInfo
                DispatchQueue.main.async {
                    completion(self.artist!)
                    self.artistDelegate?.updateUI(withDetailedUser: self.artist!)
                    
                }
            } else {
                print("Failed to create new artist object from JSON dictionary")
            }
        })
    }
    
//    func getArtistInfo(_ userId: String) {
//        // get info for a specific artist and create artist object
//        NetworkServices.getArtistInfo(id: userId, completion: { (jsonData) in
//            
//            print("userid: ",userId)
//            
//            let json = JSON(data: jsonData)
//            
//             // parse json and create artist info object to populate userDetailVC
//            let userJson = json["details"]
//            print(userJson)
//            
//                let artistInfo = Artist(json: userJson)
//
//                if let artistInfo = artistInfo {
//                    self.artist = artistInfo
//                    DispatchQueue.main.async {
//                        completion(self.artist!)
//                        //self.artistDelegate?.updateUI(withDetailedUser: self.artist!)
//                        //print("Finished downloading artist profile!")
//                    }
//                } else {
//                    print("Failed to create new artist object from JSON dictionary")
//                }
//        })
//    }
    
    func getCollectorInfo(_ userId: String) {
        // get info for a specific collector and create collector object with favoritesArray
        print("func getCollectorInfo()")
        
        NetworkServices.getCollectorInfo(id: userId, completion: { (jsonData) in
            
            let json = JSON(data: jsonData)
            
            // parse json and create collector info object to populate userDetailVC
            let userJson = json["details"]
            print(userJson)
            
            let collectorInfo = Collector(json: userJson)
            
            if let collectorInfo = collectorInfo {
                self.collector = collectorInfo
                DispatchQueue.main.async {
                    self.collectorDelegate!.updateUI(withCollector: self.collector!)
                }
            } else {
                print("Failed to create new collector object from JSON dictionary")
            }
        })
    }
    
    
    // get individual artwork by ID
    func getArtWorkWithId(id: String) {
        // get artwork for specific id
        print("func getArtWorkWithId()")
        
        NetworkServices.getArtworkWithId(id: id, completion: {(jsonData) in
            let json = JSON(data: jsonData)
            
            // parse json and create artwork object to populate imageDetailVC
            let userJson = json["details"]
            print(userJson)
            
            let artworkData = Artwork(json: userJson)
            
            if let artworkData = artworkData {
                self.artwork = artworkData
                DispatchQueue.main.async {
                    self.artworkDelegate?.updateUI(withArtworkData: self.artwork!)
                }
            } else {
                print("Failed to create new artwork object from JSON dictionary")
            }
        })
    }
    
    func searchArtWorkToPurchase() {
        print("func searchArtWorkToPurchase()")
    }

    func searchArtWorkToVoteOn() {
        print("func searchArtWorkToVoteOn()")
    }
    
    func searchEvents() {
        print("func searchEvents()")
    }
    
    func searchNearYou() {
        print("func searchNearYou()")
    }
}

