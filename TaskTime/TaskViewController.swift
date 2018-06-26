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
var tasks:[String]?

func saveTaskData(tasks:[String]?) {
    UserDefaults.standard.set(tasks, forKey: "tasks")
}

func fetchTaskData() -> [String]? {
    if let task = UserDefaults.standard.array(forKey: "tasks") as? [String] {
        return task
    } else {
        return nil
    }
}

func deleteTaskData(completedTask: String) {
    if let index = tasks?.index(of: completedTask) {
        tasks!.remove(at: index)
    } else {
        print("nothing was deleted")
    }
    UserDefaults.standard.set(tasks, forKey: "tasks")
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
        cell.myTask.text = tasks![indexPath.row]
        return cell
    }
    
    func tableView(_ taskTable: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks![indexPath.row]
        addHistory(hist: task)
        points! = points! + 1
        UserDefaults.standard.set(points!, forKey: "myPoints")
        deleteTaskData(completedTask: String(describing: tasks![indexPath.row]))
        taskTable.deleteRows(at: [indexPath], with: .right)
        soundEffect(name: "closing_effect_sound")
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit", handler:{action, indexpath in
            let alert = UIAlertController(title: "Edit Task", message: nil, preferredStyle: .alert)
            alert.addTextField { (taskTF) in
                taskTF.text = tasks![indexPath.row]
                taskTF.maxLength = 25
            }
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
                return
            }
            let action = UIAlertAction(title: "Edit", style: .default) { (_) in
                guard let task = alert.textFields?.first?.text else { return }
                tasks![indexPath.row] = task
                saveTaskData(tasks: tasks)
                tableView.reloadData()
            }
            alert.addAction(cancel)
            alert.addAction(action)
            self.present(alert, animated: true)
        });
        editRowAction.backgroundColor = UIColor.lightGray;
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            deleteTaskData(completedTask: String(describing: tasks![indexPath.row]))
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
            taskTF.placeholder = "Enter To-Do"
            taskTF.maxLength = 25
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
            return
        }
        let action = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let task = alert.textFields?.first?.text else { return }
            self.add(task: task)
        }
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func add(task: String) {
        if task != "" {
            tasks!.append(task)
            UserDefaults.standard.set(tasks, forKey: "tasks")
            taskTable.insertRows(at: [IndexPath(row: tasks!.count - 1, section: 0)], with: .automatic)
            soundEffect(name: "office_pencil_scribble_out_on_paper")
        }
    }
    
}
