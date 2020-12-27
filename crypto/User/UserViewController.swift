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
            self.tabBarController!.viewControllers![2]=vc
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
    
    let fiatKey = "fiat"
    let themeKey = "theme"
    
    @IBOutlet weak var currency: UIPickerView!
    @IBOutlet weak var fiatLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currency.dataSource = self
        currency.delegate = self
        
        
        let fiat =  UserDefaults.standard.integer(forKey: fiatKey)
        let theme = UserDefaults.standard.integer(forKey: themeKey)
        
        fiatLabel.textColor = themeColor[theme]
        themeLabel.textColor = themeColor[theme]
        settingsLabel.textColor = themeColor[theme]
        emailLabel.textColor = themeColor[theme]
        nicknameLabel.textColor = themeColor[theme]
        
        currency.selectRow(abs(fiat-5), inComponent: 0, animated: true)
        currency.selectRow(theme, inComponent: 1, animated: true)
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ImageView.layer.cornerRadius = 75
        ImageView.layer.masksToBounds = true
        
        userContoller()
    }
}



extension UserViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return fiats.count
        } else {
            return themes.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return fiats[abs(row - 5)]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if component == 1{
            return NSAttributedString(string: themes[row]!, attributes: [NSAttributedString.Key.foregroundColor: themeColor[row]!])
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            UserDefaults.standard.set(abs(row-5), forKey: fiatKey)
        } else {
            navigationController?.navigationBar.tintColor = themeColor[row]
            tabBarController?.tabBar.tintColor = themeColor[row]
            UserDefaults.standard.set(row, forKey: themeKey)
            
            fiatLabel.textColor = themeColor[row]
            themeLabel.textColor = themeColor[row]
            settingsLabel.textColor = themeColor[row]
            emailLabel.textColor = themeColor[row]
            nicknameLabel.textColor = themeColor[row]
        }
    }
    
}
