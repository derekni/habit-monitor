//
//  CustomRewardViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/28/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit

class CustomRewardViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var myReward: UITextField!
    @IBOutlet weak var myCost: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func redeemPressed(_ sender: Any) {
        let reward = myReward.text
        let cost = Int(myCost.text!)
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
