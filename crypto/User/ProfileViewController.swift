import UIKit

class ProfileViewController: UIViewController {
    var user = User(nickname: "", email: "")

    @IBOutlet var EmailTextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!

    @IBOutlet var RepeatPasswordTextField: UITextField!

    @IBOutlet var NameTextField: UITextField!

    @IBOutlet var signInBtn: UIButton!

    @IBOutlet var imageLabel: UILabel!
    @IBOutlet var ImageView: UIImageView!
    func callback(data: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "main_user")
        definesPresentationContext = true
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false)
    }

    @objc func imagePicked(tapGestureRecognizer: UITapGestureRecognizer) {
        ImagePickerManager().pickImage(self) { image in
            self.ImageView.image = image
            self.imageLabel.isHidden = true
        }
    }

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
        if password != repeatedPassword {
            showError(err: "Passwords is not equal")
        }

        user.RegisterUser(email: email, password: password, nickname: name, avatar: ImageView.image, callback: callback)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageLabel.isHidden = false

        let tap = UITapGestureRecognizer(target: self, action: #selector(imagePicked(tapGestureRecognizer:)))
        ImageView.addGestureRecognizer(tap)
        ImageView.isUserInteractionEnabled = true
    }
}
