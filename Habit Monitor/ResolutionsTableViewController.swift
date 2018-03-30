//
//  ResolutionsTableViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/22/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit

//resolutions
var resolutions:[String]?

func saveResolutionData(resolutions:[String]?) {
    UserDefaults.standard.set(resolutions, forKey: "myResolutions")
}

func fetchResolutionData() -> [String]? {
    if let resolution = UserDefaults.standard.array(forKey: "myResolutions") as? [String] {
        return resolution
    } else {
        return nil
    }
}

//resolutions cell
class ResolutionsTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var myResolution: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class ResolutionsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
        return resolutions!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResolutionsTableViewCell", for: indexPath) as? ResolutionsTableViewCell else {
            fatalError("Cell is not a ResolutionsTableViewCell")
        }

        cell.myResolution.text = resolutions![indexPath.row]
        
        return cell
    }

}

//resolution controller
class ResolutionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var myResolutions: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myResolutions.delegate = self
        myResolutions.dataSource = self
        
        myResolutions.tableFooterView = UIView(frame: .zero)
        myResolutions.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: myResolutions.frame.size.width, height: 1))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func numberOfSections(in myResolutions: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ myResolutions: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resolutions!.count
    }
    
    func tableView(_ myResolutions: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myResolutions.dequeueReusableCell(withIdentifier: "ResolutionsTableViewCell", for: indexPath) as? ResolutionsTableViewCell else {
            fatalError("Cell is not a ResolutionsTableViewCell")
        }
        
        cell.myResolution.text = resolutions![indexPath.row]
        
        return cell
    }
    
}
