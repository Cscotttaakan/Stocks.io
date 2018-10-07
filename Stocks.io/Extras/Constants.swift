//
//  Constants.swift
//  Stocks.io
//
//  Created by Craig Scott on 9/26/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import Foundation
import UIKit

struct UIConstants {
    static let stockCellID : String = "StockCell"
    struct Color {
        static let teal : UIColor = UIColor(red:0.23, green:0.93, blue:0.68, alpha:1.0)
    }
    struct Font {
        static let mainFont : UIFont = UIFont(name : "Damascus" , size : 8.0)!
    }
}



struct IEXAPIConstants {
    static let baseQuery : String = "https://api.iextrading.com/1.0/stock"
    struct type {
        static let quote : String = "quote"
        static let news : String = "news"
        static let chart : String = "chart"
    }
    struct range {
        static let none : String = ""
        static let d : String = "1d"
        static let m : String = "1m"
        static let threeM : String = "3m"
        static let sixM : String = "6m"
        static let ytd : String = "ytd"
        static let yr : String = "1y"
        static let twoyr : String = "2y"
        static let fiveyr : String = "5y"
    }
    
}

struct APIFunctions {
    static let timeSeriesIntraday : String = "TIME_SERIES_INTRADAY"
    static let timeSeriesDaily : String = "TIME_SERIES_DAILY"
    static let globalQuote : String = "GLOBAL_QUOTE"
    static let timeSeriesMonthly : String = "TIME_SERIES_MONTHLY"
}

struct timeInterval {
    static let one = "1min"
    static let five = "5min"
    static let fifteen = "15min"
    static let thirty = "30min"
    static let hour = "60min"
    static let none = ""
}
