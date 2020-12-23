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
    var photoUrl: String

    init(nickname: String, email: String) {
        self.nickname = nickname
        self.email = email
        self.photoUrl=""
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
                    self.photoUrl=photoUrl
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
        let multipart = MultipartFormData()
        if (avatar != nil){
            multipart.append(avatar!.jpegData(compressionQuality: 0.1)!, withName: "photo", fileName: "photo.jpeg", mimeType: "image/jpeg")
        }
        for (key, value) in parameters {
            multipart.append(value.data(using: String.Encoding.utf8)!, withName: key)
        }
        AF.upload(multipartFormData: multipart, to: url, method: .post).responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                do {
                    let user = try JSONDecoder().decode(UserModel.self, from: response.data!)
                    self.nickname = user.name
                    self.email = user.email
                    let photoUrl = user.photo ?? ""
                    self.photoUrl = photoUrl
                    callback("")
                    return
                } catch _ as NSError {
                    let dataString = String(data: response.data!, encoding: .utf8) ?? ""
                    callback(dataString)
                }

            case let .failure(error):
                print("Request error: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    func LoginUser(email: String, password: String, callback: @escaping (String) -> Void) {
        guard let url = URL(string: BASE_URL + "api/user/login") else {
            print("url is not correct")
            return
        }
        let parameters: [String: String] = [
            "Email": email,
            "Password": password
        ]
        let multipart = MultipartFormData()
        for (key, value) in parameters {
            multipart.append(value.data(using: String.Encoding.utf8)!, withName: key)
        }
        AF.upload(multipartFormData: multipart, to: url, method: .post).responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                do {
                    let user = try JSONDecoder().decode(UserModel.self, from: response.data!)
                    self.nickname = user.name
                    self.email = user.email
                    let photoUrl = user.photo ?? ""
                    
                    
                    
                    callback("") // TODO: add message
                    return
                } catch _ as NSError {
                    let dataString = String(data: response.data!, encoding: .utf8) ?? ""
                    callback(dataString)
                    return
                }

            case let .failure(error):
                print("Request error: \(error.localizedDescription)")
                callback(error.localizedDescription)
                return
            }
        }
    }
    
}



extension UIImageView {
    func load(_ imgURLString: String?) {
        if (imgURLString != ""){
            guard let imageURLString = imgURLString else {
                self.image = nil
                return
            }
            DispatchQueue.global().async { [weak self] in
                let data = try? Data(contentsOf: URL(string: imageURLString)!)
                DispatchQueue.main.async {
                    self?.image = data != nil ? UIImage(data: data!) : nil
                }
            }
        }
    }
}
