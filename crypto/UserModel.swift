import Alamofire
import Foundation

class User {
    var name: String
    var email: String
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }

    func GetFromServer() -> Bool {
        AF.request("http://jsonplaceholder.typicode.com/posts").responseJSON { response in
            print(response)
        }
        name = "Иван"
        email = "Иванов"
        return true // not exist
    }
}
