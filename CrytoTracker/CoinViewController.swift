//
//  CoinViewController.swift
//  CrytoTracker
//
//  Created by Ricardo Hui on 28/5/2019.
//  Copyright © 2019 Ricardo Hui. All rights reserved.
//

import UIKit

private let chartHeight : CGFloat = 300.0

import SwiftChart
class CoinViewController: UIViewController , CoinDataDelegate{
    var coin: Coin?
    var chart  = Chart()
    override func viewDidLoad() {
        super.viewDidLoad()
        CoinData.shared.delegate = self
        edgesForExtendedLayout = []
        view.backgroundColor = UIColor.white
        chart.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: chartHeight)
        chart.yLabelsFormatter = {CoinData.shared.doubleToMoneyString(double: $1)}
        chart.xLabels = [30,25,20,15,10,5,0]
        chart.xLabelsFormatter = {String(Int(round(30-$1)))+"d"}
        view.addSubview(chart)
        coin?.getHistoricalData()
        // Do any additional setup after loading the view.
    }
    
    func newHistory() {
        if let coin = coin{
            let series = ChartSeries(coin.historicalData)
            series.area = true
            chart.add(series)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
