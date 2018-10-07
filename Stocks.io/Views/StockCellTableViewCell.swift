//
//  StockCellTableViewCell.swift
//  Stocks.io
//
//  Created by Craig Scott on 9/28/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit

class StockCellTableViewCell: UITableViewCell {

    @IBOutlet weak var symbolLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    
    func configureCell(symbol : String) {
        DispatchQueue.main.async {
            self.symbolLabel.text = symbol
        }
    }

}
