//
//  TasksViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/11/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit
import Contacts
import MobileCoreServices
import AVFoundation

//tasks
var tasks:[Task]?

class Task: NSObject, NSCoding {
    
    var name: String
    var pointVal: Int
    
    init(name: String, pointVal: Int) {
        self.name = name
        self.pointVal = pointVal
    }
    
    static func ==(lhs: Task, rhs: Task) -> Bool {
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
}

func saveTaskData(tasks:[Task]?) {
    let tasksData: Data = NSKeyedArchiver.archivedData(withRootObject: tasks!)
    UserDefaults.standard.set(tasksData, forKey: "tasks")
}

func fetchTaskData() -> [Task]? {
    let decoded = UserDefaults.standard.data(forKey: "tasks")
    let decodedTasks = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [Task]
    return decodedTasks
}

func deleteTaskData(completedTask: Task) {
    if let index = tasks?.index(of: completedTask) {
        tasks!.remove(at: index)
    } else {
        print("nothing was deleted")
    }
    saveTaskData(tasks: tasks)
}

//task cell
class TaskTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var myTask: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//task controller
class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    let cellIdentifier = "TaskTableViewCell"
    @IBOutlet weak var taskTable: UITableView!
    @IBOutlet weak var myTitle: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: fetchColorCode()!)
        navigationBar.barTintColor = UIColor(hex: fetchColorCode()!)
        
        taskTable.delegate = self
        taskTable.dataSource = self

        taskTable.reloadData()
        
        taskTable.tableFooterView = UIView(frame: .zero)
        taskTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: taskTable.frame.size.width, height: 1))
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(TaskViewController.longPress))
        myTitle.addGestureRecognizer(longPress)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in taskTable: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ taskTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks!.count
    }
    
    func tableView(_ taskTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = taskTable.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TaskTableViewCell else {
            fatalError("This cell is not an TaskTableViewCell")
        }
        cell.myTask.text = tasks![indexPath.row].name
        return cell
    }
    
    func tableView(_ taskTable: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Complete Task", message: "Would you like to complete the task " + tasks![indexPath.row].name + " for " + String(tasks![indexPath.row].pointVal) + " points?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
            return
        }
        let action = UIAlertAction(title: "Complete", style: .default) { (_) in
            let task = tasks![indexPath.row]
            addHistory(hist: task.name)
            points! = points! + task.pointVal
            UserDefaults.standard.set(points!, forKey: "myPoints")
            deleteTaskData(completedTask: tasks![indexPath.row])
            taskTable.deleteRows(at: [indexPath], with: .right)
            soundEffect(name: "closing_effect_sound")
        }
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit", handler:{action, indexpath in
            let alert = UIAlertController(title: "Edit Task", message: nil, preferredStyle: .alert)
            alert.addTextField { (taskTF) in
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 46, height: 20))
                label.text = "Name:"
                label.backgroundColor = UIColor.white
                label.font = UIFont.boldSystemFont(ofSize: 14)
                taskTF.leftViewMode = UITextFieldViewMode.always
                taskTF.leftView = label
                taskTF.text = tasks![indexPath.row].name
                taskTF.maxLength = 25
            }
            alert.addTextField { (pointValTF) in
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 81, height: 20))
                label.text = "Point value:"
                label.backgroundColor = UIColor.white
                label.font = UIFont.boldSystemFont(ofSize: 14)
                pointValTF.leftViewMode = UITextFieldViewMode.always
                pointValTF.leftView = label
                pointValTF.keyboardType = .numberPad
                pointValTF.text = String(tasks![indexPath.row].pointVal)
                pointValTF.maxLength = 2
            }
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
                return
            }
            let action = UIAlertAction(title: "Edit", style: .default) { (_) in
                guard let task = alert.textFields?[0].text else { return }
                guard let pointVal = alert.textFields?[1].text else { return }
                tasks![indexPath.row].name = task
                tasks![indexPath.row].pointVal = Int(pointVal)!
                saveTaskData(tasks: tasks)
                tableView.reloadData()
            }
            alert.addAction(cancel)
            alert.addAction(action)
            self.present(alert, animated: true)
        });
        editRowAction.backgroundColor = UIColor.lightGray;
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            deleteTaskData(completedTask: tasks![indexPath.row])
            self.taskTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        });
        
        return [deleteRowAction, editRowAction];
    }
    
    func tableView(_ taskTable: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if (taskTable.isEditing == true) {
            return UITableViewCellEditingStyle.none
        } else {
            return UITableViewCellEditingStyle.delete
        }
    }
    
    func tableView(_ taskTable: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ taskTable: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ taskTable: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        tasks!.insert(tasks!.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
        saveTaskData(tasks: tasks)
        taskTable.reloadData()
        soundEffect(name: "lip_sound")
    }
 
    @objc func longPress(press: UILongPressGestureRecognizer) {
        if (press.state == UIGestureRecognizerState.began) {
            if (taskTable.isEditing == true) {
                taskTable.setEditing(false, animated: true)
            } else {
                taskTable.setEditing(true, animated: true)
            }
        }
    }
    
    @IBAction func composeTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add To-Do", message: nil, preferredStyle: .alert)
        alert.addTextField { (taskTF) in
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 46, height: 20))
            label.text = "Name:"
            label.backgroundColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 14)
            taskTF.leftViewMode = UITextFieldViewMode.always
            taskTF.leftView = label
            taskTF.placeholder = "Enter To-Do"
            taskTF.maxLength = 25
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
            guard let task = alert.textFields?[0].text else { return }
            guard let pointVal = alert.textFields?[1].text else { return }
            self.add(task: task, pointVal: Int(pointVal)!)
        }
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func add(task: String, pointVal: Int) {
        if task != "" {
            let newTask = Task(name: task, pointVal: pointVal)
            tasks!.append(newTask)
            saveTaskData(tasks: tasks)
            taskTable.insertRows(at: [IndexPath(row: tasks!.count - 1, section: 0)], with: .automatic)
            soundEffect(name: "office_pencil_scribble_out_on_paper")
        }
    }
    
}
