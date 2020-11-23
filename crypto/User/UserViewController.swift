import UIKit

class UserViewController: UIViewController {
    var user: User = User(name: "", email: "")

    @IBOutlet var nameTextField: UITextField!

    @IBOutlet var nicknameTextField: UITextField!

    @IBOutlet var emailTextField: UITextField!

    func callback(needRegistration: Bool, message: String) {
        print(message)
        if needRegistration {
            showPage(presenter: self, viewId: "sign_in", storyBoardName: "ProfileStoryBoard")
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
