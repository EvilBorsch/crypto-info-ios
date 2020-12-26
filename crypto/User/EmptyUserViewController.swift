import UIKit

class EmptyUserViewController: UIViewController {

    func callback(needRegistration: Bool, message: String, user: User) {
        DispatchQueue.main.async {
            if needRegistration {
                let storyboard = UIStoryboard(name: "ProfileStoryBoard", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "sign_in")
                self.tabBarController!.viewControllers![3]=vc
            } else {
                let storyboard = UIStoryboard(name: "ProfileStoryBoard", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "profile") as! UserViewController
                self.tabBarController!.viewControllers![3]=vc
            }
        }
    }

    func userContoller() {
        globalUser.GetFromServer(callback: callback)
    }

    override func viewDidAppear(_ animated: Bool) {
        print("im empty")
        super.viewDidAppear(animated)
        userContoller()
    }
}




