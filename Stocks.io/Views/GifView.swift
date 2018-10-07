//
//  GifView.swift
//  Stocks.io
//
//  Created by Craig Scott on 10/2/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit
import SwiftyGif

class GifView: UIView {

    override func awakeFromNib() {
        let gif = UIImage(gifName: "help")
        let imageview = UIImageView(gifImage: gif, loopCount: 1) // Use -1 for infinite loop
        imageview.frame = self.bounds
        self.addSubview(imageview)
    }

}
