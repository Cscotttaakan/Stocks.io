//
//  BarChartFormatter.swift
//  Stocks.io
//
//  Created by Craig Scott on 9/29/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import Foundation
import UIKit
import Charts

import UIKit
import Foundation
import Charts

@objc(BarChartFormatter)
public class BarChartFormatter: NSObject, IAxisValueFormatter{
    
    var months: [String]!
    
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if Int(value) < months.count {
        return months[Int(value)]
        }else {
            return "N/A"
        }
    }
}
