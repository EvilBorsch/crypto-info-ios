import UIKit

class UserViewController: UIViewController {
        
    @IBOutlet weak var label: UILabel!
    var user:User=User(name: "user")
    
    
    func showPage(viewId: String,storyBoardId: String="Main"){
        let storyboard = UIStoryboard(name: storyBoardId, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: viewId)
        self.present(vc, animated: true)
    }
    
    
    func userContoller(){
        let isExist=self.user.GetFromServer()
        if (!isExist){
            // TODO вместо прямого перекидывания, создаем две кнопочки зарегаться и войти и уже при клике на них делаем showPage на логин или регистрацию
            showPage(viewId: "sign_in")
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


