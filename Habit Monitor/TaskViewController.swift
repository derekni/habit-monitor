//
//  TasksViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/11/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    let cellIdentifier = "TaskTableViewCell"
    @IBOutlet weak var taskTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        taskTable.delegate = self
        taskTable.dataSource = self

        taskTable.reloadData()
        print("data reloaded")
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
        print("stuff is appearing")
        print(tasks!)
        print(tasks!.count)
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
        print("creating table")
        print(tasks![indexPath.row])
        return cell
    }
    
    func tableView(_ taskTable: UITableView, didSelectRowAt indexPath: IndexPath) {
        points! = points! + 1
        UserDefaults.standard.set(points!, forKey: "myPoints")
        deleteTaskData(completedTask: String(describing: tasks![indexPath.row]))
        taskTable.reloadData()
    }
    
}
