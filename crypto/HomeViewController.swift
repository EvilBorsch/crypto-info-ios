//
//  HomeViewController.swift
//  crypto
//
//  Created by adolgavin on 22.11.2020.
//
import UIKit
import Foundation

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var cryptoModels: [CryptoTableViewCellModel] = [
        CryptoTableViewCellModel(imageName: "", price: "18 583$", title: "Bitcoin"),
        CryptoTableViewCellModel(imageName: "", price: "582,63$", title: "Ethereum")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
}

extension HomeViewController:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "crypto", for: indexPath) as? CryptoTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: cryptoModels[indexPath.row])
        
        return cell
    }
    
}
