import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var nicknameTextField: UILabel!
    
    @IBOutlet weak var emailTextField: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    

    @IBAction func logOutClick(_ sender: Any) {
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
    
//    func callback(needRegistration: Bool, message: String, user: User) {
//        
//        if needRegistration {
//            let storyboard = UIStoryboard(name: "ProfileStoryBoard", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "sign_in")
//            self.tabBarController!.viewControllers![3]=vc
//            
//            return
//        } else {
//            nicknameTextField.text = user.nickname
//            emailTextField.text = user.email
//            ImageView.load(user.photoUrl)
//            ImageView.isHidden=false
//        }
//    }

    func userContoller() {
        //globalUser.GetFromServer(callback: callback)
        print(globalUser.email)
        DispatchQueue.main.async {
            self.nicknameTextField.text = globalUser.nickname
            self.emailTextField.text = globalUser.email
            self.ImageView.load(globalUser.photoUrl)
            self.ImageView.isHidden=false
            
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("im here")
        userContoller()
    }
}



