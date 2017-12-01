//
//  ArtistAndCollectorNetworkServices.swift
//  AlphaANativeApp
//
//  Created by Andy Wu on 7/5/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class ArtistAndCollectorNetworkServices {
    
    var currentUser: String?
    
    // MARK:- Post data for uploading artist artwork

    static func uploadArtwork(params: [String:Any], completion: @escaping (Data) -> ()) {
        // upload artwork and artwork details
        let urlString = Constants.baseTestServerURL + "artworks/add"
        
        guard let url = URL(string: urlString) else {
            print("Error converting url")
            return
        }
        
        var request = URLRequest(url: url)
        
        guard let json = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            print("FAILURE TO SERIALIZE UPLOAD ARTWORK JSON")
            return
        }
        
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            
            // handle reponse - error handling
            if error != nil {
                print("THERE WAS AN UPLOAD ERROR: \(error!.localizedDescription)")
            }
            
            let httpResponse = response as! HTTPURLResponse
            print(httpResponse.statusCode)
            
            guard let artworkData = data else { return }
            
            DispatchQueue.main.async {
                    completion(artworkData)
            }
            
            }.resume()
    }
    
    // MARK:- Get data for artist or collector
    
    static func downloadArtistsOrCollectors(pageNum:Int, isArtist:Bool, completion: @escaping (Data) -> ()) {
        // download all artists or collector based on ids to fill 'search artist' or 'search collectors' collection view
        
        var string = ""
        if isArtist {
            //print("isArtist is True!")
            string = Constants.baseTestServerURL + "users/list/?page=\(pageNum)&count=15&profile=artist"
        } else {
            //print("isArtist is False!")
            string = Constants.baseTestServerURL + "users/list/?page=\(pageNum)&count=15&profile=user"
        }
        guard let url = URL(string: string) else {
            fatalError("COULD NOT MAKE A URL OBJECT OUT OF \(string)")
        }
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            guard let usersData:Data = data
                else {return}
            DispatchQueue.main.async {
                completion(usersData)
            }
        }.resume()
    }
}

