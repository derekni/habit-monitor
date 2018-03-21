//
//  ViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/2/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit

class PointsViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        label.text = String(points!)
        // forest self.view.backgroundColor = UIColor(red: 11/255, green: 102/255, blue: 35/255, alpha: 1)
        // pine self.view.backgroundColor = UIColor(red: 1/255, green: 121/255, blue: 111/255, alpha: 1)
        // sage self.view.backgroundColor = UIColor(red: 157/255, green: 193/255, blue: 131/255, alpha: 1)
        //navigationItem.hidesBackButton = true
        //navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}



