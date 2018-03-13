//
//  Tasks.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/12/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import Foundation

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
