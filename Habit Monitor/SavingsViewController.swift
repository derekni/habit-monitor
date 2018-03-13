//
//  SavingsViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/13/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit

class SavingsViewController: UIViewController {

    @IBOutlet weak var savedLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        savedLabel.text = String(savings!)
        // forest self.view.backgroundColor = UIColor(red: 11/255, green: 102/255, blue: 35/255, alpha: 1)
        // pine self.view.backgroundColor = UIColor(red: 1/255, green: 121/255, blue: 111/255, alpha: 1)
        // sage self.view.backgroundColor = UIColor(red: 157/255, green: 193/255, blue: 131/255, alpha: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func addSavings(_ sender: Any) {
        points = points! - 1
        savings = savings! + 1
        UserDefaults.standard.set(savings, forKey:"mySavings")
        UserDefaults.standard.set(points, forKey:"myPoints")
        savedLabel.text = String(savings!)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
