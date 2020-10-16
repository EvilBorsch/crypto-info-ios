//
//  UserModel.swift
//  crypto
//
//  Created by Дмитрий Гуляченков on 16.10.2020.
//

import Foundation


class User  {
    var name:String
    init(name: String) {
              self.name = name
        }
    func GetFromServer()->Bool{
        return false // not exist
    }
    
}
