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

    private var model: CurrencyModel = CurrencyModel()
    
    func updateModelView(){
        CurrencyName.text = self.model.currencyName
        StockName.text = self.model.stockName
        InfoTextView.text = self.model.description
        Cost.text = String(self.model.cost)
        CostCurr.text = self.model.convertionCurrencyName
        Change.text = String(self.model.changeValueInPercents) + "%"
        if self.model.didGrow {
            Change.backgroundColor = UIColor.systemGreen
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let NetworkManager = CurrencyNetworkManager.shared
        
        ChangeStackView.layer.cornerRadius = 15
        CostStackView.layer.cornerRadius = 15
        Change.layer.cornerRadius = 10
        Change.layer.masksToBounds = true
        
        NetworkManager.GetCryptoByName(name: "Bitcoin") {
            [weak self](model) in
            self?.model = model!
            DispatchQueue.main.async {
                self?.updateModelView()
            }
        }
        self.updateModelView()
    }
    
}
