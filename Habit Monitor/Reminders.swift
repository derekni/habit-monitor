//
//  Tasks.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/12/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import Foundation

var reminders:[String]?

func saveReminderData(reminders:[String]?) {
    UserDefaults.standard.set(reminders, forKey: "reminders")
}

func fetchReminderData() -> [String]? {
    if let reminder = UserDefaults.standard.array(forKey: "reminders") as? [String] {
        return reminder
    } else {
        return nil
    }
}

func deleteReminderData(completedReminder: String) {
    if let index = reminders?.index(of: completedReminder) {
        reminders!.remove(at: index)
    } else {
        print("nothing was deleted")
    }
    UserDefaults.standard.set(reminders, forKey: "reminders")
}

