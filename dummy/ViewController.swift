//
//  ViewController.swift
//  dummy
//

import UIKit
import PSATracker

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldpassword: UITextField!
    @IBOutlet weak var buttonSignin: UIButton!
    var alert = UIAlertController(title: "Message", message: "Wrong email or password!", preferredStyle: .alert)
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldUsername.delegate = self
        textFieldpassword.delegate = self
        viewModel.action = { [weak self] in
            DispatchQueue.main.async {
                if let  data = self?.viewModel.detail?.data{
                    PSATracker.shared.updatePreferences(
                        email: data.email,
                        userId: data.id,
                        userToken: data.token ?? ""
                    )
                    PSATracker.shared.loginEvent()
                    PSATracker.shared.userEvent()
                    self?.alert.dismiss(animated: false)
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
    @IBAction func navigateToLoggedUserView(_ sender: Any) {
        
        
        let username : String = textFieldUsername.text ?? ""
        let password : String = textFieldpassword.text ?? ""
        
        if username.count >= 1 && password.count >= 1  {
            
            viewModel.login([
                "email": username,"password": password
            ])
            presentLoadingPopup()
        } else{
            presentPopup()
        }
        

    }
    
    @IBAction func newUserView(_ sender: Any) {
        if let loggedVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewUserVC") as? NewUserVC {
            self.navigationController?.pushViewController(loggedVC, animated: true)
        }
    }
    func navigateToLoggedView(){
        if let loggedVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoggedUserVC") as? LoggedUserVC {
            loggedVC.message = textFieldUsername.text!
//            self.navigationController?.pushViewController(loggedVC, animated: true)
            UIApplication.firstKeyWindowForConnectedScenes?.rootViewController = loggedVC
            UIApplication.firstKeyWindowForConnectedScenes?.makeKeyAndVisible()
        }
    }
    
    func presentPopup(){
        self.alert.dismiss(animated: true)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler:nil))
        self.present(alert, animated: true);
        PSATracker.shared.logout()
    }
    func presentLoadingPopup(){
         self.alert.dismiss(animated: true)
         alert = UIAlertController(title: "Message", message: "Logging in", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "ok", style: .default, handler:nil))
        self.present(alert, animated: true)
        
        
    }
    func presentfailedPopup(){
        self.alert.dismiss(animated: true)
        alert = UIAlertController(title: "Message", message: viewModel.detail?.message?.localizedUppercase ?? "Sorry Failed to login, Please check Email and Password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler:nil))
        self.present(alert, animated: true)
        
        
    }
}

extension UIApplication {
    static var firstKeyWindowForConnectedScenes: UIWindow? {
        UIApplication.shared
            // Of all connected scenes...
            .connectedScenes.lazy

            // ... grab all foreground active window scenes ...
            .compactMap { $0.activationState == .foregroundActive ? ($0 as? UIWindowScene) : nil }

            // ... finding the first one which has a key window ...
            .first(where: { $0.keyWindow != nil })?

            // ... and return that window.
            .keyWindow
    }
}
