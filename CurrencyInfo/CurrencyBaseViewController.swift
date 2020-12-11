//
//  CurrencyBaseViewController.swift
//  crypto
//
//  Created by Алексей on 23.11.2020.
//

import UIKit


class CurrencyBaseViewController: UIViewController {

    @IBOutlet weak var CurrencyName: UILabel!
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    
    var name: String = "Bitcoin"
    let NetworkManager = CurrencyNetworkManager.shared
    var model: CurrencyModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ErrorLabel.isHidden = true
        self.ErrorLabel.layer.cornerRadius = 15
        self.ErrorLabel.layer.masksToBounds = true
        self.CurrencyName.text = self.name
        self.loadIndicator.startAnimating()
        
        NetworkManager.GetCryptoByName(name: self.name) {
            [weak self](model, error) in
            guard let self = self else {
                return
            }
            guard let modelObj = model else {
                self.loadIndicator.stopAnimating()
                self.loadIndicator.isHidden = true
                self.ErrorLabel.isHidden = false
            
                if let errInfo = error {
                    self.ErrorLabel.text = errInfo
                } else {
                    self.ErrorLabel.text = "Internal error"
                }
                
                return
            }
            DispatchQueue.main.async {
                self.model = modelObj
                
                self.loadIndicator.stopAnimating()
                
                let storyboard = UIStoryboard(name: "CurrencyInfo", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CurrencyInfo") as! CurrencyInfoViewController
                self.definesPresentationContext = true
                vc.model = modelObj
                vc.modalPresentationCapturesStatusBarAppearance = true
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: false)
            }
        }
        
        // Do any additional setup after loading the view.
    }




}
