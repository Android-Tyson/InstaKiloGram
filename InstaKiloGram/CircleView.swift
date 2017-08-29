//
//  CircleView.swift
//  InstaKiloGram
//
//  Created by Tyson  on 8/29/17.
//  Copyright © 2017 HistoryMakers. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.opacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
    }
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width/2
    }

}
