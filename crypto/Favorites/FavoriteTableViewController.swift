//
//  FavoriteTableViewController.swift
//  crypto
//
//  Created by Алексей on 22.12.2020.
//

import TinyConstraints
import Foundation
import UIKit

class FavoriteTableViewController: UITableViewController {

    let key = "favorites"
    var cryptoInfo:[HomeCellModel] = []
    var cryptoInfoFiltered:[HomeCellModel] = []
    
    let search = UISearchController(searchResultsController: nil)
    let loadIndicator = UIActivityIndicatorView(style: .large)
    let refresh = UIRefreshControl()
    
    func filterCells(by name: String) {
        cryptoInfoFiltered.removeAll()
        
        cryptoInfoFiltered = cryptoInfo.filter({ (model) -> Bool in
            return model.name.lowercased().contains(name.lowercased())
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
        
        UserDefaults.standard.set(["BTC", "ETH"], forKey: key)
        
        tableView.refreshControl = self.refresh
        refresh.addTarget(self, action: #selector(refreshUpd), for: .valueChanged)
        
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = search
        
        tableView.backgroundView = getInfoLabel()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "CryptoCell", bundle: nil), forCellReuseIdentifier: "CryptoCell")
        
        loadData()
    }
    
    @objc
    func refreshUpd() {
        refresh.endRefreshing()
        loadData()
    }
    
    func getInfoLabel() -> UILabel {
        let info = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        info.text = "No favorites"
        info.textAlignment = .center
        info.font = UIFont.systemFont(ofSize: 40.0, weight: .medium)
        
        return info
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch() {
            return cryptoInfoFiltered.count
        } else {
            return cryptoInfo.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "CurrencyInfo", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CurrencyInfo") as! CurrencyInfoViewController
        if isSearch() {
            vc.currName = cryptoInfoFiltered[indexPath.row].name
        } else {
            vc.currName = cryptoInfo[indexPath.row].name
        }
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell") as? HomeCell else {
            return UITableViewCell()
        }
        
        if isSearch() {
            cell.configure(with: cryptoInfoFiltered[indexPath.row])
        } else {
            cell.configure(with: cryptoInfo[indexPath.row])
        }
        
        return cell
    }
    
    func loadData() {
        let favoriteStocks = UserDefaults.standard.stringArray(forKey: key) ?? []
        if favoriteStocks.count != 0 {
            loadIndicator.startAnimating()
            tableView.backgroundView = loadIndicator
            
            let network = NetworkManager.shared
            network.GetCryptoListByStock(stocks: favoriteStocks,completion: { [weak self] res in
                switch res {
                case .success(let info):
                    self?.cryptoInfo = info
                    DispatchQueue.main.async {
                        self?.loadIndicator.stopAnimating()
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    debugPrint(error)
                }
                
            })
        }
    }
}

extension FavoriteTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if !SearchBarIsEmpty() {
            filterCells(by: searchController.searchBar.text!)
        }
        tableView.reloadData()
    }
    
    func SearchBarIsEmpty() -> Bool {
        return search.searchBar.text?.isEmpty ?? true
    }
    
    func isSearch() -> Bool {
        return search.isActive && !SearchBarIsEmpty()
    }
}
