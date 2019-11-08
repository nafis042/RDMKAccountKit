//
//  RDMKAccountKit.swift
//  CertificateTest
//
//  Created by Nafis Islam on 7/11/19.
//  Copyright © 2019 Nafis Islam. All rights reserved.
//

import Foundation
import UIKit


public class RDMKAccountKit{
    
    public var appImage: String = ""
    public var backgroundColor: UIColor = UIColor(hexString: "#009F6D")
    
    
    public init(appImage: String, backgroundColor: UIColor){
        
        self.appImage = appImage
        self.backgroundColor = backgroundColor
        
    }
    
    public func viewControllerForLogin() -> SignInViewController?{
        print(self.appImage)
        print(self.backgroundColor)
        let viewController = UIStoryboard(name: "RDMK", bundle: Bundle(for: SignInViewController.self)).instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController
        return viewController
    }
    
}
