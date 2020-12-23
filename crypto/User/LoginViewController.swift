import UIKit

class LoginViewController: UIViewController {
    var user: User = User(nickname: "", email: "")

    @IBOutlet weak var EmailField: UITextField!
    
    @IBAction func clickRegitster(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ProfileStoryBoard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "sign_up")
        self.tabBarController!.viewControllers![3]=vc
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
        user.LoginUser(email: email,password: password,callback: callback)
    }
    
}
