//
//  CoinData.swift
//  CrytoTracker
//
//  Created by Ricardo Hui on 27/5/2019.
//  Copyright © 2019 Ricardo Hui. All rights reserved.
//

import UIKit
import Alamofire
class CoinData{
    static  let shared = CoinData()
    var coins = [Coin]()
    weak var delegate : CoinDataDelegate?
    private init(){
        let symbols = ["BTC","ETH","LTC"]
        for symbol in symbols{
            let coin = Coin(symbol: symbol)
            coins.append(coin)
        }
    }
    
    func netWorthAsString()->String{
        var netWorth = 0.0
        for coin in coins{
            netWorth += coin.amount * coin.price
        }
        return doubleToMoneyString(double: netWorth)
    }
    
    
    func html()->String{
        var html = "<h1>MY Crypto Report</h1>"
        html += "<h2>Net Worth: \(netWorthAsString())</h2>"
        html += "<ul>"
        for coin in coins{
            if coin.amount != 0.0{
                html += "<li>\(coin.symbol) - I won: \(coin.amount) - Valued at: $\(doubleToMoneyString(double: coin.amount * coin.price))</li>"
            }
        }
        html += "</ul>"
        return html
    }
    
    func getPrices(){
        var listOfSymbols = ""
        for coin in coins {
            listOfSymbols += coin.symbol
            if coin.symbol != coins.last?.symbol{
                listOfSymbols += ","
            }
        }
        Alamofire.request("https://min-api.cryptocompare.com/data/pricemulti?fsyms=\(listOfSymbols)&tsyms=USD&api_key=c7416cef50cb4249daaaf2c5566ab46821b1d5d214284365438ae944573e886b").responseJSON { (response) in
            if let json = response.result.value as? [String:Any]{
                for coin in self.coins{
                    if let coinJSON = json[coin.symbol] as? [String:Double]{
                        if let price = coinJSON["USD"]{
                            coin.price = price
                        }
                    }
                  
                }
              self.delegate?.newPrices?()
            }
        }
        }
    
    func doubleToMoneyString(double:Double)->String{
        let formatter = NumberFormatter()
        formatter.locale  = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        if let fancyPrice = formatter.string(from: NSNumber(floatLiteral: double)){
            return fancyPrice
        }else{
            return "ERROR"
        }
    }
    
}

@objc protocol CoinDataDelegate: class{
    @objc optional func newPrices()
    @objc optional func newHistory()
}
class Coin{
    var symbol = ""
    var image = UIImage()
    var price = 0.0
    var amount = 0.0
    var historicalData =  [Double]()
    init(symbol:String) {
        self.symbol = symbol
        if let image = UIImage(named: symbol){
            self.image = image
        }
    }
    
    func getHistoricalData(){
        Alamofire.request("https://min-api.cryptocompare.com/data/histoday?fsym=\(symbol)&tsym=USD&limit=30&api_key=c7416cef50cb4249daaaf2c5566ab46821b1d5d214284365438ae944573e886b").responseJSON { (response) in
               if let json = response.result.value as? [String:Any]{
                if let pricesJSON = json["Data"] as? [[String:Double]]{
                    self.historicalData = []
                    for priceJSON in pricesJSON{
                        if let closePrice  = priceJSON["close"]{
                            self.historicalData.append(closePrice)
                        }
                    }
                    CoinData.shared.delegate?.newHistory?()
                }
            }
        }
    }
    
    
    
    func priceAsString()->String{
        if price == 0.0{
            return "Loading"
        }
       return CoinData.shared.doubleToMoneyString(double: price)
    }
    
    func amountAsString()->String{
        return CoinData.shared.doubleToMoneyString(double: amount * price)
    }
}
