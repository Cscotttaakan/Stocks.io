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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as? SearchTableViewCell
        
        cell?.name.text = tempStockSymbols[indexPath.row].name
        cell?.symbol.text = tempStockSymbols[indexPath.row].symbol
        return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchResults.deselectRow(at: indexPath, animated: true)
        if let nav = self.navigationController{
            for vc in nav.viewControllers{
                if let main = vc as? MainViewController{
                    main.stockString = tempStockSymbols[indexPath.row].symbol
                }
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    

    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchResults: UITableView!
    var companies : JSON = []
    var stockSymbols : [JSON] = [JSON]()
    var tempStockSymbols : [(symbol:String, name:String)] = [(String,String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResults.dataSource = self
        searchResults.delegate = self
        searchBar.delegate = self
        searchBar.addTarget(self, action: #selector(searchRecords(_ :)), for: .editingChanged)
        searchBar.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        searchBar.autocorrectionType = .no
        DispatchQueue.global(qos: .background).async{ [weak self] in
        if let path = Bundle.main.path(forResource: "companiesnasdaq", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                //parse data here
                //If you are using SwiftyJSON use below commanded line
                // let jsonObj = try JSON(data: data)
                self?.companies = try JSON(data)
                for value in (self?.companies)! {
                    self!.stockSymbols.append(value.1)
                }
                
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
    }
        // Do any additional setup after loading the view.
    }
    
    @objc func searchRecords(_ textField : UITextField){
        self.tempStockSymbols.removeAll()
        if textField.text?.count ?? 0 > 0 {
            for value in companies{
                if let stockToSearch = textField.text{
                    let range = value.1["Symbol"].stringValue.lowercased().range(of: stockToSearch, options: .caseInsensitive, range: nil, locale: nil)
                    if range != nil{
                        let stock = (value.1["Symbol"].stringValue,value.1["Name"].stringValue)
                        self.tempStockSymbols.append(stock)
                    }
                }
            }
        }else{
            for value in companies {
                let stock = (value.1["Symbol"].stringValue,value.1["Name"].stringValue)
                self.tempStockSymbols.append(stock)
            }
            
        }
        
        searchResults.reloadData()
    

}
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }

}
