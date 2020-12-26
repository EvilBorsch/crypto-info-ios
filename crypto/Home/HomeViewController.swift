//
//  HomeViewController.swift
//  crypto
//
//  Created by adolgavin on 22.11.2020.
//
import UIKit
import Foundation

class HomeViewController: UIViewController {
    
    let favKey = "favorites"
    
    @IBOutlet weak var tableView: UITableView!
    
    let search = UISearchController(searchResultsController: nil)
    let refresh = UIRefreshControl()
    
    var homeCellModels: [HomeCellModel] = []
    var homeCellModelsFiltered: [HomeCellModel] = []
    
    var settingsButton:UIBarButtonItem!
    
    func filterCells(by name: String) {
        homeCellModelsFiltered.removeAll()
        
        homeCellModelsFiltered = homeCellModels.filter({ (model) -> Bool in
            return model.name.lowercased().contains(name.lowercased())
        })
    }
    
    var theme = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Cryptoes"
        
        
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = search
        
        tableView.refreshControl = self.refresh
        refresh.addTarget(self, action: #selector(refreshUpd(sender:)), for: .valueChanged)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "CryptoCell", bundle: nil), forCellReuseIdentifier: "CryptoCell")
        
        theme = UserDefaults.standard.integer(forKey: "theme")
        
        navigationController?.navigationBar.tintColor = themeColor[theme]
        tabBarController?.tabBar.tintColor = themeColor[theme]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        theme = UserDefaults.standard.integer(forKey: "theme")
        
        tableView.reloadData()
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        loadInfo()
    }
    
    func loadInfo() {
        let network = NetworkManager.shared
        network.GetCryptoListAll(completion: { [weak self] res in
            switch res {
            case .success(let info):
                self?.homeCellModels = info
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                debugPrint(error)
            }
            
        })
    }
    
    @objc
    private func refreshUpd(sender: UIRefreshControl) {
        loadInfo()
        sender.endRefreshing()
    }
}

extension HomeViewController:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch() {
            return homeCellModelsFiltered.count
        } else {
            return homeCellModels.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "CurrencyInfo", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CurrencyInfo") as! CurrencyInfoViewController
        vc.currName = getModel(at: indexPath.row).name
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell") as? HomeCell else {
            return UITableViewCell()
        }
        cell.symbol.textColor = themeColor[theme]
        cell.fiatType = UserDefaults.standard.integer(forKey: "fiat")
        cell.configure(with: getModel(at: indexPath.row))

        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func getModel(at index: Int) -> HomeCellModel {
        if self.isSearch() {
            return self.homeCellModelsFiltered[index]
        } else {
            return self.homeCellModels[index]
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var favoriteStocks = UserDefaults.standard.stringArray(forKey: favKey) ?? []
        let currSymbol = getModel(at: indexPath.row).symbol
        
        let symbolConfig = UIImage.SymbolConfiguration(weight: .bold)
        
        if favoriteStocks.contains(currSymbol) {
            let favoriteDelete = UIContextualAction.init(style: .normal, title: "Remove from favorites", handler:{ (action, view, success) in
                favoriteStocks = favoriteStocks.filter({(symbol) -> Bool in return symbol != currSymbol})
                UserDefaults.standard.set(favoriteStocks, forKey: self.favKey)
                tableView.reloadData()
            })
            favoriteDelete.image = UIImage(systemName: "star.slash.fill", withConfiguration: symbolConfig)
            favoriteDelete.backgroundColor = .systemRed
            return UISwipeActionsConfiguration(actions: [favoriteDelete])
        } else {
            let favoriteAdd = UIContextualAction.init(style: .normal, title: "Add to favorites", handler:{ (action, view, success) in
                success(true)
                favoriteStocks.append(currSymbol)
                UserDefaults.standard.set(favoriteStocks, forKey: self.favKey)
                tableView.reloadData()
            })
            favoriteAdd.image = UIImage(systemName: "star.fill", withConfiguration: symbolConfig)
            favoriteAdd.backgroundColor = themeColor[theme]
            return UISwipeActionsConfiguration(actions: [favoriteAdd])
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let buy = UIContextualAction.init(style: .normal, title: "Buy", handler:{ (action, view, success) in
            
        })
        
        let symbolConfig = UIImage.SymbolConfiguration(weight: .bold)
        
        buy.image = UIImage(systemName: "cart.fill.badge.plus", withConfiguration: symbolConfig)
        buy.backgroundColor = themeColor[theme]
        
        let sell = UIContextualAction.init(style: .normal, title: "Sell", handler:{ (action, view, success) in
            
        })
        
        sell.image = UIImage(systemName: "cart.fill.badge.minus", withConfiguration: symbolConfig)
        sell.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [buy, sell])
    }
}

extension HomeViewController: UISearchResultsUpdating {
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
