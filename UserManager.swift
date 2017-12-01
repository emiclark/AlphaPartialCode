//
//  UserManager.swift
//  AlphaANativeApp
//
//  Created by Emiko Clark on 6/12/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol checkStatus:class {
    func errorLoggingIn()
    func errorRegistering()
}


class UserManager {

    // This class is work in progress!!
    
    weak var delegate:checkStatus?

    func login(userEmail:String, userPassword: String, completion: @escaping (User) -> ()) {
        
        let userInfo = ["user":userEmail,"security_key":userPassword]
        
        UserNetworkServices.loginExistingUser(userInfo: userInfo) { (myData) in
            let json = JSON(data: myData)
            let jsonArray = json["userData"]
            
            let newUser = User(userJson: jsonArray)
            
            if let gotUser = newUser {
                completion(gotUser)
            } else {
                print("ERROR CREATING USER OBJECT FROM DATA")
                self.delegate?.errorLoggingIn()
            }
            
        
        }
        
        
    }
    
    func register(fullName:String, email:String, pass:String, profile:String, completion:@escaping (User)->()) {
        let userInfo = ["name":fullName,"email":email, "security_key":pass, "confirm_security_key":pass, "profile":profile]
        
        UserNetworkServices.registerUser(userInfo: userInfo) { (myData) in
            let json = JSON(data: myData)
            let jsonArray = json["userData"]
            
            let newUser = User(userJson: jsonArray)
            //print("USER DATA \(jsonArray)")
            if let gotUser = newUser {
                completion(gotUser)
            } else {
                print("ERROR CREATING USER OBJECT FROM DATA")
                self.delegate?.errorRegistering()
            }
        }
    }
    
    func logout(user: User) -> User {
        print("func logout(user: User) -> User ")
        return user
    }
    
    func deleteAccount(user: User) -> User {
        print("func deleteAccount(user: User) -> User ")
        return user
    }
    
}
