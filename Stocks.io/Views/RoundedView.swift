//
//  RoundedView.swift
//  Stocks.io
//
//  Created by Craig Scott on 9/25/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit
import UIGradient

class RoundedView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.addBlurEffect()
        self.alpha = 0.0
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        //self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.clipsToBounds = true
        UIView.transition(with: self, duration: 1.0, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
}
