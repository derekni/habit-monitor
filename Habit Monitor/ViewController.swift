//
//  ViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/2/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    var points = UserDefaults().integer(forKey: "myPoints");
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        label.text = String(points)
        // forest self.view.backgroundColor = UIColor(red: 11/255, green: 102/255, blue: 35/255, alpha: 1)
        // pine self.view.backgroundColor = UIColor(red: 1/255, green: 121/255, blue: 111/255, alpha: 1)
        // sage self.view.backgroundColor = UIColor(red: 157/255, green: 193/255, blue: 131/255, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Actions
    @IBAction func subtractPoints(_ sender: UIButton) {
        points = points - 1
        UserDefaults.standard.set(points, forKey: "myPoints")
        label.text = String(points)
    }
    
    @IBAction func addPoints(_ sender: UIButton) {
        points = points + 1
        UserDefaults.standard.set(points, forKey: "myPoints")
        label.text = String(points)
    }

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}



