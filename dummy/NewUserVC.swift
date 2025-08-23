import UIKit
import PSATracker

class NewUserVC: UIViewController, UITextFieldDelegate {
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
                if let data = self?.viewModel.detail?.data {
                    PSATracker.shared.updatePreferences(
                        email: data.email,
                        userId: data.id,
                    
                        userToken: data.token ?? ""
                    )
                    self?.alert.dismiss(animated: false)
                    print(data, "login data")
                    
                    PSATracker.shared.loginEvent()
                    PSATracker.shared.userEvent()
                    self?.navigateToLoggedView() // Calls the method
                } else {
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
        let name: String = name.text ?? ""
        let email: String = email.text ?? ""
        let password: String = password.text ?? ""
        PSATracker.shared.updatePreferences(
            email: email,
           userId: "",
            userToken: "",
            isLogedIn: false
        )
        
        if name.count >= 1 && email.count >= 1 && password.count >= 1 {
            viewModel.signUp([
                "city": "Bengaluru",
                "country": "India",
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
        } else {
            presentPopup()
        }
    }

    // Add this method back
    func navigateToLoggedView() {
        if let loggedVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoggedUserVC") as? LoggedUserVC {
            loggedVC.message = email.text ?? ""
            UIApplication.firstKeyWindowForConnectedScenes?.rootViewController = loggedVC
            UIApplication.firstKeyWindowForConnectedScenes?.makeKeyAndVisible()
        }
    }

    func presentPopup() {
        self.alert.dismiss(animated: true)
        alert = UIAlertController(title: "Message", message: "Wrong name, email or password!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true)
        PSATracker.shared.logout()
    }

    func presentLoadingPopup() {
        self.alert.dismiss(animated: true)
        alert = UIAlertController(title: "Message", message: "Signing Up", preferredStyle: .alert)
        self.present(alert, animated: true)
    }

    func presentfailedPopup() {
        self.alert.dismiss(animated: true)
        alert = UIAlertController(title: "Message", message: viewModel.detail?.message?.localizedUppercase ?? "Sorry Failed to Sign up, Please check Email and Password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
