//
//  Stock.swift
//  Stocks.io
//
//  Created by Craig Scott on 9/26/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Charts
import UIKit

class Stock {
    public var _symbol : String?
    private(set) var _companyName : String?
    private(set) var _news : [newsData] = [newsData]()
    private(set) var _financials : financialData = financialData()
    private(set) var _month : [String] = [String]()
    
    func refreshPrice(completed : @escaping () -> ()){
        if let symbol = _symbol{
            let priceURL = Utilities.constructIEXAPIQuery(symbol: symbol, type: IEXAPIConstants.type.quote, range: IEXAPIConstants.range.none)
            Alamofire.request(priceURL).responseJSON { (response) in
                let json = JSON(response.result.value )
                self.setPrice(json: json)
                completed()
            }
        }
    }
    
    func getData(completed : @escaping () -> ()){
        if let symbol = _symbol {
            let fullURL = Utilities.constructIEXAPIQuery(symbol: symbol, type: IEXAPIConstants.type.quote , range : IEXAPIConstants.range.none)
            Alamofire.request(fullURL).responseJSON { (response) in
                let json = JSON(response.result.value)
                self.setPrice(json: json)
                self.setFinance(json: json)
                completed()
            }
        }
        
        
    }
    
    func getNewsData(completed : @escaping () -> ()){
        
        if let symbol = _symbol {
            let newsURL = Utilities.constructIEXAPIQuery(symbol: symbol, type: IEXAPIConstants.type.news, range : IEXAPIConstants.range.none)
            Alamofire.request(newsURL).responseJSON { (response) in
                let json = JSON(response.result.value)
                self.setNews(json: json)
                completed()
            }
        }
    }
    
    func getMonthlyData(completed : @escaping () -> ()){
        if let symbol = _symbol{
            let thirtyDayURL = Utilities.constructIEXAPIQuery(symbol: symbol, type: IEXAPIConstants.type.chart, range : IEXAPIConstants.range.m)
            
            Alamofire.request(thirtyDayURL).responseJSON {(response) in
                let json = JSON(response.result.value)
                let chartData = self.buildChartData(json: json)
                let set = LineChartDataSet(values: chartData , label: "30 Day Price Range")
                self.mutateDataStyle(set: set)
                self._financials._chartData = LineChartData(dataSet: set)
                completed()
            }
        }
    }
}

//Utility Functions
extension Stock {
    
    func setPrice(json : JSON ){
        let price = json["iexRealtimePrice"].doubleValue.rounded(toPlaces: 2)
        let change = json["change"].doubleValue.rounded(toPlaces: 4)
        let percentChange = (json["changePercent"].doubleValue).rounded(toPlaces: 2)
        let close = json["close"].doubleValue.rounded(toPlaces: 2)
        
        self._financials._change = String(change)
        self._financials._percentChange = String(percentChange)
        self._financials._close = String(close)
        self._financials._currentPrice = json["iexRealTimePrice"] == JSON.null ? self._financials._close : String(price)
    }
    
    func setFinance(json : JSON) {
        
       
        let open = json["open"].doubleValue.rounded(toPlaces: 2)
        let low = json["low"].doubleValue.rounded(toPlaces: 2)
        let high = json["high"].doubleValue.rounded(toPlaces: 2)
        let companyName = json["companyName"].stringValue
        let yearHigh = json["week52High"].doubleValue.rounded(toPlaces: 2)
        let yearLow = json["week52Low"].doubleValue.rounded(toPlaces: 2)
        let peRatio = json["peRatio"].doubleValue.rounded(toPlaces: 2)
        let sector = json["sector"].stringValue
        
        self._financials._open = String(open)
        self._financials._high = String(high)
        self._financials._low = String(low)
        self._companyName = companyName
        self._financials._yearHigh = String(yearHigh)
        self._financials._yearLow = String(yearLow)
        self._financials._peRatio = String(peRatio)
        self._financials._sector = sector
        
    }
    
    func setNews(json : JSON) {
        for item in json{
            let data = item.1
            let time = data["datetime"].stringValue
            let headline = data["headline"].stringValue
            let source = data["source"].stringValue
            let summary = data["summary"].stringValue
            
            var newsCell = newsData()
            newsCell._dateTime = time
            newsCell._headLine = headline
            newsCell._source = source
            newsCell._summary = summary
            
            self._news.append(newsCell)
        }
    }
    
    func buildChartData(json : JSON) -> [ChartDataEntry] {
        var chartData : [ChartDataEntry] = [ChartDataEntry]()
        for index in 0..<json.count{
            let day = json[index]["date"].stringValue
            let closePrice = json[index]["close"].doubleValue
            self._month.append(String(day.dropFirst(5)))
            
            //self._monthlyPrices.append((key, Double(closePrice.stringValue)!))
            let price = Double(closePrice).rounded(toPlaces: 1)
            let point = ChartDataEntry(x: Double(index), y: price)
            chartData.append(point)
            
        }
        return chartData
    }
    
    func mutateDataStyle( set : LineChartDataSet){
        
        let teal = UIConstants.Color.teal
        set.colors = [teal]
        set.setCircleColor(teal)
        set.circleHoleColor = teal
        set.circleRadius = ChartFormattingConstants.circleRadius
        set.valueFont = UIConstants.Font.mainFont
        set.mode = .cubicBezier
        set.drawValuesEnabled = false
        set.cubicIntensity = ChartFormattingConstants.cubicIntensity
        let gradientColors = [teal.cgColor ,UIColor.clear.cgColor] as CFArray
        let colorLocations : [CGFloat] = [1.0,0.0]
        if let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) {
        set.fill = Fill.fillWithLinearGradient(gradient, angle: ChartFormattingConstants.angle )
        }
        set.drawFilledEnabled = true
    }
}

fileprivate struct ChartFormattingConstants{
    static let circleRadius : CGFloat = 2.0
    static let cubicIntensity : CGFloat = 0.2
    static let angle : CGFloat = 90.0
}
