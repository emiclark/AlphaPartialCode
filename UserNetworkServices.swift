//
//  UserNetworkServices.swift
//  AlphaANativeApp
//
//  Created by Aditya Narayan on 7/5/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import Foundation

class UserNetworkServices {
    
    // MARK:- Get data for login/register

    static func loginExistingUser(userInfo: [String:String], completion: @escaping (Data) -> ()){
        let string = Constants.baseTestServerURL + "users/login"
        guard let url = URL(string: string) else {
            fatalError("COULD NOT MAKE A URL OBJECT OUT OF \(string)")
        }
        
        var request = URLRequest(url: url)
        
        do {
            let userData = try JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted)
            request.httpBody = userData
            
        } catch  {
            print("Error converting user info to JSON")
            return
        }
        

        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Authorization": apiKey
        ]
        
        request.httpMethod = "POST"
        //request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            guard let votingData:Data = data
                else {return}
            DispatchQueue.main.async {
                completion(votingData)
            }
            
        }.resume()
    }
    
    static func registerUser(userInfo: [String:String], completion: @escaping (Data) -> ()){
        
        let string = Constants.baseTestServerURL + "users/register"
        guard let url = URL(string: string) else {
            fatalError("COULD NOT MAKE A URL OBJECT OUT OF \(string)")
        }
        
        var request = URLRequest(url: url)
        //let userInfo = ["user":"user.beta@testing.com","security_key":"123456"]
        
        do {
            let userData = try JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted)
            request.httpBody = userData
            
        } catch  {
            print("Error converting user info to JSON")
            return
        }
        
        
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Authorization": apiKey
        ]
        
        request.httpMethod = "POST"
        //request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            guard let votingData:Data = data
                else {return}
            DispatchQueue.main.async {
                completion(votingData)
            }
            
            }.resume()
    }
    
    // download artist or collector data
    static func downloadArtistsOrCollectors(pageNum:Int, isArtist:Bool, completion: @escaping (Data) -> ()) {
        var string = ""
        if isArtist {
            //print("isArtist is True!")
            string = Constants.baseTestServerURL + "users/list/?page=\(pageNum)&count=15&profile=artist"
        } else {
            //print("isArtist is False!")
            string = "https://beta-api.alphaainc.com//v3.0/app/users/list/?page=\(pageNum)&count=15&profile=user"
        }
        guard let url = URL(string: string) else {
            fatalError("COULD NOT MAKE A URL OBJECT OUT OF \(string)")
        }
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            guard let artistsData:Data = data
                else {return}
            DispatchQueue.main.async {
                completion(artistsData)
            }
            
            }.resume()
    }
    
    
    // MARK: - Post artwork for artist
    
//    static func uploadArtwork(isArtist: Bool, json: [String: Any], completion: @escaping(Data) -> ()) {
//        
//        var string = ""
//    
//        if isArtist {
//            string = Constants.baseTestServerURL + "artworks/add/"
//            let jsonData = try? JSONSerialization.data(withJSONObject: json)
//            
//            guard let url = URL(string: string) else {
//                print("Fatal error creating URL from string")
//                return
//            }
//            
//            // create post request
//            var request = URLRequest(url: url)
//            request.setValue(apiKey, forHTTPHeaderField: "Authorization")
//            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//            request.httpMethod = "POST"
//            
//            // insert json data to the request
//            request.httpBody = jsonData
//            
//            URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
//                guard let artistsData: Data = data
//                    else {return}
//                DispatchQueue.main.async {
//                    completion(artistsData)
//                }
//            }.resume()
//        }
//    }

    
    
}
