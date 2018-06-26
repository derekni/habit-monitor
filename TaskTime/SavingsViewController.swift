//
//  SavingsViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/13/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit
import AVFoundation

//savings
var savings:Int?

func saveSavingsData(savings:Int?) {
    UserDefaults.standard.set(savings, forKey: "mySavings")
}

func fetchSavingsData() -> Int? {
    if let saving = UserDefaults.standard.integer(forKey: "mySavings") as? Int {
        return saving
    } else {
        return 0
    }
}

//savings controller
class SavingsViewController: UIViewController {

    @IBOutlet weak var savedLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: fetchColorCode()!)
        self.view.backgroundColor = UIColor(hex: fetchColorCode()!)
        
        savedLabel.text = String(savings!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func addSavings(_ sender: Any) {
        if (points! > 0) {
            points! = points! - 1
            savings! = savings! + 1
            UserDefaults.standard.set(savings!, forKey:"mySavings")
            UserDefaults.standard.set(points!, forKey:"myPoints")
            soundEffect(name: "coin_drop")
        } else {
            print("not enough points to add to savings")
        }
        savedLabel.text = String(savings!)
    }

    @IBAction func openSavings(_ sender: Any) {
        if (getCurrentDate() - fetchSavingsDateData()! > 00000300) {
            let alert = UIAlertController(title: "Are you sure?", message: "You can only open your savings once every three months.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
                return
            }
            let action = UIAlertAction(title: "Open", style: .default) { (_) in
                points = points! + savings!
                savePointsData(points: points!)
                savings = 0
                saveSavingsData(savings: savings!)
                saveSavingsDateData(date: getCurrentDate())
                soundEffect(name: "bottle_smash")
                addHistory(hist: "Opened savings")
                self.performSegue(withIdentifier: "SavingsToPoints", sender: self)
            }
            alert.addAction(cancel)
            alert.addAction(action)
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Cannot open savings", message: "You must wait three months in between opening savings.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Got it", style: .default) { (_) in
                return
            }
            alert.addAction(cancel)
            present(alert, animated: true)
            soundEffect(name: "selection_deny")
        }
    }
    
}
