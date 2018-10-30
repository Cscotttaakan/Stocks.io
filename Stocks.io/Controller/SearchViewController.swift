//
//  SearchViewController.swift
//  Stocks.io
//
//  Created by Craig Scott on 10/30/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResults: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResults.dataSource = self
        searchResults.delegate = self
        searchBar.delegate = self
        searchBar.addTarget(self, action: #selector(searchRecords(_ :)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    

}
