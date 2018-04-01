//
//  RewardsTableViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/16/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit

//point val
var pointVal:Int?

func savePointVal(pointVal:Int?) {
    UserDefaults.standard.set(pointVal, forKey: "myPointVal")
}

func fetchPointVal() -> Int? {
    if let val = UserDefaults.standard.integer(forKey: "myPointVal") as? Int {
        return val
    } else {
        return nil
    }
}

func changePointVal(newVal:Int) {
    UserDefaults.standard.set(newVal, forKey: "myPointVal")
}

//rewards
var rewards:[String]?
var rewardsDict:[String:Int]?

func saveRewardsData(rewards:[String]?) {
    UserDefaults.standard.set(rewards, forKey: "myRewards")
}

func saveRewardsDictData(rewardsDict:[String:Int]?) {
    UserDefaults.standard.set(rewardsDict, forKey:"myRewardsDict")
}

func fetchRewardsData() -> [String]? {
    if let reward = UserDefaults.standard.array(forKey: "myRewards") as? [String] {
        return reward
    } else {
        return nil
    }
}

func fetchRewardsDictData() -> [String:Int]? {
    if let dict = UserDefaults.standard.dictionary(forKey: "myRewardsDict") as? [String:Int] {
        return dict
    } else {
        return nil
    }
}

func addReward(reward: String, value: Int) {
    if reward != "" {
        rewards!.append(reward)
        UserDefaults.standard.set(rewards!, forKey: "myRewards")
        rewardsDict![reward] = value
        UserDefaults.standard.set(rewardsDict!, forKey: "myRewardsDict")
    }
}

func deleteReward(reward: String) {
    if reward != "" {
        if let index = rewards!.index(of: reward) {
            rewards!.remove(at: index)
            UserDefaults.standard.set(rewards!, forKey: "myRewards")
            let dictIndex = rewardsDict!.index(forKey: reward)
            rewardsDict!.remove(at: dictIndex!)
            UserDefaults.standard.set(rewardsDict!, forKey: "myRewardsDict")
        }
    }
}

//premium rewards
var premiumRewards:[String]?
var premiumRewardsDict:[String:Int]?

func savePremiumRewardsData(premiumRewards:[String]?) {
    UserDefaults.standard.set(premiumRewards, forKey: "myPremiumRewards")
}

func savePremiumRewardsDictData(premiumRewardsDict:[String:Int]?) {
    UserDefaults.standard.set(premiumRewardsDict, forKey:"myPremiumRewardsDict")
}

func fetchPremiumRewardsData() -> [String]? {
    if let premiumReward = UserDefaults.standard.array(forKey: "myPremiumRewards") as? [String] {
        return premiumReward
    } else {
        return nil
    }
}

func fetchPremiumRewardsDictData() -> [String:Int]? {
    if let dict = UserDefaults.standard.dictionary(forKey: "myPremiumRewardsDict") as? [String:Int] {
        return dict
    } else {
        return nil
    }
}

func addPremiumReward(premiumReward: String, value: Int) {
    if premiumReward != "" {
        premiumRewards!.insert(premiumReward, at: 0)
        UserDefaults.standard.set(premiumRewards!, forKey: "myPremiumRewards")
        premiumRewardsDict![premiumReward] = value
        UserDefaults.standard.set(premiumRewardsDict!, forKey: "myPremiumRewardsDict")
    }
}

func deletePremiumReward(premiumReward: String) {
    if premiumReward != "" {
        if let index = premiumRewards!.index(of: premiumReward) {
            premiumRewards!.remove(at: index)
            UserDefaults.standard.set(premiumRewards!, forKey: "myPremiumRewards")
            let dictIndex = premiumRewardsDict!.index(forKey: premiumReward)
            premiumRewardsDict!.remove(at: dictIndex!)
            UserDefaults.standard.set(premiumRewardsDict!, forKey: "myPremiumRewardsDict")
        }
    }
}

//rewards cell
class RewardsTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var myRewards: UILabel!
    @IBOutlet weak var rewardCost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

//premium rewards cell
class PremiumRewardsTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var myPremiumReward: UILabel!
    @IBOutlet weak var rewardCost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

