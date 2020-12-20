//
//  CurrencyInfoViewController.swift
//  crypto
//
//  Created by Алексей on 28.10.2020.
//

import Kingfisher
import TinyConstraints
import UIKit

class CurrencyInfoViewController: UIViewController {
    @IBOutlet weak var currencyImage: UIImageView!
    @IBOutlet weak var Change1hView: UIView!
    @IBOutlet weak var Change24hView: UIView!
    @IBOutlet weak var Change7dView: UIView!
    @IBOutlet weak var Change1hLabel: UILabel!
    @IBOutlet weak var Change24hLabel: UILabel!
    @IBOutlet weak var Change7dLabel: UILabel!
    @IBOutlet weak var CoinInfoLabel: UILabel!
    @IBOutlet weak var CurculatingLabel: UILabel!
    @IBOutlet weak var MinedLabel: UILabel!
    @IBOutlet weak var LastUpdatedLabel: UILabel!
    
    @IBOutlet weak var PlatformView: UIView!
    @IBOutlet weak var PlarformStockLabel: UILabel!
    @IBOutlet weak var BasedOnLabel: UILabel!
    @IBOutlet weak var TokenAddressLabel: UILabel!
    
    weak var fiatVc: FiatCollectionViewController!
    
    let loadIndicator = UIActivityIndicatorView(style: .large)
    
    var alert:UIAlertController!
    var graphView: ChartViewController?
    
    var model: CurrencyModel!
    var currName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = currName
        self.alert = initAlert()

        view.addSubview(loadIndicator)
        self.loadIndicator.edgesToSuperview()

        self.loadIndicator.startAnimating()
        
        Change7dView.layer.cornerRadius = 10
        Change7dView.layer.masksToBounds = true
        
        Change1hView.layer.cornerRadius = 10
        Change1hView.layer.masksToBounds = true
        
        Change24hView.layer.cornerRadius = 10
        Change24hView.layer.masksToBounds = true
        
         
        
        self.loadInfo()
    

    }

    func setPercentChange(view: UIView, label: UILabel, value: Double) {
        if value > 0 {
            label.text = String(format: "+ %.3f",  value) + " %"
            view.backgroundColor = .systemGreen
        } else {
            label.text = String(format: "%.3f", value) + " %"
            view.backgroundColor = .systemRed
        }
    }
    
    func updateView(){
        currencyImage.kf.indicatorType = .activity
        currencyImage.kf.setImage(with: self.model.bigLogoUrl)
        CoinInfoLabel.text = model.symbol + " " + model.category
        
        setPercentChange(view: Change1hView, label: Change1hLabel, value: model.currCryptoInfo.percentChange1h)
        setPercentChange(view: Change24hView, label: Change24hLabel, value: model.currCryptoInfo.percentChange24h)
        setPercentChange(view: Change7dView, label: Change7dLabel, value: model.currCryptoInfo.percentChange7d)
        
        CurculatingLabel.text = String(format: "%.1f", model.currCryptoInfo.circulatingSupply)
        MinedLabel.text = String(format: "%.1f", model.currCryptoInfo.totalSupply)
        
        if model.platform.id != 0 {
            PlarformStockLabel.text = model.platform.symbol
            BasedOnLabel.text = "Based on \(model.platform.name)"
            TokenAddressLabel.text = "\(model.platform.tokenAddress)"
        } else {
            PlatformView.isHidden = true
        }
        
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute:{
                    self.updateView()
                    self.loadIndicator.stopAnimating()
                    self.graphView?.view.isHidden = true
                    self.fiatVc.fiats = self.model.currCryptoInfo.costInFiats.reversed()
                })
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FiatSegue" {
            fiatVc = segue.destination as! FiatCollectionViewController
        }
    }
}




