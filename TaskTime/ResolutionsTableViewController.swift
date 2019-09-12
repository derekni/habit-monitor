//
//  ResolutionsTableViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/22/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit
import AVFoundation

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
class ResolutionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var myResolutions: UITableView!
    @IBOutlet weak var myTitle: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: fetchColorCode()!)
        navigationBar.barTintColor = UIColor(hex: fetchColorCode()!)
        
        myResolutions.delegate = self
        myResolutions.dataSource = self
        
        myResolutions.tableFooterView = UIView(frame: .zero)
        myResolutions.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: myResolutions.frame.size.width, height: 1))
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ResolutionsViewController.longPress))
        myTitle.addGestureRecognizer(longPress)
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

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit", handler:{action, indexpath in
            let alert = UIAlertController(title: "Edit Resolution", message: nil, preferredStyle: .alert)
            alert.addTextField { (resolutionTF) in
                resolutionTF.text = resolutions![indexPath.row]
                resolutionTF.maxLength = 25
            }
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
                return
            }
            let action = UIAlertAction(title: "Edit", style: .default) { (_) in
                guard let resolution = alert.textFields?.first?.text else { return }
                resolutions![indexPath.row] = resolution
                saveResolutionData(resolutions: resolutions)
                tableView.reloadData()
            }
            alert.addAction(cancel)
            alert.addAction(action)
            self.present(alert, animated: true)
        });
        editRowAction.backgroundColor = UIColor.lightGray;
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            deleteResolution(deletedResolution: String(describing: resolutions![indexPath.row]))
            self.myResolutions.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        });
        
        return [deleteRowAction, editRowAction];
    }

    func tableView(_ myResolutions: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ myResolutions: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if (myResolutions.isEditing == true) {
            return UITableViewCellEditingStyle.none
        } else {
            return UITableViewCellEditingStyle.delete
        }
    }
 
    func tableView(_ myResolutions: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
 
    func tableView(_ myResolutions: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        resolutions!.insert(resolutions!.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
        saveResolutionData(resolutions: resolutions)
        myResolutions.reloadData()
        soundEffect(name: "lip_sound")
    }
    
    @objc func longPress(press: UILongPressGestureRecognizer) {
        if (press.state == UIGestureRecognizerState.began){
            if (myResolutions.isEditing) {
                myResolutions.setEditing(false, animated: true)
            } else {
                myResolutions.setEditing(true, animated: true)
            }
        }
    }
 
    @IBAction func composeTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Resolution", message: nil, preferredStyle: .alert)
        alert.addTextField { (resolutionTF) in
            resolutionTF.placeholder = "Enter Resolution"
            resolutionTF.maxLength = 25
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
            return
        }
        let action = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let resolution = alert.textFields?.first?.text else { return }
            self.add(resolution: resolution)
        }
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func add(resolution: String) {
        if (resolution != "" && !resolutions!.contains(resolution)) {
            resolutions!.append(resolution)
            UserDefaults.standard.set(resolutions, forKey: "myResolutions")
            myResolutions.insertRows(at: [IndexPath(row: resolutions!.count - 1, section: 0)], with: .automatic)
        } else {
            let alert = UIAlertController(title: "Cannot add resolution", message: "Resolution already exists!", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Got it", style: .default) { (_) in
                return
            }
            alert.addAction(cancel)
            present(alert, animated: true)
            soundEffect(name: "selection_deny")
        }
    }
    
}
