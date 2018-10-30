//
//  ViewController.swift
//  Stocks.io
//
//  Created by Craig Scott on 9/25/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Charts

class MainViewController: UIViewController , UITextFieldDelegate , UIScrollViewDelegate {
    
    //Defaults
    let defaults = UserDefaults.standard
    
    
    //Outlets
    @IBAction func menuButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            if self.stockTableView.frame.minX == 0{
                UIView.transition(with: self.stockTableView, duration: 0.15, options: .curveEaseIn, animations: {
                    
                    self.stockTableView.frame = CGRect(x: self.stockTableView.frame.minX - self.stockTableView.frame.width, y: 0, width: self.stockTableView.frame.width, height: self.stockTableView.frame.height)
                }, completion: nil)
            } else {
                if self.stockTableView.frame.minX != 0{
                    UIView.transition(with: self.stockTableView, duration: 0.15, options: .curveEaseIn, animations: {
                        
                        self.stockTableView.frame = CGRect(x: self.stockTableView.frame.minX + self.stockTableView.frame.width, y: 0, width: self.stockTableView.frame.width, height: self.stockTableView.frame.height)
                    }, completion: nil)
                }
            }
        }
    }
    
    @IBAction func addFavoriteStock(_ sender: UIButton) {
        if !symbolArray.contains(stockSymbolLabel.text!) {
            symbolArray.append(stockSymbolLabel.text!)
            defaults.set(symbolArray, forKey: "symbolArray")
            stockTableView.reloadData()
        }
    }
    
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var paragraphLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var stockSymbolLabel: UITextField!
    @IBOutlet weak var lineGraph: LineChartView!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var yearHighLabel: UILabel!
    @IBOutlet weak var yearLowLabel: UILabel!
    @IBOutlet weak var peRatioLabel: UILabel!
    @IBOutlet weak var sectorLabel: UILabel!
    
    @IBOutlet weak var stockTableView: UITableView!
    
    
    //Variables
    private weak var refreshTimer : Timer!
    private var stock : Stock = Stock()
    private var symbolArray : [String] = [String]()
    private var userdefaults = UserDefaults()
    private var companies : JSON = []
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setMainLayout()
        loadPreferences()
        refreshPage(symbol : stockSymbolLabel.text!)
    }
    
    func refreshPage(symbol : String){
        stock = Stock()
        stock._symbol = symbol
        stock.getData {
            print("UI Updated for \(symbol)")
            //self.updateUI()
            self.stock.getMonthlyData {
                self.updateChartData()
                print("Chart updated for \(symbol)")
                self.stock.getNewsData {
                    self.updateUI()
                }
            }
        }
    }
    
    func updateChartData(){
        let formato:BarChartFormatter = BarChartFormatter()
        formato.months = stock._month
        let xaxis:XAxis = XAxis()
        for index in 0..<stock._month.count{
            formato.stringForValue(Double(index), axis: xaxis)
        }
        xaxis.valueFormatter = formato
        
        DispatchQueue.main.async {
            self.lineGraph.data = self.stock._financials._chartData
            print(self.stock._financials._chartData.description)
            self.lineGraph.xAxis.valueFormatter = xaxis.valueFormatter
            self.lineGraph.animate(xAxisDuration: 1.0 , yAxisDuration: 2.0, easingOption : .easeInBounce)
        }
    }
    
    @objc func queryPriceChange(){
        stock.refreshPrice {
            self.updatePriceChange()
        }
    }
    
    func updatePriceChange(){
        if(stock._financials._currentPrice != nil){
            DispatchQueue.main.async {
                if let change = Double(self.stock._financials._change!) {
                    if change >= 0 {
                        self.changeLabel.textColor = UIColor.green
                    }else {
                        self.changeLabel.textColor = UIColor.red
                    }
                }
                
                print(self.stock._financials._currentPrice!)
                
                UIView.transition(with: self.currentValueLabel,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: { [weak self] in
                                    if let newSelf = self{
                                        newSelf.currentValueLabel.text = "$\(newSelf.stock._financials._currentPrice!)"
                                        
                                    }
                    },
                                  completion: nil)
                
                UIView.transition(with: self.changeLabel,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: { [weak self] in
                                    if let newSelf = self{
                                        newSelf.changeLabel.text = "$\(newSelf.stock._financials._change!) (\(newSelf.stock._financials._percentChange!)%)"
                                    }
                    },
                                  completion: nil)
            }
        }
    }
    
    func updateUI(){
        updatePriceChange()
        
        DispatchQueue.main.async {
            UIView.transition(with: self.lowLabel,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                if let newSelf = self{
                                    newSelf.lowLabel.text = "Low: $\(newSelf.stock._financials._low!)"} }, completion: nil)
            UIView.transition(with: self.highLabel,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                if let newSelf = self{
                                    newSelf.highLabel.text = "High: $\(newSelf.stock._financials._high!)"} }, completion: nil)
            UIView.transition(with: self.openLabel,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                if let newSelf = self{
                                    newSelf.openLabel.text = "Open: $\(newSelf.stock._financials._open!)"} }, completion: nil)
            UIView.transition(with: self.stockName,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                if let newSelf = self{
                                    newSelf.stockName.text = "\(newSelf.stock._companyName!)"} }, completion: nil)
            UIView.transition(with: self.closeLabel,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                if let newSelf = self{
                                    newSelf.closeLabel.text = "Close: $\(newSelf.stock._financials._close!)"} }, completion: nil)
            UIView.transition(with: self.yearLowLabel,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                if let newSelf = self{
                                    newSelf.yearLowLabel.text = "52 Week Low: $\(newSelf.stock._financials._yearLow!)"} }, completion: nil)
            UIView.transition(with: self.yearHighLabel,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                if let newSelf = self{
                                    newSelf.yearHighLabel.text = "52 Week High: $\(newSelf.stock._financials._yearHigh!)"} }, completion: nil)
            UIView.transition(with: self.peRatioLabel,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                if let newSelf = self{
                                    newSelf.peRatioLabel.text = "PE Ratio: \(newSelf.stock._financials._peRatio!)"} }, completion: nil)
            UIView.transition(with: self.sectorLabel,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                if let newSelf = self{
                                    newSelf.sectorLabel.text = "Sector: \(newSelf.stock._financials._sector!)"} }, completion: nil)
            if self.stock._news.count > 0{
                UIView.transition(with: self.newsTitle,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: { [weak self] in
                                    if let newSelf = self{
                                        newSelf.newsTitle.text = "\(newSelf.stock._news[0]._headLine!)"} }, completion: nil)
                UIView.transition(with: self.paragraphLabel,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: { [weak self] in
                                    if let newSelf = self{
                                        newSelf.paragraphLabel.text = "\(newSelf.stock._news[0]._summary!)"} }, completion: nil)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        stockSymbolLabel.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let symbol = stockSymbolLabel.text{
            defaults.set(symbol, forKey: "symbol")
            refreshPage(symbol: symbol)
            stockSymbolLabel.setNeedsDisplay()
        }
        return true
    }
    
}

