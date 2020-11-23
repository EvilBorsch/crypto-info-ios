//
//  CryptoTableViewCell.swift
//  crypto
//
//  Created by adolgavin on 23.11.2020.
//

import UIKit



class CryptoTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }

}
