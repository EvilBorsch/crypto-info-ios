import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet var EmailTextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!

    @IBOutlet var RepeatPasswordTextField: UITextField!


    
    @IBOutlet var NameTextField: UITextField!

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet var signInBtn: UIButton!

    @IBOutlet var imageLabel: UILabel!
    @IBOutlet var ImageView: UIImageView!
    
    var theme = 0
    
    func callback(data: String) {
        if (data != ""){
            showError(err: data, inputController: self)
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "main_user")
        DispatchQueue.main.async {
            self.tabBarController!.viewControllers![2]=vc
        }
    }

    @objc func imagePicked(tapGestureRecognizer: UITapGestureRecognizer) {
        ImagePickerManager().pickImage(self) { image in
            self.ImageView.image = image
            self.imageLabel.isHidden = true
        }
    }

    @IBAction func goToLoginClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ProfileStoryBoard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "sign_in")
        self.tabBarController!.viewControllers![2]=vc
    }
    @IBAction func signUpButtonClick(_ sender: Any) {
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
            showError(err: "Passwords is not equal", inputController: self)
            return
        }
        var sendedImage = ImageView.image
        if (sendedImage?.isSymbolImage == true){
            sendedImage=nil
        }
        globalUser.RegisterUser(email: email, password: password, nickname: name, avatar: sendedImage, callback: callback)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageLabel.isHidden = false

        let tap = UITapGestureRecognizer(target: self, action: #selector(imagePicked(tapGestureRecognizer:)))
        ImageView.addGestureRecognizer(tap)
        ImageView.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        theme = UserDefaults.standard.integer(forKey: "theme")
        signInBtn.tintColor = themeColor[theme]
        signUpButton.tintColor = themeColor[theme]
        
    }
}
