//
//  SearchViewController.swift
//  Stocks.io
//
//  Created by Craig Scott on 10/30/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//
import SwiftyJSON

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempStockSymbols.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "stock")
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: "stock")
        }
        cell?.textLabel?.text = tempStockSymbols[indexPath.row]
        return cell!
    }
    

    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchResults: UITableView!
    var companies : JSON = []
    var stockSymbols : [String] = [String]()
    var tempStockSymbols : [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResults.dataSource = self
        searchResults.delegate = self
        searchBar.delegate = self
        searchBar.addTarget(self, action: #selector(searchRecords(_ :)), for: .editingChanged)
        if let path = Bundle.main.path(forResource: "companiesnasdaq", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                //parse data here
                //If you are using SwiftyJSON use below commanded line
                // let jsonObj = try JSON(data: data)
                companies = try JSON(data)
                for value in companies {
                    stockSymbols.append(value.1["Symbol"].stringValue)
                }
                
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func searchRecords(_ textField : UITextField){
        self.tempStockSymbols.removeAll()
        if textField.text?.count ?? 0  > 2 {
            for stock in stockSymbols{
                if let stockToSearch = textField.text{
                    let range = stock.lowercased().range(of: stockToSearch, options: .caseInsensitive, range: nil, locale: nil)
                    if range != nil{
                        self.tempStockSymbols.append(stock)
                    }
                }
            }
        }else{
            for stock in stockSymbols {
                tempStockSymbols.append(stock)
            }
            
        }
        
        searchResults.reloadData()
    

}

}
