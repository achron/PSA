//
//  NewUserVC.swift
//  dummy
//
//  Created by Tejas Kashyap on 24/01/24.


import Foundation

import UIKit
import PSATracker

class NewUserVC: UIViewController,UITextFieldDelegate{
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    var alert = UIAlertController(title: "Message", message: "Wrong email or password!", preferredStyle: .alert)
    var viewModel = ViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        email.delegate = self
        password.delegate = self
        
        viewModel.action = { [weak self] in
            DispatchQueue.main.async {
                if let  data = self?.viewModel.detail?.data{
                    
                     
                    Preference.email = data.email
                    Preference.userId = data.id
                    Preference.userToken = data.token ?? ""
                    self?.alert.dismiss(animated: false)
                    Preference.isLogedIn = true
                    TrackerManager.loginEvent()
                    self?.navigateToLoggedView()
                } else{
                    self?.presentfailedPopup()
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func sifnupAction(_ sender: UIButton) {
        let name : String = name.text ?? ""
        let email : String = email.text ?? ""
        let password : String = password.text ?? ""
        
        if name.count >= 1 && email.count >= 1 && password.count >= 1  {
            
            viewModel.signUp([
                "city": "+1 (153) 318-2604",
                "country": "+1 (334) 998-7821",
                "dob": "1980-09-20",
                "email": email,
                "firstname": name,
                "gender": "+1 (985) 377-4669",
                "lastname": "",
                "password": password,
                "phone": "+1 (284) 134-3684",
                "state": "+1 (262) 402-9568",
                "username": name
            ])
            presentLoadingPopup()
        } else{
            presentPopup()
        }
    }
    
    func navigateToLoggedView(){
        if let loggedVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoggedUserVC") as? LoggedUserVC {
            loggedVC.message = email.text!
//            self.navigationController?.pushViewController(loggedVC, animated: true)
            UIApplication.firstKeyWindowForConnectedScenes?.rootViewController = loggedVC
            UIApplication.firstKeyWindowForConnectedScenes?.makeKeyAndVisible()
        }
    }
    
    func presentPopup(){
        self.alert.dismiss(animated: true)
        alert = UIAlertController(title: "Message", message: "Wrong name,email or password!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler:nil))
        self.present(alert, animated: true);
        TrackerManager.logout()
    }
    func presentLoadingPopup(){
         self.alert.dismiss(animated: true)
         alert = UIAlertController(title: "Message", message: "Signing Up", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "ok", style: .default, handler:nil))
        self.present(alert, animated: true)
        
        
    }
    func presentfailedPopup(){
        self.alert.dismiss(animated: true)
        alert = UIAlertController(title: "Message", message: viewModel.detail?.message?.localizedUppercase ?? "Sorry Failed to Sign up, Please check Email and Password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler:nil))
        self.present(alert, animated: true)
        
        
    }
}
