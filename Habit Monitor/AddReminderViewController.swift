//
//  AddReminderViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/15/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit

class AddReminderViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var newReminder: UITextField!
    
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
        if (newReminder.text != nil) && newReminder.text != "" {
            reminders!.append(newReminder.text!)
            newReminder.text = ""
            newReminder.placeholder = "Add more?"
            UserDefaults.standard.set(reminders, forKey: "reminders")
        }
    }

}
