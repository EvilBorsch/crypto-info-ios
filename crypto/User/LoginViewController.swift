import UIKit

class LoginViewController: UIViewController {
    var user: User = User(nickname: "", email: "")

    @IBOutlet weak var EmailField: UITextField!
    
    
    @IBOutlet weak var PasswordField: UITextField!
    
    func callback(error:String){
        if (error==""){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "main_user")
            definesPresentationContext = true
            vc.modalPresentationStyle = .overCurrentContext
            DispatchQueue.main.async {
                self.presentingViewController?.viewDidAppear(true)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else{
            showError(err: error)
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
