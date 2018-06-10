//
//  SettingsTableViewController.swift
//  TaskTime
//
//  Created by Whip Master on 5/11/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit
import AVFoundation

//sound functions
var backgroundMusicOn:Bool?
var backgroundMusic: AVAudioPlayer?
var soundEffectOn: Bool?
var soundEffect: AVAudioPlayer?
let playlist = ["above_the_clouds", "banana_tree", "comfort_blanket", "pleasure_drive", "yellow_cafe"]

func fetchBackgroundMusicVal() -> Bool? {
    return UserDefaults.standard.bool(forKey: "backgroundMusicOn")
}

func saveBackgroundMusicVal(isOn: Bool) {
    UserDefaults.standard.set(isOn, forKey: "backgroundMusicOnOn")
}

func fetchSoundEffectVal() -> Bool? {
    return UserDefaults.standard.bool(forKey: "soundEffectOn")
}

func saveSoundEffectVal(isOn: Bool) {
    UserDefaults.standard.set(isOn, forKey: "soundEffectOn")
}

func backgroundMusicToOn() {
    //let index = Int(arc4random_uniform(5))
    //let songName = playlist[index]
    let songName = "yellow_cafe"
    let musicPath = Bundle.main.path(forResource: "Sounds/Background Music/" + songName, ofType: ".mp3")
    let url = URL(fileURLWithPath: musicPath!)
    if (backgroundMusicOn!) {
        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: url)
            backgroundMusic?.numberOfLoops = -1
            backgroundMusic?.play()
            print(songName + " being played")
        } catch {
            print("music could not load")
        }
    }
}

func backgroundMusicToOff() {
    backgroundMusic?.stop()
}

func soundEffect(name: String) {
    let soundPath = Bundle.main.path(forResource: "Sounds/Sound Effects/" + name, ofType: ".mp3")
    let url = URL(fileURLWithPath: soundPath!)
    if (soundEffectOn!) {
        do {
            soundEffect = try AVAudioPlayer(contentsOf: url)
            soundEffect?.play()
            print(name + " being played")
        } catch {
            print("sound effect could not load")
        }
    }
}

//color functions
var color:String?
var colorCodes = [
    "Sacramento Green": "#043927",
    "Hunter Green": "#3f704d",
    "Forest Green": "#0b6623",
    "Pine Green": "#01796F",
    "Jade Green": "#00A86B",
    "Teal": "#008081",
    "Space Blue": "#1D2951",
    "Prussian Blue": "#003152",
    "Royal Blue": "#111E6C",
    "Navy Blue": "#000080",
    "Yale Blue": "#0E4D92",
    "Egyptian Blue": "#1034A6",
    "Sapphire Blue": "#0F52BA",
    "Steel Blue": "#468284",
    "Baby Blue": "#89CFF0",
    "Sky Blue": "#95C8D8"
]

func fetchColorVal() -> String? {
    return UserDefaults.standard.string(forKey: "colorName")
}

func saveColorVal(name: String) {
    UserDefaults.standard.set(name, forKey: "colorName")
}

func fetchColorCode() -> String? {
    if fetchColorVal() != nil {
        return colorCodes[fetchColorVal()!]
    } else {
        return colorCodes["Pine Green"]
    }
}

class SettingsViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: fetchColorCode()!)
        navigationBar.barTintColor = UIColor(hex: fetchColorCode()!)    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

class SettingsTableViewController: UITableViewController {
    
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
    
    // MARK: Properties
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: fetchColorCode()!)
        navigationBar.barTintColor = UIColor(hex: fetchColorCode()!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class CustomizeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: Properties
    @IBOutlet weak var pointStepper: UIStepper!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var backgroundMusicSwitch: UISwitch!
    @IBOutlet weak var soundEffectsSwitch: UISwitch!
    @IBOutlet weak var navigationBar: UINavigationBar!
    let colors = ["Sacramento Green", "Hunter Green", "Forest Green", "Pine Green", "Jade Green", "Teal", "Space Blue", "Prussian Blue", "Royal Blue", "Navy Blue", "Yale Blue", "Egyptian Blue", "Sapphire Blue", "Steel Blue", "Baby Blue", "Sky Blue"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: fetchColorCode()!)
        navigationBar.barTintColor = UIColor(hex: fetchColorCode()!)
        
        pointLabel.text = "$" + String(pointVal!)
        pointStepper.value = Double(pointVal!)
        
        pickerView.delegate = self
        pickerView.selectRow(colors.index(of: color!)!, inComponent: 0, animated: true)
        
        backgroundMusicSwitch.setOn(!backgroundMusicOn!, animated: true)
        soundEffectsSwitch.setOn(!soundEffectOn!, animated: true)
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
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        color = colors[row]
        saveColorVal(name: colors[row])
        navigationBar.barTintColor = UIColor(hex: fetchColorCode()!)
    }
    
    @IBAction func backgroundMusicChanged(_ sender: Any) {
        backgroundMusicOn = backgroundMusicSwitch.isOn
        saveBackgroundMusicVal(isOn: backgroundMusicOn!)
        if (backgroundMusicOn!) {
            backgroundMusicToOn()
        } else {
            backgroundMusicToOff()
        }
    }
    
    @IBAction func soundEffectsChanged(_ sender: Any) {
        soundEffectOn = soundEffectsSwitch.isOn
        saveSoundEffectVal(isOn: soundEffectOn!)
    }
    
}
