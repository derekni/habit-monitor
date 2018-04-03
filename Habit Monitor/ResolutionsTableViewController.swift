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

func deleteResolution(deletedResolution: String) {
    if let index = resolutions?.index(of: deletedResolution) {
        resolutions!.remove(at: index)
    } else {
        print("nothing was deleted")
    }
    UserDefaults.standard.set(resolutions, forKey: "myResolutions")
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
    
    func tableView(_ myResolutions: UITableView, commit commitEditingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if commitEditingStyle == .delete {
            deleteResolution(deletedResolution: String(describing: resolutions![indexPath.row]))
            myResolutions.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
}

//add resolution controller
class AddResolutionViewController: UIViewController {
    
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
    
    @IBAction func addPressed(_ sender: Any) {
        if (textField.text != nil) && textField.text != "" {
            resolutions!.append(textField.text!)
            UserDefaults.standard.set(resolutions, forKey: "myResolutions")
        }
    }
    
}
