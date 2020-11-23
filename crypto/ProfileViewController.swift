import UIKit

class ProfileViewController: UIViewController {
    var user = User(name: "", email: "")

    @IBOutlet var EmailTextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!

    @IBOutlet var RepeatPasswordTextField: UITextField!

    @IBOutlet var NameTextField: UITextField!

    @IBOutlet var signInBtn: UIButton!

    @IBAction func signUpButtonClick(_ sender: UIButton) {
        guard let email = EmailTextField.text else {
            print("no email")
            return
        }
        guard let password = PasswordTextField.text else {
            print("no password ")
            return
        }
        guard let repeatedPassword = RepeatPasswordTextField.text else {
            print("no repeated password")
            return
        }
        guard let name = NameTextField.text else {
            print("no nickname")
            return
        }
        let res = user.RegisterUser(email: email, password: password, nickname: name)
        print(res)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

