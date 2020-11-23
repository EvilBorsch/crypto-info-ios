import UIKit

class UserViewController: UIViewController {
    var user: User = User(name: "", email: "")

    @IBOutlet var nameTextField: UITextField!

    @IBOutlet var nicknameTextField: UITextField!

    @IBOutlet var emailTextField: UITextField!

    @IBAction func deleteCookieBtnClick(_ sender: Any) {
        let cstorage = HTTPCookieStorage.shared
        let url = URL(string: BASE_URL)
        if let cookies = cstorage.cookies(for: url!) {
            for cookie in cookies {
                cstorage.deleteCookie(cookie)
            }
        }
        nameTextField.text = ""
        nicknameTextField.text = ""
        emailTextField.text = ""
        showPage(presenter: self, viewId: "sign_in", storyBoardName: "ProfileStoryBoard")
    }

    func callback(needRegistration: Bool, message: String) {
        print(message)
        if needRegistration {
            let storyboard = UIStoryboard(name: "ProfileStoryBoard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "sign_in")
            self.definesPresentationContext = true
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false)
            return
        } else {
            nameTextField.text = user.name
            emailTextField.text = user.email
        }
    }

    func userContoller() {
        let result = user.GetFromServer(callback: callback)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userContoller()
    }
}
