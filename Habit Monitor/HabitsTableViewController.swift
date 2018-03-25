//
//  HabitsTableViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/15/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit

//habits
var habits:[String]?

func saveHabitsData(habits:[String]?) {
    UserDefaults.standard.set(habits, forKey: "myHabits")
}

func fetchHabitsData() -> [String]? {
    if let habit = UserDefaults.standard.array(forKey: "myHabits") as? [String] {
        return habit
    } else {
        return nil
    }
}

func addHabit(habit: String) {
    if habit != "" {
        habits!.append(habit)
        UserDefaults.standard.set(habits!, forKey: "myHabits")
    }
}

//habits cell
class HabitsTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var myHabit: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//habits controller
class HabitsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HabitsTableViewCell", for: indexPath) as? HabitsTableViewCell else {
            fatalError("This cell is not an HabitsTableViewCell")
        }
        cell.myHabit.text = habits![indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let habit = habits![indexPath.row]
        addHistory(hist: habit)
        points! = points! + 1
        UserDefaults.standard.set(points!, forKey: "myPoints")
        self.performSegue(withIdentifier: "HabitsToPoints", sender: self)
    }
}
