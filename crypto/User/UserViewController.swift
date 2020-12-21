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
//        showPage(presenter: self, viewId: "sign_in", storyBoardName: "ProfileStoryBoard")
    }

    func callback(needRegistration: Bool, message: String, user: User) {
        print(user)
        print("usrImng: ",user.photoImage)
        
        showError(err: message)
        
        if needRegistration {
            let storyboard = UIStoryboard(name: "ProfileStoryBoard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "sign_in")
            definesPresentationContext = true
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: false)
            return
        } else {
            nicknameTextField.text = user.nickname
            emailTextField.text = user.email
            ImageView.image = user.photoImage
        }
    }

    func userContoller() {
        user.GetFromServer(callback: callback)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userContoller()
    }
}
