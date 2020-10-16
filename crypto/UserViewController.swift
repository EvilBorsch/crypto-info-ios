import UIKit

class UserViewController: UIViewController {
        
    @IBOutlet weak var label: UILabel!
    var user:User=User(name: "user",email:"kek@kke.ru")
    

    func userContoller(){
        let isExist=self.user.GetFromServer()
        if (!isExist){
            showPage(presenter:self,viewId: "sign_in",storyBoardName: "ProfileStoryBoard")
        }else{
            label.text="Типа с сервера прислались хорошие данные и тут будем заполнять профайл"
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        userContoller()
    }
}


