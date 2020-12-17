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
    
    let search = UISearchController(searchResultsController: nil)
    let refresh = UIRefreshControl()
    
    var homeCellModels: [HomeCellModel] = []
    var homeCellModelsFiltered: [HomeCellModel] = []
    
    func filterCells(by name: String) {
        homeCellModelsFiltered.removeAll()
        
        homeCellModelsFiltered = homeCellModels.filter({ (model) -> Bool in
            return model.name.lowercased().contains(name.lowercased())
        })
    }
    
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
        
        loadInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationItem.largeTitleDisplayMode = .always
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
        if isSearch() {
            vc.currName = homeCellModelsFiltered[indexPath.row].name
        } else {
            vc.currName = homeCellModels[indexPath.row].name
        }
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell") as? HomeCell else {
            return UITableViewCell()
        }
        
        if isSearch() {
            cell.configure(with: homeCellModelsFiltered[indexPath.row])
        } else {
            cell.configure(with: homeCellModels[indexPath.row])
        }
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction.init(style: .normal, title: "Add to favorites", handler:{ (action, view, success) in
            
        })
        
        let symbolConfig = UIImage.SymbolConfiguration(weight: .bold)
        
        favorite.image = UIImage(systemName: "star.fill", withConfiguration: symbolConfig)
        favorite.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let buy = UIContextualAction.init(style: .normal, title: "Buy", handler:{ (action, view, success) in
            
        })
        
        let symbolConfig = UIImage.SymbolConfiguration(weight: .bold)
        
        buy.image = UIImage(systemName: "cart.fill.badge.plus", withConfiguration: symbolConfig)
        buy.backgroundColor = .systemGreen
        
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
