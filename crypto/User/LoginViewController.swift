import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var signInbutton: UIButton!
    @IBOutlet weak var notRegisteredButton: UIButton!
    
    @IBAction func clickRegitster(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ProfileStoryBoard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "sign_up")
        self.tabBarController!.viewControllers![3]=vc
    }
    
    var theme = 0
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        
        theme = UserDefaults.standard.integer(forKey: "theme")
        signInbutton.tintColor = themeColor[theme]
        notRegisteredButton.tintColor = themeColor[theme]
    }
    
    @IBOutlet weak var PasswordField: UITextField!
    
    func callback(error:String){
        if (error==""){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "main_user")
            DispatchQueue.main.async {
                self.tabBarController!.viewControllers![3]=vc
            }
        }
        else{
            showError(err: error,inputController: self)
        }
    }
    
    @IBAction func onClick(_ sender: Any){
        guard let email = EmailField.text else {
            print("no email")
            return
        }
        guard let password = PasswordField.text else {
            print("no password ")
            return
        }
        globalUser.LoginUser(email: email,password: password,callback: callback)
    }
    
}

