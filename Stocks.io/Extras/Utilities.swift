//
//  Utilities.swift
//  Stocks.io
//
//  Created by Craig Scott on 9/26/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import Foundation
import UIKit
class Utilities {
    static var sharedInstance = Utilities()
    static let calendar = Calendar.current
    
    static func constructIEXAPIQuery(symbol : String , type : String , range : String) -> URL{
        var queryURL = IEXAPIConstants.baseQuery
        queryURL.append("/\(symbol.trimmingCharacters(in: .whitespacesAndNewlines))")
        queryURL.append("/\(type)")
        queryURL.append("/\(range)")
        
        if let url = URL(string: queryURL)
        {
        return url
        }else{
            return URL(string: "Error")!
        }
    }
    
}

extension UIViewController {
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
