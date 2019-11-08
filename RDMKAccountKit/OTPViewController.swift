//
//  OTPViewController.swift
//  CertificateTest
//
//  Created by Nafis Islam on 5/11/19.
//  Copyright © 2019 Nafis Islam. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftKeychainWrapper

class OTPViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtOTP6: UITextField!
    @IBOutlet weak var txtOTP5: UITextField!
    @IBOutlet weak var txtOTP4: UITextField!
    @IBOutlet weak var txtOTP3: UITextField!
    @IBOutlet weak var txtOTP2: UITextField!
    @IBOutlet weak var txtOTP1: UITextField!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var CheckImageView: UIImageView!
    @IBOutlet weak var LoadingView: UIView!
    @IBOutlet weak var TopBackView: UIView!
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var ResendButton: UIButton!
    var delegate: RDMKAccountDelegate?
    
    var Phone: String = ""
    var Token: String = ""
    
    
    @IBAction func BackButtonPressed(_ sender: Any) {
        print("back button pressed")
    }
    
    
    @IBAction func ResendButtonPressed(_ sender: Any) {
        print("resend button pressed")
    }
    
    
    @IBAction func NextButtonPressed(_ sender: Any) {
        print("next Button pressed")
        var Otp = txtOTP1.text! + txtOTP2.text! + txtOTP3.text! + txtOTP4.text! + txtOTP5.text!
        Otp += txtOTP6.text!
        print(Otp)
        callApi(Otp: Otp)
        
        UIView.animate(withDuration: 0.3, animations: {

            self.NextButton.alpha = 0.0
            self.BackButton.alpha = 0.0
            self.TopBackView.alpha = 0.0

        }, completion: { finish in
            print("animation complete")

            UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {

                self.LoadingView.transform = CGAffineTransform(scaleX: 0.62, y: 0.62)

            }, completion: nil)
        })
        
        

    }
    
    func callApi(Otp: String){
        
        
        let url = "http://18.188.27.170/sso/login/"
            let parameters = [
                "phone": "\(Phone)",
                "otp": "\(Otp)",
                "token": "\(Token)",
                "native": "1"
            ]
            AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.data {
                        do {
                            let json = try JSON(data: value)
                            print(json["access_token"].string!)
                            DispatchQueue.main.async {
                                    self.LoadingView.layer.removeAllAnimations()
                                    self.LoadingView.alpha = 0.0
                                    self.LoadingView.transform = .identity
                                    self.CheckImageView.alpha = 1.0
                                }

                               DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                   UIView.animate(withDuration: 0.5, animations: {
                                       self.CheckImageView.setImageColor(color: UIColor(hexString: "#FFFFFF"))
                                       self.LoadingView.alpha = 1.0
                                   }, completion: { finish in
                                       print("animation complete")
                                   })
                               }
                            let saveSuccessful: Bool = KeychainWrapper.standard.set(json["access_token"].string!, forKey: "ridmik_access_token")
                            if(saveSuccessful){
                                print("stored data in keychain")
                                self.delegate?.didCompleteLoginWithAccessToken(token: json["access_token"].string!)
                            }
                            else{
                                print("failed to store data in keychain")
                                self.delegate?.didFailWithError(error: "something went wrong")
                            }
                        } catch let error as NSError {
                            print( "JSON parse error \(error)")
                            self.delegate?.didFailWithError(error: "token parse error")
                        }
                       
                    }
                   

                    
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtOTP1.backgroundColor = UIColor.clear
        txtOTP2.backgroundColor = UIColor.clear
        txtOTP3.backgroundColor = UIColor.clear
        txtOTP4.backgroundColor = UIColor.clear
        txtOTP5.backgroundColor = UIColor.clear
        txtOTP6.backgroundColor = UIColor.clear
        
        CheckImageView.setImageColor(color: UIColor(hexString: "#39B54A"))
        CheckImageView.alpha = 0.0
        
        addBottomBorderTo(textField: txtOTP1)
        addBottomBorderTo(textField: txtOTP2)
        addBottomBorderTo(textField: txtOTP3)
        addBottomBorderTo(textField: txtOTP4)
        addBottomBorderTo(textField: txtOTP5)
        addBottomBorderTo(textField: txtOTP6)
        
        txtOTP1.delegate = self
        txtOTP2.delegate = self
        txtOTP3.delegate = self
        txtOTP4.delegate = self
        txtOTP5.delegate = self
        txtOTP6.delegate = self
        
        
        TopBackView.isUserInteractionEnabled = true
          let TopBackViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.TopBackViewTapped))
          TopBackView.addGestureRecognizer(TopBackViewTapGesture)
        
        txtOTP1.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    @objc func TopBackViewTapped(){
        print("top back view tapped")
        self.view.endEditing(true)
    }
    
    func addBottomBorderTo(textField:UITextField) {
        let layer = CALayer()
        layer.backgroundColor = UIColor.gray.cgColor
        layer.frame = CGRect(x: 0.0, y: textField.frame.size.height - 2.0, width: textField.frame.size.width, height: 2.0)
        textField.layer.addSublayer(layer)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if ((textField.text?.count)! < 1 ) && (string.count > 0) {
             if textField == txtOTP1 {
                 txtOTP2.becomeFirstResponder()
             }
             
             if textField == txtOTP2 {
                 txtOTP3.becomeFirstResponder()
             }
             
             if textField == txtOTP3 {
                 txtOTP4.becomeFirstResponder()
             }
             
             if textField == txtOTP4 {
                 txtOTP5.becomeFirstResponder()
             }
            
            if textField == txtOTP5 {
                txtOTP6.becomeFirstResponder()
            }
            
            if textField == txtOTP6 {
                txtOTP6.resignFirstResponder()
            }
             
             textField.text = string
             return false
         } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
             if textField == txtOTP2 {
                 txtOTP1.becomeFirstResponder()
             }
             if textField == txtOTP3 {
                 txtOTP2.becomeFirstResponder()
             }
             if textField == txtOTP4 {
                 txtOTP3.becomeFirstResponder()
             }
             if textField == txtOTP5 {
                     txtOTP4.becomeFirstResponder()
             }
             if textField == txtOTP6 {
                     txtOTP5.becomeFirstResponder()
             }
             if textField == txtOTP1 {
                 txtOTP1.resignFirstResponder()
             }
             
             textField.text = ""
             return false
         } else if (textField.text?.count)! >= 1 {
             textField.text = string
             return false
         }
         
         return true
     }
    
}