extension MainViewController : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.stockCellID ) as! StockCellTableViewCell
        
        cell.configureCell(symbol: symbolArray[indexPath.row])
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symbolArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        stock._symbol = symbolArray[indexPath.row]
        stockSymbolLabel.text = stock._symbol
        defaults.set(stock._symbol, forKey: "symbol")
        refreshPage(symbol: stock._symbol!)
        
        //Automatically snaps due to constraint position, DO NOT WANT
        if (tableView.dequeueReusableCell(withIdentifier: UIConstants.stockCellID ) as? StockCellTableViewCell) != nil{
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            symbolArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}

extension MainViewController {
    // Janitorial Functions
    func setMainLayout(){
        stockTableView.delegate = self
        stockTableView.dataSource = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        stockSymbolLabel.delegate = self
        stockSymbolLabel.returnKeyType = .done
        stockSymbolLabel.autocapitalizationType = .allCharacters
        lineGraph.xAxis.drawGridLinesEnabled = false
        lineGraph.xAxis.labelPosition = .bottom
        lineGraph.xAxis.granularityEnabled = true
        lineGraph.xAxis.granularity = 1.0
        lineGraph.xAxis.labelCount = 31
        lineGraph.xAxis.labelRotationAngle = -45.0
        lineGraph.xAxis.labelFont = UIFont(name : "Damascus", size: 6.0)!
        lineGraph.rightAxis.enabled = false
        lineGraph.leftAxis.drawGridLinesEnabled = false
    }
    
    func loadPreferences(){
        stockSymbolLabel.text = defaults.string(forKey: "symbol") ?? "MSFT"
        symbolArray = defaults.object(forKey: "symbolArray") as? [String] ?? [String]()
    }
}

