import Alamofire
import UIKit

func showPage(presenter: UIViewController, viewId: String, storyBoardName: String = "Main") {
    let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: viewId)
    presenter.present(vc, animated: true)
}

func getImageFromUrl(url: String) -> UIImage? {
    var img = UIImage()
    AF.request(url, method: .get).response { response in
        switch response.result {
        case let .success(responseData):
            print("receive image")
            img = UIImage(data: responseData!, scale: 1)!
        case let .failure(error):
            print("error--->", error)
        }
    }
    return img
}
