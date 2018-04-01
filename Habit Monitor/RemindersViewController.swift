//
//  RemindersViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/15/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit

//reminders
var reminders:[String]?

func saveReminderData(reminders:[String]?) {
    UserDefaults.standard.set(reminders, forKey: "reminders")
}

func fetchReminderData() -> [String]? {
    if let reminder = UserDefaults.standard.array(forKey: "reminders") as? [String] {
        return reminder
    } else {
        return nil
    }
}

func deleteReminderData(completedReminder: String) {
    if let index = reminders?.index(of: completedReminder) {
        reminders!.remove(at: index)
    } else {
        print("nothing was deleted")
    }
    UserDefaults.standard.set(reminders, forKey: "reminders")
}

//reminders cell
class RemindersTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var myReminder: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//reminders controller
class RemindersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    @IBOutlet weak var reminderTable: UITableView!
    let cellIdentifier = "RemindersTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        reminderTable.delegate = self
        reminderTable.dataSource = self
        
        reminderTable.tableFooterView = UIView(frame: .zero)
        reminderTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: reminderTable.frame.size.width, height: 1))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reminderTable.reloadData()
    }
    
    func numberOfSections(in reminderTable: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ reminderTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders!.count
    }
    
    func tableView(_ reminderTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = reminderTable.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RemindersTableViewCell else {
            fatalError("This cell is not an ReminderTableViewCell")
        }
        cell.myReminder.text = reminders![indexPath.row]
        return cell
    }
    
    func tableView(_ reminderTable: UITableView, didSelectRowAt indexPath: IndexPath) {
        deleteReminderData(completedReminder: String(describing: reminders![indexPath.row]))
        reminderTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.right)
    }

}

//add reminders controller
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
            UserDefaults.standard.set(reminders, forKey: "reminders")
        }
    }
    
}
