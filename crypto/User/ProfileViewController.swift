import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet var EmailTextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!

    @IBOutlet var RepeatPasswordTextField: UITextField!

    @IBOutlet var NameTextField: UITextField!

    @IBOutlet var signInBtn: UIButton!

    @objc func didButtonClick() {
        let email = EmailTextField.text
        let password = PasswordTextField.text
        let repeatedPassword = RepeatPasswordTextField.text
        let name = NameTextField.text
        print(email, password, repeatedPassword, name)
    }

    func signInController() {
        signInBtn.addTarget(self, action: #selector(didButtonClick(_:)), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        signInController()
    }
}
