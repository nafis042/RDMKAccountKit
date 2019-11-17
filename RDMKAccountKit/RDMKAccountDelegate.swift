//
//  RDMKAccountDelegate.swift
//  CertificateTest
//
//  Created by Nafis Islam on 7/11/19.
//  Copyright © 2019 Nafis Islam. All rights reserved.
//

import Foundation


public protocol RDMKAccountDelegate : class{
    
    func didCompleteLoginWithAccessToken(token: String)
    func didFailWithError(error: String)
//    func viewControllerDidCancel(cancel: String)
}
