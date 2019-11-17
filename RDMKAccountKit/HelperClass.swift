//
//  HelperClass.swift
//  RDMKAccountKit
//
//  Created by Nafis Islam on 13/11/19.
//  Copyright © 2019 Nafis Islam. All rights reserved.
//

import Foundation


public struct KeyStoreClass: Codable{
    var access_token: String
    var pwd: Bool
    var added_as_parent: Bool

    init(access_token: String, pwd: Bool, added_as_parent: Bool) {
        self.access_token = access_token
        self.pwd = pwd
        self.added_as_parent = added_as_parent
    }
}
