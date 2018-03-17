//
//  RewardsTableViewCell.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/16/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit

class RewardsTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var myRewards: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        let val = findValue()
        points! = points! - val
        UserDefaults.standard.set(points!, forKey: "myPoints")
        print("reward used: " + myRewards.text!)
        
    }
    
    func findValue() -> Int {
        let str = myRewards.text!
        if let val = rewardsDict![str] {
            return val
        } else {
            return 0
        }
    }

}
