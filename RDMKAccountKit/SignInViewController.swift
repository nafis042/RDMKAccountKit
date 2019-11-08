//
//  SignInViewController.swift
//  CertificateTest
//
//  Created by Nafis Islam on 5/11/19.
//  Copyright © 2019 Nafis Islam. All rights reserved.
//

import UIKit
import SKCountryPicker
import CommonCrypto
import Alamofire


class SignInViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var FlagImageView: UIImageView!
    
    @IBOutlet weak var CheckImageView: UIImageView!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var SignInLabel: UILabel!
    @IBOutlet weak var NumberInputTextField: UITextField!
    @IBOutlet weak var CountryCodeLabel: UILabel!
    @IBOutlet weak var SignSecondLabel: UILabel!
    
    @IBOutlet weak var LoadingView: UIView!
    @IBOutlet weak var AlternateSignButton: UIButton!
    @IBOutlet weak var TopBackView: UIView!
    @IBAction func NextButtonPressed(_ sender: Any) {
        print("next button pressed")
        print(CountryCodeLabel.text!)
        print(NumberInputTextField.text!)
        self.view.endEditing(true)
        
        let phone = CountryCodeLabel.text! + NumberInputTextField.text!
        let time = "\(Int(Date().timeIntervalSince1970 * 1000))"
        
        callApi(Phone: phone, Token: (getCertificateString()! + phone + time).sha1(), Time: time)

        UIView.animate(withDuration: 0.3, animations: {

            self.NextButton.alpha = 0.0
            self.AlternateSignButton.alpha = 0.0
            self.TopBackView.alpha = 0.0


        }, completion: { finish in
            print("animation complete")

            UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {

                self.LoadingView.transform = CGAffineTransform(scaleX: 0.62, y: 0.62)

            }, completion: nil)
        })
    }
    
    func getCertificateString() -> String?
    {
        let profilePath: String? = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision")
        if( profilePath != nil )
        {
            let profileString = try? NSString.init(contentsOfFile: profilePath!,
                                                   encoding: String.Encoding.isoLatin2.rawValue)
            let scanner = Scanner(string: profileString! as String)
            guard scanner.scanUpTo("<data>", into: nil) != false else { return nil }

            // ... and extract plist until end of plist payload (skip the end binary part.
            var extractedPlist: NSString?
            guard scanner.scanUpTo("</data>", into: &extractedPlist) != false else { return nil }

                guard let data = extractedPlist?.substring(from: 6) else { return nil }
                print(data)
                let decodedData = Data(base64Encoded: data)?.hexDescription
                return decodedData!.sha1()
        }

        return nil
    }
    
    
    func callApi(Phone: String, Token: String, Time: String){

        let url = "http://18.188.27.170/sso/native/request_otp/"
        let parameters = [
            "phone": "\(Phone)",
            "time": "\(Time)",
            "api_key": "JS02qJlzt8",
            "token": "\(Token)"
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseString { response in
            switch response.response?.statusCode {
            case 200:
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
                           if let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
                               viewController.modalPresentationStyle = .fullScreen
                            viewController.Phone = Phone
                            viewController.Token = Token
                               self.present(viewController, animated: true, completion: nil)
                           }
                       })
                   }
                
            default:
                print("error")
            }
        }
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        CheckImageView.setImageColor(color: UIColor(hexString: "#39B54A"))
        CheckImageView.alpha = 0.0
        let attributedText = NSMutableAttributedString(string: "Sign in to ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
             NSAttributedString.Key.foregroundColor: UIColor(hexString: "#000000")])
        
        attributedText.append(NSAttributedString(string: "Ridmik News", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24), NSAttributedString.Key.foregroundColor: UIColor.black]))
        
        SignInLabel.attributedText = attributedText
        
        FlagImageView.isUserInteractionEnabled = true
        let FlagTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.FlagImageTapped))
        FlagImageView.addGestureRecognizer(FlagTapGesture)
        
        self.addDoneButtonOnKeyboard()
        self.NumberInputTextField.delegate = self
        
        guard let country = CountryManager.shared.currentCountry else {
            print("current country not found")
            self.FlagImageView.isHidden = true
            return
        }
        
        CountryCodeLabel.text = country.dialingCode
        FlagImageView.image = country.flag

        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.height)
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
                self.SignInLabel.alpha = 0.0
                self.SignSecondLabel.alpha = 0.0
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            self.SignInLabel.alpha = 1.0
            self.SignSecondLabel.alpha = 1.0
        
        }
    }
    
    @objc func FlagImageTapped() {
        print("Flag image tapped")
        self.NumberInputTextField.endEditing(true)
        presentCountryPickerScene(withSelectionControlEnabled: true)
    }
    
    func addDoneButtonOnKeyboard() {
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbar.barStyle = UIBarStyle.default
        doneToolbar.backgroundColor = UIColor.lightGray
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))

            var items = [UIBarButtonItem]()
            items.append(flexSpace)
            items.append(done)

            doneToolbar.items = items
            doneToolbar.sizeToFit()

            self.NumberInputTextField.inputAccessoryView = doneToolbar
        }

    @objc func doneButtonAction() {
            self.NumberInputTextField.resignFirstResponder()
            /* Or:
            self.view.endEditing(true);
            */
        }
    



}


private extension SignInViewController {
    
    func presentCountryPickerScene(withSelectionControlEnabled selectionControlEnabled: Bool = true) {
        switch selectionControlEnabled {
        case true:
            // Present country picker with `Section Control` enabled
            let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
                
                guard let self = self else { return }
                
                self.FlagImageView.isHidden = false
                self.FlagImageView.image = country.flag
                self.CountryCodeLabel.text = country.dialingCode
            }
            
            countryController.flagStyle = .circular
            countryController.isCountryFlagHidden = false
            countryController.isCountryDialHidden = false
        case false:
            // Present country picker without `Section Control` enabled
            let countryController = CountryPickerController.presentController(on: self) { [weak self] (country: Country) in
                
                guard let self = self else { return }
                
                self.FlagImageView.isHidden = false
                self.FlagImageView.image = country.flag
                self.CountryCodeLabel.text = country.dialingCode
            }
            
            countryController.flagStyle = .corner
            countryController.isCountryFlagHidden = false
            countryController.isCountryDialHidden = false
        }
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}

extension String {
    func sha1() -> String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}

extension Data {
    func sha1() -> String {
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        self.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(self.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}
