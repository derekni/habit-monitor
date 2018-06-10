//
//  HabitsTableViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/15/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit
import AVFoundation

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
    @IBOutlet weak var myTitle: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: fetchColorCode()!)
        navigationBar.barTintColor = UIColor(hex: fetchColorCode()!)
        
        myHabits.delegate = self
        myHabits.dataSource = self

        myHabits.tableFooterView = UIView(frame: .zero)
        myHabits.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: myHabits.frame.size.width, height: 1))
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(HabitsViewController.longPress))
        myTitle.addGestureRecognizer(longPress)
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
            cell.myHabit.isEnabled = false
        } else {
            cell.myHabit.isEnabled = true
        }
        return cell
    }
    
    func tableView(_ myHabits: UITableView, didSelectRowAt indexPath: IndexPath) {
        let habit = habits![indexPath.row]
        if (!doneHabits!.contains(habit)) {
            addHistory(hist: habit)
            points! = points! + 1
            UserDefaults.standard.set(points!, forKey: "myPoints")
            addDoneHabit(habit: habit)
            myHabits.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit", handler:{action, indexpath in
            let alert = UIAlertController(title: "Edit Habit", message: nil, preferredStyle: .alert)
            alert.addTextField { (habitsTF) in
                habitsTF.text = habits![indexPath.row]
                habitsTF.maxLength = 25
            }
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
                return
            }
            let action = UIAlertAction(title: "Edit", style: .default) { (_) in
                guard let habit = alert.textFields?.first?.text else { return }
                habits![indexPath.row] = habit
                saveHabitsData(habits: habits)
                tableView.reloadData()
            }
            alert.addAction(cancel)
            alert.addAction(action)
            self.present(alert, animated: true)
        });
        editRowAction.backgroundColor = UIColor.lightGray;
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            deleteHabit(deletedHabit: String(describing: habits![indexPath.row]))
            self.myHabits.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        });
        
        return [deleteRowAction, editRowAction];
    }
    
    func tableView(_ myHabits: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if (myHabits.isEditing == true) {
            return UITableViewCellEditingStyle.none
        } else {
            return UITableViewCellEditingStyle.delete
        }
    }
    
    func tableView(_ myHabits: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ myHabits: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ myHabits: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        habits!.insert(habits!.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
        saveHabitsData(habits: habits)
        myHabits.reloadData()
        soundEffect(name: "lip_sound")
    }
    
    @objc func longPress(press: UILongPressGestureRecognizer) {
        if (press.state == UIGestureRecognizerState.began) {
            if (myHabits.isEditing == true) {
                myHabits.setEditing(false, animated: true)
            } else {
                myHabits.setEditing(true, animated: true)
            }
        }
    }
    
    @IBAction func composeTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Habit", message: nil, preferredStyle: .alert)
        alert.addTextField { (habitTF) in
            habitTF.placeholder = "Enter Habit"
            habitTF.maxLength = 25
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
        if (habit != "" && !habits!.contains(habit)) {
            addHabit(habit: habit)
            myHabits.insertRows(at: [IndexPath(row: habits!.count - 1, section: 0)], with: .automatic)
        } else {
            let alert = UIAlertController(title: "Cannot add habit", message: "Habit already exists!", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Got it", style: .default) { (_) in
                return
            }
            alert.addAction(cancel)
            present(alert, animated: true)
            soundEffect(name: "selection_deny")
        }
    }
    
}
