//
//  CurrencyInfoViewController.swift
//  crypto
//
//  Created by Алексей on 28.10.2020.
//

import TinyConstraints
import UIKit

class CurrencyInfoViewController: UIViewController {
    
    let loadIndicator = UIActivityIndicatorView(style: .large)
    
    var alert:UIAlertController!
    
    var model: CurrencyModel?
    var currName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = currName
        self.alert = initAlert()
                
        view.addSubview(loadIndicator)
        self.loadIndicator.edgesToSuperview()

        self.loadIndicator.startAnimating()
        self.loadInfo()

    }

    func loadInfo() {
        let network = NetworkManager.shared
        network.GetCryptoByName(name: currName, completion: { [weak self] res in
            guard let self = self else {
                return
            }
            switch res {
            case .success(let info):
                self.model = info
                DispatchQueue.main.async{
                    self.loadIndicator.stopAnimating()
                    
                }
            case .failure(let error):
                self.alert.title = "Network error"
                self.alert.message = "Something went wrong during getting information\nError: \(error)"
                
                
                DispatchQueue.main.async {
                    self.present(self.alert, animated: true, completion: nil)
                }
            }
            
        })
    }
    
    func initAlert() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: {_ in
            self.dismiss(animated: true) {
                self.loadInfo()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        return alert
    }
}


