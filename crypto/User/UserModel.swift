import Alamofire
import Foundation

class User: Decodable {
    var name: String
    var email: String
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }

    func GetFromServer() -> (Bool, String?) {
        var message = ""
        guard let url = URL(string: BASE_URL + "api/user/get") else {
            print("url is not correct")
            return (false, "Internal server error")
        }
        var needRegistered = false

        AF.request(url).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let users = try JSONDecoder().decode(User.self, from: response.data!)
                    print(users)

                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }

            case let .failure(error):
                print("Request error: \(error.localizedDescription)")
            }
        }
        name = "Иван"
        email = "Иванов"
        return (needRegistered, message) // not exist
    }
}
