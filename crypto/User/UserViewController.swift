import UIKit

class UserViewController: UIViewController {
    var user: User = User(nickname: "", email: "")

    @IBOutlet var nicknameTextField: UITextField!

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var ImageView: UIImageView!

    @IBAction func deleteCookieBtnClick(_ sender: Any) {
        let cstorage = HTTPCookieStorage.shared
        let url = URL(string: BASE_URL)
        if let cookies = cstorage.cookies(for: url!) {
            for cookie in cookies {
                cstorage.deleteCookie(cookie)
            }
        }
        nicknameTextField.text = ""
        emailTextField.text = ""
        
        let storyboard = UIStoryboard(name: "ProfileStoryBoard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "sign_in")
        DispatchQueue.main.async {
            self.tabBarController!.viewControllers![3]=vc
        }
        
    }

    func callback(needRegistration: Bool, message: String, user: User) {
        print(user)
        
        // showError(err: message,inputController: self)
        
        if needRegistration {
            let storyboard = UIStoryboard(name: "ProfileStoryBoard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "sign_in")
            self.tabBarController!.viewControllers![3]=vc
            
            return
        } else {
            nicknameTextField.text = user.nickname
            emailTextField.text = user.email
            ImageView.load(user.photoUrl)
            ImageView.isHidden=false
        }
    }

    func userContoller() {
        user.GetFromServer(callback: callback)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("im here")
        userContoller()
    }
}



