//
//  UserModel.swift
//  crypto
//
//  Created by Дмитрий Гуляченков on 16.10.2020.
//

import Foundation


class User  {
    var name:String
    var email:String
    init(name: String,email:String) {
        self.name = name
        self.email=email
        }
    func GetFromServer()->Bool{
        return false // not exist
    }
    
}