//rewards controller
class RewardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var myRewards: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myRewards.delegate = self
        myRewards.dataSource = self
        
        myRewards.tableFooterView = UIView(frame: .zero)
        myRewards.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: myRewards.frame.size.width, height: 1))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func numberOfSections(in myRewards: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ myRewards: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Rewards"
        } else {
            return "Premium Rewards"
        }
    }
    
    func tableView(_ myRewards: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return rewards!.count
        } else {
            return premiumRewards!.count
        }
    }
    
    func tableView(_ myRewards: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = myRewards.dequeueReusableCell(withIdentifier: "RewardsTableViewCell", for: indexPath) as? RewardsTableViewCell else {
                fatalError("cell isnt a reward cell")
            }
            cell.myRewards.text = rewards![indexPath.row]
            cell.rewardCost.text = String(findValue(text: rewards![indexPath.row], section: 0))
            cell.rewardCost.bounds = CGRect(x: 0.0, y: 0.0, width: 34, height: 34)
            cell.rewardCost.layer.cornerRadius = 34 / 2
            cell.rewardCost.layer.borderWidth = 1.5
            return cell
        } else if indexPath.section == 1 {
            guard let cell = myRewards.dequeueReusableCell(withIdentifier: "PremiumRewardsTableViewCell", for: indexPath) as? PremiumRewardsTableViewCell else {
                fatalError("cell isnt a premium reward cell")
            }
            cell.myPremiumReward.text = premiumRewards![indexPath.row]
            if (premiumRewards![indexPath.row] != "Purchase") {
                cell.rewardCost.text = String(findValue(text: premiumRewards![indexPath.row], section: 1))
                cell.rewardCost.bounds = CGRect(x: 0.0, y: 0.0, width: 34, height: 34)
                cell.rewardCost.layer.cornerRadius = 34 / 2
                cell.rewardCost.layer.borderWidth = 1.5
                return cell
            } else {
                cell.rewardCost.text = "?"
                cell.rewardCost.bounds = CGRect(x: 0.0, y: 0.0, width: 34, height: 34)
                cell.rewardCost.layer.cornerRadius = 34 / 2
                cell.rewardCost.layer.borderWidth = 1.5
                return cell
            }
        }
        return myRewards.dequeueReusableCell(withIdentifier: "ReuseIdentifier", for: indexPath)
    }
    
    func tableView(_ myRewards: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let val = findValue(text: rewards![indexPath.row], section: 0)
            if points! < val {
                print("reward " + rewards![indexPath.row] + " could not be used, not enough points")
            } else {
                let reward = rewards![indexPath.row]
                addHistory(hist: reward)
                points! = points! - val
                UserDefaults.standard.set(points!, forKey: "myPoints")
                print("reward used: " + rewards![indexPath.row] + " with value " + String(val))
            }
            self.performSegue(withIdentifier: "RewardsToPoints", sender: self)
        } else if indexPath.section == 1 {
            if (premiumRewards![indexPath.row] == "Purchase") {
                self.performSegue(withIdentifier:"PremiumRewardsToAdd", sender: self)
            } else {
                if (points! > 0) {
                    points! = points! - 1
                    UserDefaults.standard.set(points!, forKey: "myPoints")
                    let reward = premiumRewards![indexPath.row]
                    let val = findValue(text: reward, section: 1) - 1
                    premiumRewardsDict![reward] = val
                    UserDefaults.standard.set(premiumRewardsDict, forKey: "myPremiumRewardsDict")
                    if (val  == 0) {
                        addHistory(hist: reward)
                        deletePremiumReward(premiumReward: reward)
                        myRewards.deleteRows(at: [indexPath], with: UITableViewRowAnimation.right)
                    }
                } else {
                    print("reward " + premiumRewards![indexPath.row] + " could not be used, not enough points")
                }
                /*
                let val = findValue(text: premiumRewards![indexPath.row], section: 1)
                if savings! < val {
                    print("reward " + premiumRewards![indexPath.row] + " could not be used, not enough points")
                } else {
                    let premiumReward = premiumRewards![indexPath.row]
                    addHistory(hist: premiumReward)
                    savings! = savings! - val
                    UserDefaults.standard.set(savings!, forKey: "mySavings")
                    print("reward used: " + premiumRewards![indexPath.row] + " with value " + String(val))
                }
                self.performSegue(withIdentifier: "PremiumRewardsToSavings", sender: self)
                 */
            }
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

//add reward controller
class AddRewardViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var rewardType: UISegmentedControl!
    @IBOutlet weak var rewardName: UITextField!
    @IBOutlet weak var rewardCost: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func addPressed(_ sender: Any) {
        let name = rewardName.text
        let cost = Int(rewardCost.text!)
        let type = rewardType.titleForSegment(at: rewardType.selectedSegmentIndex)
        if (type == "Reward") {
            addReward(reward: name!, value: cost!)
        } else {
            addPremiumReward(premiumReward: name!, value: cost!)
        }
        self.performSegue(withIdentifier: "AddToRewards", sender: self)
    }
    
}

//custom reward controller
class CustomRewardViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var myReward: UITextField!
    @IBOutlet weak var myCost: CurrencyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func redeemPressed(_ sender: Any) {
        let reward = myReward.text
        let cost = myCost.doubleValue
        
        let val = Int(cost - 0.01) / pointVal! + 1
        
        if savings! < val {
            print("reward " + reward! + " could not be used, not enough points")
        } else {
            addHistory(hist: reward!)
            savings! = savings! - val
            UserDefaults.standard.set(savings!, forKey: "mySavings")
            print("reward used: " + reward! + " with value " + String(val))
        }
        self.performSegue(withIdentifier: "CustomRewardToSavings", sender: self)
    }
    
}