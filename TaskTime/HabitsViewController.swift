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
var habits:[Habit]?
var doneHabits:[Habit]?

class Habit: NSObject, NSCoding {
    
    var name: String
    var pointVal: Int
    
    init(name: String, pointVal: Int) {
        self.name = name
        self.pointVal = pointVal
    }
    
    static func ==(lhs: Habit, rhs: Habit) -> Bool {
        return lhs.name == rhs.name && lhs.pointVal == rhs.pointVal
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(pointVal, forKey: "pointVal")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let pointVal = aDecoder.decodeInteger(forKey: "pointVal")
        self.init(name: name, pointVal: pointVal)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? Habit {
            return name == object.name
        } else {
            return false
        }
    }
}

func saveHabitsData(habits:[Habit]?) {
    let habitsData: Data = NSKeyedArchiver.archivedData(withRootObject: habits!)
    UserDefaults.standard.set(habitsData, forKey: "myHabits")
}

func saveDoneHabitsData(doneHabits:[Habit]?) {
    let habitsData: Data = NSKeyedArchiver.archivedData(withRootObject: doneHabits!)
    UserDefaults.standard.set(habitsData, forKey: "myDoneHabits")
}

func fetchHabitsData() -> [Habit]? {
    let decoded = UserDefaults.standard.data(forKey: "myHabits")
    let decodedHabits = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [Habit]
    return decodedHabits
}

func fetchDoneHabitsData() -> [Habit]? {
    let decoded = UserDefaults.standard.data(forKey: "myDoneHabits")
    let decodedDoneHabits = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [Habit]
    return decodedDoneHabits
}

func addDoneHabit(habit: Habit) {
    if habit.name != "" {
        doneHabits!.append(habit)
        saveDoneHabitsData(doneHabits: doneHabits!)
    }
}

func addHabit(habit: Habit) {
    if habit.name != "" {
        habits!.append(habit)
        saveHabitsData(habits: habits)
    }
}

func deleteHabit(deletedHabit: Habit) {
    if let index = habits?.index(of: deletedHabit) {
        habits!.remove(at: index)
    } else {
        print("nothing was deleted")
    }
    saveHabitsData(habits: habits)
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
        cell.myHabit.text = habits![indexPath.row].name
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
            let alert = UIAlertController(title: "Complete Task", message: "Would you like to complete the habit " + habits![indexPath.row].name + " for " + String(habits![indexPath.row].pointVal) + " points?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
                return
            }
            let action = UIAlertAction(title: "Complete", style: .default) { (_) in
                let habit = habits![indexPath.row]
                addHistory(hist: habit.name)
                points! = points! + habit.pointVal
                UserDefaults.standard.set(points!, forKey: "myPoints")
                addDoneHabit(habit: habit)
                myHabits.reloadData()
                soundEffect(name: "closing_effect_sound")
            }
            alert.addAction(cancel)
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit", handler:{action, indexpath in
            let alert = UIAlertController(title: "Edit Habit", message: nil, preferredStyle: .alert)
            alert.addTextField { (habitsTF) in
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 46, height: 20))
                label.text = "Name:"
                label.backgroundColor = UIColor.white
                label.font = UIFont.boldSystemFont(ofSize: 14)
                habitsTF.leftViewMode = UITextFieldViewMode.always
                habitsTF.leftView = label
                habitsTF.text = habits![indexPath.row].name
                habitsTF.maxLength = 25
            }
            alert.addTextField { (pointsTF) in
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 81, height: 20))
                label.text = "Point value:"
                label.backgroundColor = UIColor.white
                label.font = UIFont.boldSystemFont(ofSize: 14)
                pointsTF.leftViewMode = UITextFieldViewMode.always
                pointsTF.leftView = label
                pointsTF.keyboardType = .numberPad
                pointsTF.text = String(habits![indexPath.row].pointVal)
                pointsTF.maxLength = 2
            }
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
                return
            }
            let action = UIAlertAction(title: "Edit", style: .default) { (_) in
                guard let habit = alert.textFields?[0].text else { return }
                guard let pointVal = alert.textFields?[1].text else { return }
                habits![indexPath.row].name = habit
                habits![indexPath.row].pointVal = Int(pointVal)!
                saveHabitsData(habits: habits)
                tableView.reloadData()
            }
            alert.addAction(cancel)
            alert.addAction(action)
            self.present(alert, animated: true)
        });
        editRowAction.backgroundColor = UIColor.lightGray;
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            deleteHabit(deletedHabit: habits![indexPath.row])
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
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 46, height: 20))
            label.text = "Name:"
            label.backgroundColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 14)
            habitTF.leftViewMode = UITextFieldViewMode.always
            habitTF.leftView = label
            habitTF.placeholder = "Enter Habit"
            habitTF.maxLength = 25
        }
        alert.addTextField { (pointsTF) in
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 81, height: 20))
            label.text = "Point value:"
            label.backgroundColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 14)
            pointsTF.leftViewMode = UITextFieldViewMode.always
            pointsTF.leftView = label
            pointsTF.keyboardType = .numberPad
            pointsTF.placeholder = "Enter point value"
            pointsTF.maxLength = 2
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
            return
        }
        let action = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let habit = alert.textFields?[0].text else { return }
            guard let pointVal = alert.textFields?[1].text else { return }
            let newHabit = Habit(name: habit, pointVal: Int(pointVal)!)
            self.add(habit: newHabit)
        }
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func add(habit: Habit) {
        if (habit.name != "" && !habits!.contains(habit)) {
            addHabit(habit: habit)
            myHabits.insertRows(at: [IndexPath(row: habits!.count - 1, section: 0)], with: .automatic)
            soundEffect(name: "office_pencil_scribble_out_on_paper")
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
