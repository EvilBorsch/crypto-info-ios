//
//  ChartViewController.swift
//  crypto
//
//  Created by Alexandr Dolgavin on 13.12.2020.
//

import UIKit

import Charts
import TinyConstraints
import Alamofire


struct priceData: Codable {
    let open: Double
    let date: String
}

struct Coins: Codable {
    let baseCurrency: String
    let priceData: [priceData]
    let quoteCurrency: String
}



let token = "6f2a566c0934c31be8a2b584d8270ae100bd8721"
let frequency = "1day"

var theme = 0

class ChartViewController: UIViewController {
    
    var symbol:String? {
        didSet {
            self.setData(symb: symbol ?? "")
        }
    }
    
    var startDate:String? {
        didSet {
            if symbol != nil {
                self.setData(symb: symbol!)
            }
        }
    } // related to variable "start"
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = themeColor[theme]
        
        chartView.addSubview(loadIndicator)
        self.loadIndicator.edgesToSuperview()
        self.loadIndicator.startAnimating()
        
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .outsideChart
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        chartView.xAxis.setLabelCount(6, force: false)
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.axisLineColor = .white
        
        chartView.noDataText = ""
                
        return chartView
    }()

    let loadIndicator = UIActivityIndicatorView(style: .medium)
    let infoLabel = UILabel()
    
    override func viewDidLoad() {
        theme = UserDefaults.standard.integer(forKey: "theme")
        
        lineChartView.backgroundColor = themeColor[theme]
        
        view.addSubview(lineChartView)
        infoLabel.textColor = .white
        view.addSubview(infoLabel)
        infoLabel.edgesToSuperview()
        infoLabel.textAlignment = .center
        infoLabel.isHidden = true
        infoLabel.text = "Charts for this crypto is unavaliable"
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
//        lineChartView.centerInSuperview()
//        lineChartView.width(to: view)
        lineChartView.edgesToSuperview()
//        lineChartView.heightToWidth(of: view)
        
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        theme = UserDefaults.standard.integer(forKey: "theme")
        let chartView = view.subviews.filter{$0 is LineChartView}
        chartView[0].backgroundColor = themeColor[theme]
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData(symb: String){
        var xyPairs: [(day: Int, price: Double)] = []

        self.getXYLastWeek(symbol: symb,completion: {result in
            switch result {
            case .success(let coins):
                self.loadIndicator.stopAnimating()
                if (coins.count == 0) {
                    self.infoLabel.isHidden = false
                    return
                }
                var dayOfMonth = 1

                xyPairs.removeAll()
                self.yValues.removeAll()
                
                for data in coins[0].priceData {
                    xyPairs.append((day: dayOfMonth, price: data.open))
                    dayOfMonth += 1
                }

                for xyPair in xyPairs {
                    self.yValues.append(ChartDataEntry(x:Double(xyPair.day) , y:xyPair.price))
                }
              
                
                let set1 = LineChartDataSet(entries:self.yValues, label: "")
                set1.mode = .cubicBezier
                set1.drawCirclesEnabled = false
                set1.lineWidth = 3
                set1.setColor(.white)
                set1.fill = Fill(color: .white)
                set1.fillAlpha = 0.8
                set1.drawFilledEnabled = true
                set1.drawHorizontalHighlightIndicatorEnabled = false
                set1.highlightColor = .systemRed
                let data = LineChartData(dataSet: set1)
                data.setDrawValues(false)
                self.lineChartView.data = data
                self.lineChartView.animate(xAxisDuration: 0.5)

                
            case .failure(let error):
                debugPrint(error)
            }
            
        })
    
        
    }
    
    func getXYLastWeek(symbol: String, completion: @escaping (Result<[Coins], Error>) -> Void) {
        if startDate == nil {
            completion(.failure(NetError.noDataInRequest))
            return
        }
        let ticker = symbol + "usd"
        let url1 = URL(string:"https://api.tiingo.com/tiingo/crypto/prices?tickers="+ticker+"&startDate="+startDate!+"&resampleFreq="+frequency+"&token="+token)!
        
        
        AF.request(url1).responseJSON { response in
            switch response.result {
            
            case .success:
                do {
                    let prices = try JSONDecoder().decode([Coins].self, from: response.data!)
                    completion(.success(prices))
                    
                  
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                    print(error)
                }

            case let .failure(error):
                print("Request error: \(error.localizedDescription)")
            }
        }
    }
    
    var yValues:[ChartDataEntry] = []



}
