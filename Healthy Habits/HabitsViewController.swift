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
var doneHabits:[String]?

func saveHabitsData(habits:[String]?) {
    UserDefaults.standard.set(habits, forKey: "myHabits")
}

func saveDoneHabitsData(doneHabits:[String]?) {
    UserDefaults.standard.set(doneHabits, forKey: "myDoneHabits")
}

func fetchHabitsData() -> [String]? {
    if let habit = UserDefaults.standard.array(forKey: "myHabits") as? [String] {
        return habit
    } else {
        return nil
    }
}

func fetchDoneHabitsData() -> [String]? {
    if let done = UserDefaults.standard.array(forKey: "myDoneHabits") as? [String] {
        return done
    } else {
        return nil
    }
}

func addDoneHabit(habit: String) {
    if habit != "" {
        doneHabits!.append(habit)
        UserDefaults.standard.set(doneHabits, forKey: "myDoneHabits")
    }
}

func addHabit(habit: String) {
    if habit != "" {
        habits!.append(habit)
        UserDefaults.standard.set(habits!, forKey: "myHabits")
    }
}

func deleteHabit(deletedHabit: String) {
    if let index = habits?.index(of: deletedHabit) {
        habits!.remove(at: index)
    } else {
        print("nothing was deleted")
    }
    UserDefaults.standard.set(habits, forKey: "myHabits")
}

func clearDoneHabits () {
    saveDoneHabitsData(doneHabits: [])
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
class HabitsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    @IBOutlet weak var myHabits: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myHabits.delegate = self
        myHabits.dataSource = self

        myHabits.tableFooterView = UIView(frame: .zero)
        myHabits.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: myHabits.frame.size.width, height: 1))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in myHabits: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ myHabits: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits!.count
    }
    
    func tableView(_ myHabits: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myHabits.dequeueReusableCell(withIdentifier: "HabitsTableViewCell", for: indexPath) as? HabitsTableViewCell else {
            fatalError("This cell is not an HabitsTableViewCell")
        }
        cell.myHabit.text = habits![indexPath.row]
        if doneHabits!.contains(habits![indexPath.row]) {
            cell.isUserInteractionEnabled = false
            cell.myHabit.isEnabled = false
        }
        return cell
    }
    
    func tableView(_ myHabits: UITableView, didSelectRowAt indexPath: IndexPath) {
        let habit = habits![indexPath.row]
        addHistory(hist: habit)
        points! = points! + 1
        UserDefaults.standard.set(points!, forKey: "myPoints")
        addDoneHabit(habit: habit)
        myHabits.reloadData()
    }
    
    func tableView(_ myHabits: UITableView, commit commitEditingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if commitEditingStyle == .delete {
            deleteHabit(deletedHabit: String(describing: habits![indexPath.row]))
            myHabits.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
    }
    
    @IBAction func composeTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Habit", message: nil, preferredStyle: .alert)
        alert.addTextField { (habitTF) in
            habitTF.placeholder = "Enter Habit"
            habitTF.maxLength = 20
            //habitTF.borderStyle = .roundedRect
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
            return
        }
        let action = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let habit = alert.textFields?.first?.text else { return }
            self.add(habit: habit)
        }
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func add(habit: String) {
        if (habit != "") {
            addHabit(habit: habit)
            myHabits.insertRows(at: [IndexPath(row: habits!.count - 1, section: 0)], with: .automatic)
        }
    }
    
}
