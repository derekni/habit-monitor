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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.taskTable.reloadData()
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
        taskTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.right)
    }
    
    func tableView(_ taskTable: UITableView, commit commitEditingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if commitEditingStyle == .delete {
            deleteTaskData(completedTask: String(describing: tasks![indexPath.row]))
            taskTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
}

//add task controller
class AddTaskViewController: UIViewController {
    
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
            tasks!.append(textField.text!)
            UserDefaults.standard.set(tasks, forKey: "tasks")
        }
    }
    
}
