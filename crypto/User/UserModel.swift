import Alamofire
import Foundation

class User: Codable {
    var name: String
    var email: String
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }

    func GetFromServer(callback: @escaping (Bool, String) -> Void) {
        var message = ""
        guard let url = URL(string: BASE_URL + "api/user/get") else {
            print("url is not correct")
            callback(false, "Internal Server Error")
            return
        }
        var needRegistered = false

        AF.request(url).responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                do {
                    let user = try JSONDecoder().decode(User.self, from: response.data!)
                    self.name = user.name
                    self.email = user.email
                    callback(needRegistered, message)
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                    let dataString = String(data: response.data!, encoding: .utf8) ?? ""
                    callback(true, dataString)
                }

            case let .failure(error):
                print("Request error: \(error.localizedDescription)")
            }
        }
        callback(needRegistered, message)
    }

    func RegisterUser(email: String, password: String, nickname: String) -> String {
        guard let url = URL(string: BASE_URL + "api/user/add") else {
            print("url is not correct")
            return "Internal server error"
        }
        let parameters: [String: String] = [
            "Email": email,
            "Password": password,
            "Nickname": nickname,
        ]
        var multipart = MultipartFormData()
        for (key, value) in parameters {
            multipart.append(value.data(using: String.Encoding.utf8)!, withName: key)
        }
        AF.upload(multipartFormData: multipart, to: url, method: .post).responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                do {
                    print("ok")
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }

            case let .failure(error):
                print("Request error: \(error.localizedDescription)")
            }
        }

        return ""
    }
}
