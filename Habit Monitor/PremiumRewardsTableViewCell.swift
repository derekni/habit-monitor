//
//  PremiumRewardsTableViewCell.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/17/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit

class PremiumRewardsTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var myPremiumReward: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
/*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        let val = findValue()
        savings! = savings! - val
        UserDefaults.standard.set(savings!, forKey: "mySavings")
        print("reward used: " + myPremiumReward.text! + " with value " + String(val))
    }

    func findValue() -> Int {
        let str = myPremiumReward.text!
        if let val = premiumRewardsDict![str] {
            return val
        } else {
            return 0
        }
    }
*/
}
