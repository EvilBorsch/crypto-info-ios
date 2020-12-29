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
    var homeCellModelsCoins:[HomeCellModel] = []
    var homeCellModelsTokens:[HomeCellModel] = []
    
    var settingsButton:UIBarButtonItem!
    
    func filterCells(by name: String) {
        homeCellModelsFiltered.removeAll()
        
        if segment.selectedSegmentIndex == 1 {
            homeCellModelsFiltered = homeCellModelsCoins.filter({ (model) -> Bool in
                return model.name.lowercased().contains(name.lowercased())
            })
        }
        else if segment.selectedSegmentIndex == 2 {
            homeCellModelsFiltered = homeCellModelsTokens.filter({ (model) -> Bool in
                return model.name.lowercased().contains(name.lowercased())
            })
        } else {
            homeCellModelsFiltered = homeCellModels.filter({ (model) -> Bool in
                return model.name.lowercased().contains(name.lowercased())
            })
        }
        
       
    }
    
    
    var theme = 0
    var segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Cryptoes"
        
        if (UserDefaults.standard.object(forKey: "fiat") == nil) {
            UserDefaults.standard.set(5, forKey: "fiat")
        }
        
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = search
        
        
        segment = UISegmentedControl(items: ["All", "Coins", "Tokens"])
        segment.sizeToFit()
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentChange(sender:)), for: .valueChanged)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
        self.navigationItem.titleView = segment
        
        tableView.refreshControl = self.refresh
        refresh.addTarget(self, action: #selector(refreshUpd(sender:)), for: .valueChanged)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "CryptoCell", bundle: nil), forCellReuseIdentifier: "CryptoCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        theme = UserDefaults.standard.integer(forKey: "theme")
        
        navigationController?.navigationBar.tintColor = themeColor[theme]
        tabBarController?.tabBar.tintColor = themeColor[theme]
        segment.selectedSegmentTintColor = themeColor[theme]
        
        tableView.reloadData()
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        loadInfo()
    }
    
    @objc
    func segmentChange(sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
    func loadInfo() {
        let network = NetworkManager.shared
        network.GetCryptoListAll(completion: { [weak self] res in
            switch res {
            case .success(let info):
                self?.homeCellModels = info
                self?.homeCellModelsCoins = info.filter({ (model) -> Bool in
                    return model.category == "coin"
                })
                self?.homeCellModelsTokens = info.filter({ (model) -> Bool in
                    return model.category == "token"
                })
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
            if segment.selectedSegmentIndex == 1 {
                return homeCellModelsCoins.count
            }
            if segment.selectedSegmentIndex == 2 {
                return homeCellModelsTokens.count
            } else {
                return homeCellModels.count
            }
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
            if segment.selectedSegmentIndex == 1 {
                return homeCellModelsCoins[index]
            }
            if segment.selectedSegmentIndex == 2 {
                return homeCellModelsTokens[index]
            }
            return self.homeCellModels[index]
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var favoriteStocks = UserDefaults.standard.stringArray(forKey: favKey) ?? []
        let currSymbol = getModel(at: indexPath.row).symbol
        
        let symbolConfig = UIImage.SymbolConfiguration(weight: .bold)
        
        if favoriteStocks.contains(currSymbol) {
            let favoriteDelete = UIContextualAction.init(style: .normal, title: "Remove from favorites", handler:{ (action, view, success) in
                success(true)
                favoriteStocks = favoriteStocks.filter({(symbol) -> Bool in return symbol != currSymbol})
                UserDefaults.standard.set(favoriteStocks, forKey: self.favKey)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    tableView.reloadData()
                })
            })
            favoriteDelete.image = UIImage(systemName: "star.slash.fill", withConfiguration: symbolConfig)
            favoriteDelete.backgroundColor = .systemRed
            return UISwipeActionsConfiguration(actions: [favoriteDelete])
        } else {
            let favoriteAdd = UIContextualAction.init(style: .normal, title: "Add to favorites", handler:{ (action, view, success) in
                success(true)
                favoriteStocks.append(currSymbol)
                UserDefaults.standard.set(favoriteStocks, forKey: self.favKey)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    tableView.reloadData()
                })
                
            })
            favoriteAdd.image = UIImage(systemName: "star.fill", withConfiguration: symbolConfig)
            favoriteAdd.backgroundColor = themeColor[theme]
            return UISwipeActionsConfiguration(actions: [favoriteAdd])
        }
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
