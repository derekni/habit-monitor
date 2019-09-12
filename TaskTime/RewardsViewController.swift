//
//  RewardsTableViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/16/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit
import AVFoundation

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
    @IBOutlet weak var myTitle: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: fetchColorCode()!)
        navigationBar.barTintColor = UIColor(hex: fetchColorCode()!)
        
        myRewards.delegate = self
        myRewards.dataSource = self
        
        myRewards.tableFooterView = UIView(frame: .zero)
        myRewards.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: myRewards.frame.size.width, height: 1))
        
        let longPressTitle = UILongPressGestureRecognizer(target: self, action: #selector(RewardsViewController.longPressTitle))
        myTitle.addGestureRecognizer(longPressTitle)
        
        let longPressReward = UILongPressGestureRecognizer(target: self, action: #selector(RewardsViewController.longPressReward))
        myRewards.addGestureRecognizer(longPressReward)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            if (myRewards.isEditing == false) {
                cell.rewardCost.text = String(findValue(text: rewards![indexPath.row], section: 0))
                cell.rewardCost.bounds = CGRect(x: 0.0, y: 0.0, width: 34, height: 34)
                cell.rewardCost.layer.cornerRadius = 34 / 2
                cell.rewardCost.layer.borderWidth = 1.5
            } else {
                cell.rewardCost.text = ""
                cell.rewardCost.layer.borderWidth = 0
            }
            return cell
        } else if indexPath.section == 1 {
            guard let cell = myRewards.dequeueReusableCell(withIdentifier: "PremiumRewardsTableViewCell", for: indexPath) as? PremiumRewardsTableViewCell else {
                fatalError("cell isnt a premium reward cell")
            }
            cell.myPremiumReward.text = premiumRewards![indexPath.row]
            if (myRewards.isEditing == false) {
                if (premiumRewards![indexPath.row] != "Redeem") {
                    let text = String(findValue(text: premiumRewards![indexPath.row], section: 1))
                    if (text == "0") {
                        cell.rewardCost.text = "☆"
                    } else {
                        cell.rewardCost.text = String(findValue(text: premiumRewards![indexPath.row], section: 1))
                    }
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
            } else {
                cell.rewardCost.text = ""
                cell.rewardCost.layer.borderWidth = 0
                return cell
            }
        }
        return myRewards.dequeueReusableCell(withIdentifier: "ReuseIdentifier", for: indexPath)
    }
    
    func tableView(_ myRewards: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let val = findValue(text: rewards![indexPath.row], section: 0)
            if points! < val {
                let alert = UIAlertController(title: "Not enough points", message: "You must have at least " + String(val) + " points to redeem this reward.", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Got it", style: .default) { (_) in
                    return
                }
                alert.addAction(cancel)
                present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Redeem Reward", message: "Would you like to redeem the reward " + rewards![indexPath.row] + " for " + String(val) + " points?", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
                    return
                }
                let action = UIAlertAction(title: "Redeem", style: .default) { (_) in
                    let reward = rewards![indexPath.row]
                    addHistory(hist: reward)
                    points! = points! - val
                    UserDefaults.standard.set(points!, forKey: "myPoints")
                    soundEffect(name: "game_win")
                    self.performSegue(withIdentifier: "RewardsToPoints", sender: self)
                }
                alert.addAction(cancel)
                alert.addAction(action)
                present(alert, animated: true)
            }
        } else if indexPath.section == 1 {
            if (premiumRewards![indexPath.row] == "Redeem") {
                self.performSegue(withIdentifier:"PremiumRewardsToAdd", sender: self)
            } else {
                let reward = premiumRewards![indexPath.row]
                let val = findValue(text: reward, section: 1)
                if (val == 0) {
                    let alert = UIAlertController(title: "Redeem Premium Reward", message: "Would you like to redeem the premium reward " + reward + " ?", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
                        return
                    }
                    let action = UIAlertAction(title: "Redeem", style: .default) { (_) in
                        addHistory(hist: reward)
                        deletePremiumReward(premiumReward: reward)
                        myRewards.deleteRows(at: [indexPath], with: .right)
                        soundEffect(name: "game_win")
                    }
                    alert.addAction(cancel)
                    alert.addAction(action)
                    present(alert, animated: true)
                } else {
                    if (points! > 0) {
                        points! = points! - 1
                        UserDefaults.standard.set(points!, forKey: "myPoints")
                        premiumRewardsDict![reward] = val - 1
                        UserDefaults.standard.set(premiumRewardsDict, forKey: "myPremiumRewardsDict")
                        soundEffect(name: "button_blip")
                        myRewards.reloadData()
                    } else {
                        let alert = UIAlertController(title: "Not enough points", message: "You must have at least 1 point to save for this reward.", preferredStyle: .alert)
                        let cancel = UIAlertAction(title: "Got it", style: .default) { (_) in
                            return
                        }
                        alert.addAction(cancel)
                        present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit", handler:{action, indexpath in
            let alert = UIAlertController(title: "Edit Reward", message: nil, preferredStyle: .alert)
            alert.addTextField { (rewardsTF) in
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 46, height: 20))
                label.text = "Name:"
                label.backgroundColor = UIColor.white
                label.font = UIFont.boldSystemFont(ofSize: 14)
                rewardsTF.leftViewMode = UITextFieldViewMode.always
                rewardsTF.leftView = label
                if (indexPath.section == 0) {
                    rewardsTF.text = rewards![indexPath.row]
                } else {
                    rewardsTF.text = premiumRewards![indexPath.row]
                }
                rewardsTF.maxLength = 25
            }
            alert.addTextField { (rewardsCostTF) in
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 37, height: 20))
                label.text = "Cost:"
                label.backgroundColor = UIColor.white
                label.font = UIFont.boldSystemFont(ofSize: 14)
                rewardsCostTF.leftViewMode = UITextFieldViewMode.always
                rewardsCostTF.leftView = label
                if (indexPath.section == 0) {
                    rewardsCostTF.text = String(rewardsDict![rewards![indexPath.row]]!)
                } else {
                    rewardsCostTF.text = String(premiumRewardsDict![premiumRewards![indexPath.row]]!)
                }
                rewardsCostTF.maxLength = 5
                rewardsCostTF.keyboardType = UIKeyboardType.numberPad
            }
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
                return
            }
            let action = UIAlertAction(title: "Edit", style: .default) { (_) in
                guard let reward = alert.textFields?.first?.text else { return }
                let cost = Int(alert.textFields![1].text!)
                if (indexPath.section == 0) {
                    rewardsDict![reward] = rewardsDict![rewards![indexPath.row]]
                    rewardsDict![rewards![indexPath.row]] = nil
                    rewards![indexPath.row] = reward
                    rewardsDict![reward] = cost
                    saveRewardsData(rewards: rewards)
                    saveRewardsDictData(rewardsDict: rewardsDict)
                    self.myRewards.reloadData()
                } else {
                    premiumRewardsDict![reward] = premiumRewardsDict![premiumRewards![indexPath.row]]
                    premiumRewardsDict![premiumRewards![indexPath.row]] = nil
                    premiumRewards![indexPath.row] = reward
                    premiumRewardsDict![reward] = cost
                    savePremiumRewardsData(premiumRewards: premiumRewards)
                    savePremiumRewardsDictData(premiumRewardsDict: premiumRewardsDict)
                    self.myRewards.reloadData()
                }
                tableView.reloadData()
            }
            alert.addAction(cancel)
            alert.addAction(action)
            self.present(alert, animated: true)
        });
        editRowAction.backgroundColor = UIColor.lightGray;
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            if (indexPath.section == 0) {
                deleteReward(reward: String(describing: rewards![indexPath.row]))
            } else {
                deletePremiumReward(premiumReward: String(describing: premiumRewards![indexPath.row]))
            }
            self.myRewards.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        });
        
        return [deleteRowAction, editRowAction];
    }
    
    func tableView(_ myRewards: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ myRewards: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if (myRewards.isEditing == true) {
            return UITableViewCellEditingStyle.none
        } else {
            return UITableViewCellEditingStyle.delete
        }
    }
    
    func tableView(_ myRewards: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ myRewards: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        if (sourceIndexPath.section == 0 && destinationIndexPath.section == 0) {
            rewards!.insert(rewards!.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
            saveRewardsData(rewards: rewards)
        } else if (sourceIndexPath.section == 1 && destinationIndexPath.section == 1) {
            premiumRewards!.insert(premiumRewards!.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
            savePremiumRewardsData(premiumRewards: premiumRewards)
        }
        myRewards.reloadData()
        soundEffect(name: "lip_sound")
    }
    
    @objc func longPressTitle(press: UILongPressGestureRecognizer) {
        if (press.state == UIGestureRecognizerState.began){
            if (myRewards.isEditing) {
                myRewards.setEditing(false, animated: true)
            } else {
                myRewards.setEditing(true, animated: true)
            }
            myRewards.reloadData()
        }
    }
    
    @objc func longPressReward(press: UILongPressGestureRecognizer) {
        if (press.state == UIGestureRecognizerState.began){
            let touchPoint = press.location(in: myRewards)
            if let indexPath = myRewards.indexPathForRow(at: touchPoint) {
                if indexPath.section == 0 {
                    let alert = UIAlertController(title: "Redeem Reward", message: "How much of " + rewards![indexPath.row] + " do you want to redeem?", preferredStyle: .alert)
                    alert.addTextField { (rewardsTF) in
                        rewardsTF.text = ""
                        rewardsTF.maxLength = 5
                        rewardsTF.keyboardType = UIKeyboardType.decimalPad
                    }
                    let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
                        return
                    }
                    let action = UIAlertAction(title: "Redeem", style: .default) { (_) in
                        let text = alert.textFields?.first?.text
                        let amount = Int(text!)
                        let cost = amount! * rewardsDict![rewards![indexPath.row]]!
                        if (cost > points!) {
                            //tell the user the cost > points
                            let errorAlert = UIAlertController(title: "Not enough points", message: "You do not have enough points to complete this action.", preferredStyle: .alert)
                            let cancel = UIAlertAction(title: "Got it", style: .default) { (_) in
                                return
                            }
                            errorAlert.addAction(cancel)
                            self.present(errorAlert, animated: true)
                            soundEffect(name: "selection_deny")
                        } else if (cost <= 0) {
                            //tell the user the cost has to be > 0
                            let errorAlert = UIAlertController(title: "Invalid reward cost", message: "The cost must be greater than zero.", preferredStyle: .alert)
                            let cancel = UIAlertAction(title: "Got it", style: .default) { (_) in
                                return
                            }
                            errorAlert.addAction(cancel)
                            self.present(errorAlert, animated: true)
                            soundEffect(name: "selection_deny")
                        } else {
                            let reward = rewards![indexPath.row]
                            for _ in 1 ... amount! {
                                addHistory(hist: reward)
                            }
                            points! = points! - cost
                            UserDefaults.standard.set(points!, forKey: "myPoints")
                            soundEffect(name: "game_win")
                            self.performSegue(withIdentifier: "RewardsToPoints", sender: self)
                        }
                    }
                    alert.addAction(cancel)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "Add to Reward", message: "How much do you want to add to " + premiumRewards![indexPath.row] + "?", preferredStyle: .alert)
                    alert.addTextField { (rewardsTF) in
                        rewardsTF.text = ""
                        rewardsTF.maxLength = 5
                        rewardsTF.keyboardType = UIKeyboardType.decimalPad
                    }
                    let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
                        return
                    }
                    let action = UIAlertAction(title: "Redeem", style: .default) { (_) in
                        let text = alert.textFields?.first?.text
                        let amount = Int(text!)
                        let premiumReward = premiumRewards![indexPath.row]
                        if (amount! > premiumRewardsDict![premiumReward]!) {
                            //tell user the amount is more than reward cost
                            let errorAlert = UIAlertController(title: "Invalid reward cost", message: "The input cost is more than the premium reward cost.", preferredStyle: .alert)
                            let cancel = UIAlertAction(title: "Got it", style: .default) { (_) in
                                return
                            }
                            errorAlert.addAction(cancel)
                            self.present(errorAlert, animated: true)
                            soundEffect(name: "selection_deny")
                            print("too much moolah")
                        } else if (amount! <= 0) {
                            //tell the user the amount has to be > 0
                            let errorAlert = UIAlertController(title: "Invalid reward cost", message: "The cost must be greater than zero.", preferredStyle: .alert)
                            let cancel = UIAlertAction(title: "Got it", style: .default) { (_) in
                                return
                            }
                            errorAlert.addAction(cancel)
                            self.present(errorAlert, animated: true)
                            soundEffect(name: "selection_deny")
                        } else if (amount! > points!) {
                            //tell the user the amount is more than the current points
                            let errorAlert = UIAlertController(title: "Not enough points", message: "You do not have enough points to complete this action.", preferredStyle: .alert)
                            let cancel = UIAlertAction(title: "Got it", style: .default) { (_) in
                                return
                            }
                            errorAlert.addAction(cancel)
                            self.present(errorAlert, animated: true)
                            soundEffect(name: "selection_deny")
                        } else {
                            premiumRewardsDict![premiumReward] = premiumRewardsDict![premiumReward]! - amount!
                            UserDefaults.standard.set(premiumRewardsDict, forKey: "myPremiumRewardsDict")
                            points! = points! - amount!
                            UserDefaults.standard.set(points!, forKey: "myPoints")
                            if (premiumRewardsDict![premiumReward]! == 0) {
                                addHistory(hist: premiumReward)
                                deletePremiumReward(premiumReward: premiumReward)
                                self.myRewards.deleteRows(at: [indexPath], with: .right)
                                soundEffect(name: "game_win")
                            } else {
                                soundEffect(name: "button_blip")
                                self.myRewards.reloadData()
                            }
                        }
                    }
                    alert.addAction(cancel)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
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
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: fetchColorCode()!)
        navigationBar.barTintColor = UIColor(hex: fetchColorCode()!)
        rewardType.tintColor = UIColor(hex: fetchColorCode()!)
        addButton.backgroundColor = UIColor(hex: fetchColorCode()!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let name = rewardName.text
        let cost = Int(rewardCost.text!)
        let type = rewardType.titleForSegment(at: rewardType.selectedSegmentIndex)
        if (type == "Reward") {
            if (name != nil && cost != nil) {
                if (!rewards!.contains(name!)) {
                    addReward(reward: name!, value: cost!)
                    self.performSegue(withIdentifier: "AddToRewards", sender: self)
                } else {
                    let alert = UIAlertController(title: "Cannot add reward", message: "Reward already exists!", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Got it", style: .default) { (_) in
                        return
                    }
                    alert.addAction(cancel)
                    present(alert, animated: true)
                    soundEffect(name: "selection_deny")
                }
            } else {
                let alert = UIAlertController(title: "Cannot add reward", message: "Reward must have a name and a value", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Got it", style: .default) { (_) in
                    return
                }
                alert.addAction(cancel)
                present(alert, animated: true)
                soundEffect(name: "selection_deny")
            }
        } else {
            if (name != nil && cost != nil){
                if (!premiumRewards!.contains(name!)) {
                    addPremiumReward(premiumReward: name!, value: cost!)
                    self.performSegue(withIdentifier: "AddToRewards", sender: self)
                } else {
                    let alert = UIAlertController(title: "Cannot add reward", message: "Premium reward already exists!", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Got it", style: .default) { (_) in
                        return
                    }
                    alert.addAction(cancel)
                    present(alert, animated: true)
                    soundEffect(name: "selection_deny")
                }
            } else {
                let alert = UIAlertController(title: "Cannot add reward", message: "Reward must have a name and a value", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Got it", style: .default) { (_) in
                    return
                }
                alert.addAction(cancel)
                present(alert, animated: true)
                soundEffect(name: "selection_deny")
            }
        }
    }
    
}

//custom reward controller
class CustomRewardViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var myReward: UITextField!
    @IBOutlet weak var myCost: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var redeemButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: fetchColorCode()!)
        navigationBar.barTintColor = UIColor(hex: fetchColorCode()!)
        redeemButton.backgroundColor = UIColor(hex: fetchColorCode()!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func redeemTapped(_ sender: Any) {
        let reward = myReward.text
        let cost = Int(myCost.text!)!
        
        if points! < cost {
            let alert = UIAlertController(title: "Not enough points", message: "You must have at least " + String(cost) + " points to redeem this reward.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Got it", style: .default) { (_) in
                return
            }
            alert.addAction(cancel)
            present(alert, animated: true)
            soundEffect(name: "selection_deny")
        } else {
            addHistory(hist: reward!)
            points! = points! - cost
            UserDefaults.standard.set(points!, forKey: "myPoints")
            print("reward used: " + reward! + " with value " + String(cost))
            self.performSegue(withIdentifier: "CustomRewardToPoints", sender: self)
        }
    }
    
}
