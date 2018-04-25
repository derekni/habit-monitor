//
//  TasksViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/11/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UINavigationBar.appearance().isTranslucent = false
        
        taskTable.delegate = self
        taskTable.dataSource = self

        taskTable.reloadData()
        
        taskTable.tableFooterView = UIView(frame: .zero)
        taskTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: taskTable.frame.size.width, height: 1))
        
        if #available(iOS 11.0, *) {
            taskTable.dragDelegate = self as? UITableViewDragDelegate
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            taskTable.dropDelegate = self as? UITableViewDropDelegate
        } else {
            // Fallback on earlier versions
        }
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
    }
    
    func tableView(_ taskTable: UITableView, commit commitEditingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if commitEditingStyle == .delete {
            deleteTaskData(completedTask: String(describing: tasks![indexPath.row]))
            taskTable.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    /*
    @available(iOS 11.0, *)
    func tableView(_ taskTable: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return model.dragItems(for: indexPath)
    }
    */
    @IBAction func composeTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add To-Do", message: nil, preferredStyle: .alert)
        alert.addTextField { (taskTF) in
            taskTF.placeholder = "Enter To-Do"
            taskTF.maxLength = 20
            //taskTF.borderStyle = .roundedRect
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
        }
    }
    
}
