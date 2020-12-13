//
//  CurrencyInfoViewController.swift
//  crypto
//
//  Created by Алексей on 28.10.2020.
//

import UIKit

class CurrencyInfoViewController: UIViewController {
    
    @IBOutlet weak var ChangeStackView: UIStackView!
    @IBOutlet weak var Change: UILabel!
    @IBOutlet weak var CostStackView: UIStackView!
    @IBOutlet weak var InfoTextView: UITextView!
    @IBOutlet weak var CurrencyName: UILabel!
    @IBOutlet weak var StockName: UILabel!
    @IBOutlet weak var Cost: UILabel!
    @IBOutlet weak var CostCurr: UILabel!

    var model: CurrencyModel?
    
    
    func updateModelView(){
        CurrencyName.text = self.model?.name
        StockName.text = self.model?.symbol
        InfoTextView.text = self.model?.description
        Cost.text = String(format: "%.2f",self.model?.currCryptoInfo.costInFiats[0].price ?? 0)
        CostCurr.text = self.model?.currCryptoInfo.costInFiats[0].symbol
        Change.text = String(format: "%.2f",self.model?.currCryptoInfo.percentChange1h ?? 0) + "%"
        if self.model?.currCryptoInfo.percentChange1h ?? 0 > 0 {
            Change.backgroundColor = UIColor.systemGreen
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeStackView.layer.cornerRadius = 15
        CostStackView.layer.cornerRadius = 15
        Change.layer.cornerRadius = 10
        Change.layer.masksToBounds = true
        
        self.updateModelView()
    
    
    }

    
    

}
