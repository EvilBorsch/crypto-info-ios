//
//  CryptoTableViewCell.swift
//  crypto
//
//  Created by adolgavin on 23.11.2020.
//

import UIKit

struct CryptoTableViewCellModel{
    let imageName: String
    let price: String
    let title: String
}

class CryptoTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: CryptoTableViewCellModel) {
        iconImageView.image = UIImage(named: model.imageName)
        titleLabel.text = model.title
        priceLabel.text = model.price
    }

}
