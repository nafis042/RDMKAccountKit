//
//  KeyChainStruct.swift
//  RDMKAccountKit
//
//  Created by Nafis Islam on 14/11/19.
//  Copyright © 2019 Nafis Islam. All rights reserved.
//

import Foundation

public struct keyChainStruct: Codable{
    var access_token: String
    var id: Int
    var name: String
    var phone: String
    var app_name: String

    init(access_token: String, id: Int, name: String, phone: String, app_name: String) {
        self.access_token = access_token
        self.id = id
        self.name = name
        self.phone = phone
        self.app_name = app_name
    }
}
