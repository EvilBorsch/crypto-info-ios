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
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    tableView.dataSource = self
    tableView.delegate = self
    }
}

extension HomeViewController:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "crypto", for: indexPath)
        return cell
    }
    
}
