import UIKit

class UserViewController: UIViewController {
        
    @IBOutlet weak var label: UILabel!
    var user:User=User(name: "user")
    

    func userContoller(){
        let isExist=self.user.GetFromServer()
        if (!isExist){
            showPage(presenter:self,viewId: "sign_in",storyBoardName: "ProfileStoryBoard")
        }else{
            label.text="Типа с сервера прислались хорошие данные и тут будем заполнять профайл"
        }
    }
    // TODO выделить регистрацию и логин в отдельный сториборд
    override func viewDidLoad() {
        super.viewDidLoad()
        userContoller()
    }
}


