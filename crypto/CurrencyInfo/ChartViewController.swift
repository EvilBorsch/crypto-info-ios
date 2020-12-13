//
//  ChartViewController.swift
//  crypto
//
//  Created by Alexandr Dolgavin on 13.12.2020.
//

import UIKit

import Charts
import TinyConstraints

class ChartViewController: UIViewController {
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemBlue
        
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
        chartView.xAxis.axisLineColor = .systemBlue
        
        chartView.animate(xAxisDuration: 2.5)
        
        return chartView
    }()

    override func viewDidLoad() {
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        
        super.viewDidLoad()
        
        setData()

        // Do any additional setup after loading the view.
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData(){
        let set1 = LineChartDataSet(entries:yValues, label: "$ - time")
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
        lineChartView.data = data
        
    }
    
    let yValues:[ChartDataEntry] = [
        ChartDataEntry(x:0.0, y:10.0),
        ChartDataEntry(x:1.0, y:5.0),
        ChartDataEntry(x:2.0, y:7.0),
        ChartDataEntry(x:3.0, y:5.0),
        ChartDataEntry(x:4.0, y:10.0),
        ChartDataEntry(x:5.0, y:6.0),
        ChartDataEntry(x:6.0, y:8.0),
        ChartDataEntry(x:7.0, y:5.0),
        ChartDataEntry(x:8.0, y:10.0),
    
    ]

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
