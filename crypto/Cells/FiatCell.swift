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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with fiat: FiatModel) {
        Cost.text = String(format: "%.2f \(fiat.sign)", fiat.price)
        Symbol.text = fiat.symbol
        CurrName.text = fiat.name
    }

}
