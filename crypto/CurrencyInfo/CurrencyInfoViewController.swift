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
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeStackView.layer.cornerRadius = 15
        CostStackView.layer.cornerRadius = 15
        Change.layer.cornerRadius = 10
        Change.layer.masksToBounds = true
        let cur = getCurrByName(name: "Bitcoin")
        CurrencyName.text = cur.currencyName
        StockName.text = cur.stockName
        InfoTextView.text = cur.description
        Cost.text = String(cur.cost)
        CostCurr.text = cur.convertionCurrencyName
        Change.text = String(cur.changeValueInPercents) + "%"
        if cur.didGrow {
            Change.backgroundColor = UIColor.systemGreen
        }
        
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
