//
//  SettingsTableViewController.swift
//  TaskTime
//
//  Created by Whip Master on 5/11/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit

//sound functions
var sound:Bool?

func fetchSoundVal() -> Bool? {
    return UserDefaults.standard.bool(forKey: "isSoundOn")
}

func saveSoundVal(isOn: Bool) {
    UserDefaults.standard.set(isOn, forKey: "isSoundOn")
}

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

class SettingsTableViewController: UITableViewController {

    // MARK: Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().isTranslucent = false

        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "Resetting your app cannot be undone.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
            return
        }
        alert.addAction(cancel)
        let agree = UIAlertAction(title: "I'm sure", style: .default) { (_) in
            self.resetApp()
        }
        alert.addAction(agree)
        present(alert, animated: true)
    }
    
    func resetApp() {
        points = 0
        savePointsData(points: points)
        tasks = []
        saveTaskData(tasks: tasks)
        habits = []
        saveHabitsData(habits: habits)
        reminders = []
        saveReminderData(reminders: reminders)
        rewards = []
        saveRewardsData(rewards: rewards)
        rewardsDict = [:]
        saveRewardsDictData(rewardsDict: rewardsDict)
        premiumRewards = ["Purchase"]
        savePremiumRewardsData(premiumRewards: premiumRewards)
        premiumRewardsDict = ["Purchase":0]
        savePremiumRewardsDictData(premiumRewardsDict: premiumRewardsDict)
        history = []
        saveHistoryData(history: history)
        savings = 0
        saveSavingsData(savings: savings)
        resolutions = []
        saveResolutionData(resolutions: resolutions)
        self.performSegue(withIdentifier: "SettingsToPoints", sender: self)
    }
    
}

class AboutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

class CustomizeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: Properties
    @IBOutlet weak var pointStepper: UIStepper!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var soundSwitch: UISwitch!
    let colors = ["Hunter Green", "Forest Green", "Pine Green", "Jade Green"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pointLabel.text = "$" + String(pointVal!)
        pointStepper.value = Double(pointVal!)
        
        pickerView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func pointValueChanged(_ sender: Any) {
        pointVal = Int(pointStepper.value)
        savePointVal(pointVal: pointVal)
        pointLabel.text = "$" + String(pointVal!)
        print(pointVal)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //row selected in pickerView
    }
    
    @IBAction func soundChanged(_ sender: Any) {
        sound = soundSwitch.isOn
        saveSoundVal(isOn: soundSwitch.isOn)
        print(sound)
    }
    
}
