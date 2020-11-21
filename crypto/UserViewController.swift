import UIKit

class UserViewController: UIViewController {
    var user: User = User(name: "user", email: "kek@kke.ru")

    @IBOutlet var nameTextField: UITextField!

    @IBOutlet var nicknameTextField: UITextField!

    @IBOutlet var emailTextField: UITextField!

    func userContoller() {
        let isExist = user.GetFromServer()
        if !isExist {
            showPage(presenter: self, viewId: "sign_in", storyBoardName: "ProfileStoryBoard")
            return
        } else {
            nameTextField.text = user.name
            emailTextField.text = user.email
        }
    }

    struct Holder {
        static var counter = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Holder.counter == 0 {
            userContoller()
        }
        Holder.counter += 1
    }
}
