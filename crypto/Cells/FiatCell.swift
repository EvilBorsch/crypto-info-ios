//
//  FiatCollectionViewCell.swift
//  crypto
//
//  Created by Алексей on 19.12.2020.
//

import UIKit

class FiatCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var Cost: UILabel!
    @IBOutlet weak var Symbol: UILabel!
    @IBOutlet weak var CurrName: UILabel!
    @IBOutlet weak var LastUpd: UILabel!
    @IBOutlet weak var CurrShowLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    var theme = 0
    var volume: String!
    var cost: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.changeShowing))
        self.addGestureRecognizer(tap)
    }
    
    @objc
    func changeShowing() {
        if self.CurrShowLabel.text == "Cost" {
            self.Cost.text = volume
            self.CurrShowLabel.text = "Volume 24 hours"
        } else {
            self.Cost.text = cost
            self.CurrShowLabel.text = "Cost"
        }
    }
    
    func configure(with fiat: FiatModel) {
        cost = String(format: "%.2f \(fiat.sign)", fiat.price)
        volume = String(format: "%.2f \(fiat.sign)", fiat.volume24h)
        
        Cost.text = cost
        Symbol.text = fiat.symbol
        CurrName.text = fiat.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let date = getDateFromString(dateString: fiat.lastUpdated)
        LastUpd.text = "\(dateFormatter.string(from: date!)) at \(timeFormatter.string(from: date!))"
    }

}
