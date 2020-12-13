//
//  HomeCell.swift
//  crypto
//
//  Created by Алексей on 13.12.2020.
//

import UIKit
import Kingfisher

enum Fiats: Int {
    case CNY = 0
    case EUR = 1
    case GBP = 2
    case RUB = 3
    case UAH = 4
    case USD = 5
}

class HomeCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var change: UILabel!
    @IBOutlet weak var changeView: UIView!
    
    
    var fiatType = Fiats.RUB
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        changeView.layer.cornerRadius = 10
        changeView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: HomeCellModel) {
        icon.kf.indicatorType = .activity
        icon.kf.setImage(with: model.logoURL)
        name.text = model.name
        cost.text = String(format: "%.2f \(model.cost[fiatType.rawValue].sign)", model.cost[fiatType.rawValue].price)
        symbol.text = model.symbol
        if model.percentChange1h > 0 {
            change.text = String(format: "+ %.3f",  model.percentChange1h) + " %"
            changeView.backgroundColor = .systemGreen
        } else {
            change.text = String(format: "%.3f",  model.percentChange1h) + " %"
            changeView.backgroundColor = .systemRed
        }
    }
    
}
