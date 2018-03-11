//
//  MyButton.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/2/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit

class MyButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func layoutSubviews() {
        super.layoutSubviews()
            
        updateCornerRadius()
    }
        
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
        
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}
