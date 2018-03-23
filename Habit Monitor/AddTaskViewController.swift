//
//  AddViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/12/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var textField: UITextField!
    
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
        if (textField.text != nil) && textField.text != "" {
            tasks!.append(textField.text!)
            UserDefaults.standard.set(tasks, forKey: "tasks")
        }
    }

}
