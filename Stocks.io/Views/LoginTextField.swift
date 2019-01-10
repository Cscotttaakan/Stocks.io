//
//  LoginTextField.swift
//  Stocks.io
//
//  Created by Craig Scott on 1/4/19.
//  Copyright © 2019 Craig Scott. All rights reserved.
//

import UIKit

class LoginTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib(){
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.white.cgColor
    }

}
