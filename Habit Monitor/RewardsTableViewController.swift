//
//  RewardsTableViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/16/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit

class RewardsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Rewards"
        } else {
            return "Premium Rewards"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return rewards!.count
        } else {
            return premiumRewards!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RewardsTableViewCell", for: indexPath) as? RewardsTableViewCell else {
                fatalError("cell isnt a reward cell")
            }
            cell.myRewards.text = rewards![indexPath.row]
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PremiumRewardsTableViewCell", for: indexPath) as? PremiumRewardsTableViewCell else {
                fatalError("cell isnt a premium reward cell")
            }
            cell.myPremiumReward.text = premiumRewards![indexPath.row]
            return cell
        }
        return tableView.dequeueReusableCell(withIdentifier: "ReuseIdentifier", for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let val = findValue(text: rewards![indexPath.row], section: 0)
            if points! < val {
                print("reward " + rewards![indexPath.row] + " could not be used, not enough points")
            } else {
                points! = points! - val
                UserDefaults.standard.set(points!, forKey: "myPoints")
                print("reward used: " + rewards![indexPath.row] + " with value " + String(val))
            }
            self.performSegue(withIdentifier: "RewardsToPoints", sender: self)
            //later, add performsegue if the text is a custom choice, and do stuff in another view controller
            //like the add view controller
        } else if indexPath.section == 1 {
            let val = findValue(text: premiumRewards![indexPath.row], section: 1)
            if savings! < val {
                print("reward " + premiumRewards![indexPath.row] + " could not be used, not enough points")
            } else {
                savings! = savings! - val
                UserDefaults.standard.set(savings!, forKey: "mySavings")
                print("reward used: " + premiumRewards![indexPath.row] + " with value " + String(val))
            }
            self.performSegue(withIdentifier: "PremiumRewardsToSavings", sender: self)
            //later, add performsegue if the text is a custom choice, and do stuff in another view controller
            //like the add view controller
        }
    }
    
    func findValue(text: String, section: Int) -> Int {
        if section == 0 {
            let val = rewardsDict![text]
            return val!
        } else {
            let val = premiumRewardsDict![text]
            return val!
        }
    }
}
