import Alamofire
import Foundation
import UIKit

class UserModel: Codable {
    var name: String
    var email: String
    var photo: String?
}

class User {
    var nickname: String
    var email: String
    var photoImage: UIImage?

    init(nickname: String, email: String) {
        self.nickname = nickname
        self.email = email
    }

    func GetFromServer(callback: @escaping (Bool, String, User) -> Void) {
        guard let url = URL(string: BASE_URL + "api/user/get") else {
            print("url is not correct")
            callback(false, "Internal Server Error", self)
            return
        }
        AF.request(url).responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                do {
                    let user = try JSONDecoder().decode(UserModel.self, from: response.data!)
                    self.nickname = user.name
                    self.email = user.email
                    let photoUrl = user.photo ?? ""
                    self.photoImage = getImageFromUrl(url: photoUrl)
                    callback(false, "", self)
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                    let dataString = String(data: response.data!, encoding: .utf8) ?? ""
                    callback(true, dataString, self)
                }

            case let .failure(error):
                print("Request error: \(error.localizedDescription)")
            }
        }
        callback(false, "", self)
    }

    func RegisterUser(email: String, password: String, nickname: String, avatar: UIImage?, callback: @escaping (String) -> Void) {
        guard let url = URL(string: BASE_URL + "api/user/add") else {
            print("url is not correct")
            return
        }
        let parameters: [String: String] = [
            "Email": email,
            "Password": password,
            "Nickname": nickname,
        ]
        var multipart = MultipartFormData()
        multipart.append(avatar!.jpegData(compressionQuality: 0.1)!, withName: "photo", fileName: "photo.jpeg", mimeType: "image/jpeg")
        for (key, value) in parameters {
            multipart.append(value.data(using: String.Encoding.utf8)!, withName: key)
        }
        AF.upload(multipartFormData: multipart, to: url, method: .post).responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                do {
                    callback("test") // TODO: add message
                    return
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }

            case let .failure(error):
                print("Request error: \(error.localizedDescription)")
            }
        }
    }
}
