

import UIKit




func showPage(presenter:UIViewController,viewId: String,storyBoardName: String="Main"){
    let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: viewId)
    presenter.present(vc, animated: true)
}
