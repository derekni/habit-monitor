//
//  ViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/2/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit
import AVFoundation

//points
var points:Int?

func savePointsData(points:Int?) {
    UserDefaults.standard.set(points, forKey: "myPoints")
}

func fetchPointsData() -> Int? {
    if let point = UserDefaults.standard.integer(forKey: "myPoints") as? Int {
        return point
    } else {
        return 0
    }
}

//points controller
class PointsViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(hex: fetchColorCode()!)
        
        label.text = String(points!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



