import UIKit

class UserViewController: UIViewController {
    var user: User = User(name: "user", email: "kek@kke.ru")

    @IBOutlet var nameTextField: UITextField!

    @IBOutlet var nicknameTextField: UITextField!

    @IBOutlet var emailTextField: UITextField!

    func userContoller() {
        let result = user.GetFromServer()
        let isExist = result.0
        let message = result.1
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

    override func viewDidLoad() {
        super.viewDidLoad()
        userContoller()
    }
}
