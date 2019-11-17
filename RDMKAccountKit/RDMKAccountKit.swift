//
//  RDMKAccountKit.swift
//  CertificateTest
//
//  Created by Nafis Islam on 7/11/19.
//  Copyright © 2019 Nafis Islam. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

public class RDMKAccountKit{
    
    public var appImage: String = ""
    public var appName: String = ""
    public var backgroundColor: UIColor = UIColor(hexString: "#009F6D")
    public var apiKey = ""
    public var requestUrl = ""
    public var decodeFunction: ((_ data: Data) -> Any)
    
    
    public init(appImage: String, appName: String, backgroundColor: UIColor, apiKey: String, requestUrl: String, decodeFunction: @escaping ((_ data: Data) -> Any)){
        
        self.appImage = appImage
        self.backgroundColor = backgroundColor
        self.appName = appName
        self.apiKey = apiKey
        self.requestUrl = requestUrl
        self.decodeFunction = decodeFunction
        
    }
    
    
    public func viewControllerForLogin() -> SignInViewController?{
        
        let viewController = UIStoryboard(name: "RDMK", bundle: Bundle(for: SignInViewController.self)).instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController
          viewController?.appIcon = appImage
          viewController?.appName = appName
          viewController?.apiKey = apiKey
          viewController?.requestUrl = requestUrl
          viewController?.decodeFunction = decodeFunction
          return viewController
        

    }
    
}
