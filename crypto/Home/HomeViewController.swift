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
        let vc = storyboard.instantiateViewController(withIdentifier: "CellBaseShow") as! CurrencyBaseViewController
        if isSearch() {
            vc.name = homeCellModelsFiltered[indexPath.row].name
        } else {
            vc.name = homeCellModels[indexPath.row].name
        }
        
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
        let swipe = UIContextualAction.init(style: .normal, title: "Добавить в избранное", handler:{ (action, view, success) in
            
        })
        
        swipe.image = UIImage(systemName: "star.fill")
        swipe.backgroundColor = .systemGreen
        
        return UISwipeActionsConfiguration(actions: [swipe])
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
