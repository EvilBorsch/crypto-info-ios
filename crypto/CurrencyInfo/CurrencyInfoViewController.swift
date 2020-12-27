//
//  CurrencyInfoViewController.swift
//  crypto
//
//  Created by Алексей on 28.10.2020.
//

import Kingfisher
import SafariServices
import TinyConstraints
import UIKit
import WebKit

var urls: [Int:URL] = [:]

class CurrencyInfoViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var chartView: UIView!
    
    @IBOutlet weak var minedInfo: UIStackView!
    @IBOutlet weak var currencyImage: UIImageView!
    @IBOutlet weak var Change1hView: UIView!
    @IBOutlet weak var Change24hView: UIView!
    @IBOutlet weak var Change7dView: UIView!
    @IBOutlet weak var Change1hLabel: UILabel!
    @IBOutlet weak var Change24hLabel: UILabel!
    @IBOutlet weak var Change7dLabel: UILabel!
    @IBOutlet weak var CoinInfoLabel: UILabel!
    @IBOutlet weak var CurculatingLabel: UILabel!
    @IBOutlet weak var MinedLabel: UILabel!
    @IBOutlet weak var LastUpdatedLabel: UILabel!
    
    @IBOutlet weak var PlatformView: UIView!
    @IBOutlet weak var PlarformStockLabel: UILabel!
    @IBOutlet weak var BasedOnLabel: UILabel!
    @IBOutlet weak var TokenAddressLabel: UILabel!
    
    @IBOutlet weak var Description: UITextView!
    @IBOutlet weak var DateAdded: UILabel!
    
    @IBOutlet weak var Github: UIImageView!
    @IBOutlet weak var Twitter: UIImageView!
    @IBOutlet weak var Reddit: UIImageView!
    @IBOutlet weak var Website: UIImageView!
    @IBOutlet weak var Doc: UIImageView!
    
    
    @IBOutlet weak var curLabel: UILabel!
    @IBOutlet weak var mLabel: UILabel!
    @IBOutlet weak var luLabel: UILabel!
    @IBOutlet weak var plTokAddrLabel: UILabel!
    @IBOutlet weak var crLabel: UILabel!
    
    
    weak var fiatVc: FiatCollectionViewController!
    weak var chartVc: ChartViewController!
    
    var isSevenDay = true
    var addToFavoriteButton: UIBarButtonItem!
    var theme = 0
    var removeFromFavoriteButton: UIBarButtonItem!
    
    let favKey = "favorites"
    let loadIndicator = UIActivityIndicatorView(style: .large)
    
    var alert:UIAlertController!
    var graphView: ChartViewController?
    
    var model: CurrencyModel!
    var currName: String!

    let refresh = UIRefreshControl()
    
    let themeKey = "theme"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(chartTapped(tapGestureRecognizer:)))
        chartView.addGestureRecognizer(tap)
        
        addToFavoriteButton = UIBarButtonItem(
                image: UIImage(systemName: "star")!.withRenderingMode(.alwaysTemplate),
                style: .plain, target: self, action: #selector(handleAddClick))
        
        removeFromFavoriteButton = UIBarButtonItem(
        image: UIImage(systemName: "star.fill")!.withRenderingMode(.alwaysTemplate),
        style: .plain, target: self, action: #selector(handleRemoveClick))
        
        self.scrollView.isHidden = true
        self.title = currName
        self.alert = initAlert()

        view.addSubview(loadIndicator)
        self.loadIndicator.edgesToSuperview()

        self.loadIndicator.startAnimating()
        
        self.scrollView.alwaysBounceVertical = true
        
        self.refresh.addTarget(self, action: #selector(updateData), for: UIControl.Event.valueChanged)
        self.scrollView.addSubview(refresh)

        
        Change7dView.layer.cornerRadius = 10
        Change7dView.layer.masksToBounds = true
        
        Change1hView.layer.cornerRadius = 10
        Change1hView.layer.masksToBounds = true
        
        Change24hView.layer.cornerRadius = 10
        Change24hView.layer.masksToBounds = true
        
        Github.image = Github.image?.withRenderingMode(.alwaysTemplate)
        Twitter.image = Twitter.image?.withRenderingMode(.alwaysTemplate)
        Reddit.image = Reddit.image?.withRenderingMode(.alwaysTemplate)
        Website.image = Website.image?.withRenderingMode(.alwaysTemplate)
        Doc.image = Doc.image?.withRenderingMode(.alwaysTemplate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTheme()
        self.loadInfo()
    }
    
    func setTheme() {
        theme = UserDefaults.standard.integer(forKey: themeKey)
        curLabel.textColor = themeColor[theme]
        mLabel.textColor = themeColor[theme]
        luLabel.textColor = themeColor[theme]
        
        BasedOnLabel.textColor = themeColor[theme]
        plTokAddrLabel.textColor = themeColor[theme]
        crLabel.textColor = themeColor[theme]
        
        navigationController?.navigationBar.tintColor = themeColor[theme]

    }
    
    @objc func handleAddClick() {
        
        var favStocks = UserDefaults.standard.stringArray(forKey: favKey) ?? []
        favStocks.append(self.model.symbol)
        UserDefaults.standard.set(favStocks,forKey: favKey)
        navigationItem.rightBarButtonItem = removeFromFavoriteButton
    }
    
    @objc func handleRemoveClick() {

        var favStocks = UserDefaults.standard.stringArray(forKey: favKey) ?? []
        favStocks = favStocks.filter({ (stock) -> Bool in
            return stock != self.model.symbol
        })
        UserDefaults.standard.set(favStocks,forKey: favKey)
        navigationItem.rightBarButtonItem = addToFavoriteButton
    }
    
    @objc
    func updateData() {
        self.refresh.endRefreshing()
        self.loadInfo()
    }

    func setPercentChange(view: UIView, label: UILabel, value: Double) {
        if value > 0 {
            label.text = String(format: "+ %.3f",  value) + " %"
            view.backgroundColor = .systemGreen
        } else {
            label.text = String(format: "%.3f", value) + " %"
            view.backgroundColor = .systemRed
        }
    }
    
    func configureUrl(for imageView:UIImageView, tag: Int) {
        guard let _ = urls[tag] else {
            imageView.isHidden = true
            return
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(linkTapped(tapGestureRecognizer:)))
        
        imageView.tintColor = themeColor[theme]
        imageView.tag = tag
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        
    }
    
    
    @objc func linkTapped(tapGestureRecognizer: UITapGestureRecognizer){

        let tappedView = tapGestureRecognizer.view as! UIImageView
        
        let sfVc = SFSafariViewController(url: urls[tappedView.tag]!)
        sfVc.preferredControlTintColor = themeColor[theme]
        sfVc.modalPresentationStyle = .pageSheet
        
        present(sfVc, animated: true, completion: nil)
    }
    
    @objc func chartTapped(tapGestureRecognizer: UITapGestureRecognizer){
        isSevenDay = !isSevenDay
        updateChart()
    }
    
 
    
    func updateView(){
        currencyImage.kf.indicatorType = .activity
        currencyImage.kf.setImage(with: self.model.bigLogoUrl)
        CoinInfoLabel.text = model.symbol + " " + model.category
        
        setPercentChange(view: Change1hView, label: Change1hLabel, value: model.currCryptoInfo.percentChange1h)
        setPercentChange(view: Change24hView, label: Change24hLabel, value: model.currCryptoInfo.percentChange24h)
        setPercentChange(view: Change7dView, label: Change7dLabel, value: model.currCryptoInfo.percentChange7d)
        
        CurculatingLabel.text = String(format: "%.1f", model.currCryptoInfo.circulatingSupply)
        MinedLabel.text = String(format: "%.1f", model.currCryptoInfo.totalSupply)
        
        if model.platform.id != 0 {
            PlarformStockLabel.text = model.platform.symbol
            BasedOnLabel.text = "Based on \(model.platform.name)"
            TokenAddressLabel.text = "\(model.platform.tokenAddress)"
        } else {
            PlatformView.isHidden = true
        }
        
        urls[0] = model.urls.sourceURL
        urls[1] = model.urls.twitterURL
        urls[2] = model.urls.redditURL
        urls[3] = model.urls.websiteURL
        urls[4] = model.urls.docURL
        
        configureUrl(for: Github, tag: 0)
        configureUrl(for: Twitter, tag: 1)
        configureUrl(for: Reddit, tag: 2)
        configureUrl(for: Website, tag: 3)
        configureUrl(for: Doc, tag: 4)
        
        Description.text = model.description
        
        var date = getDateFromString(dateString: model.dateAdded)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        DateAdded.text = formatter.string(from: date!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        date = getDateFromString(dateString: model.currCryptoInfo.lastUpdated)
        LastUpdatedLabel.text = "\(dateFormatter.string(from: date!)) at \(timeFormatter.string(from: date!))"
        
    }
    
    func updateChart() {
        let dateToday = Date()
        
        let date:Date
        if (self.isSevenDay) {
            date = Calendar.current.date(byAdding: .day,value: -7, to: dateToday)!
        } else {
            date = Calendar.current.date(byAdding: .month,value: -1, to: dateToday)!
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        self.chartVc.startDate = formatter.string(from: date)
    }
    
    func loadInfo() {
        let network = NetworkManager.shared
        network.GetCryptoByName(name: currName, completion: { [weak self] res in
            guard let self = self else {
                return
            }
            switch res {
            case .success(let info):
                self.model = info
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute:{
                    self.updateView()
                    self.loadIndicator.stopAnimating()
                    self.scrollView.isHidden = false
                    self.fiatVc.fiats = self.model.currCryptoInfo.costInFiats.reversed()
                    self.chartVc.symbol = self.model.symbol.lowercased()
                    self.updateChart()
                    
                    let favStocks = UserDefaults.standard.stringArray(forKey: self.favKey) ?? []
                    
                    if favStocks.contains(self.model.symbol) {
                        self.navigationItem.rightBarButtonItem = self.removeFromFavoriteButton
                    } else {
                        self.navigationItem.rightBarButtonItem = self.addToFavoriteButton
                    }
                    
                   
                })
            case .failure(let error):
                self.alert.title = "Network error"
                self.alert.message = "Something went wrong during getting information\nError: \(error)"
                
                
                DispatchQueue.main.async {
                    self.present(self.alert, animated: true, completion: nil)
                }
            }
            
        })
    }
    
    func initAlert() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: {_ in
            self.dismiss(animated: true) {
                self.loadInfo()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        return alert
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FiatSegue" {
            fiatVc = (segue.destination as! FiatCollectionViewController)
        }
        
        if segue.identifier == "ChartSegue" {
            chartVc = (segue.destination as! ChartViewController)
        }
    }
}

