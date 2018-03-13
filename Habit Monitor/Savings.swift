//
//  Savings.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/13/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import Foundation

var savings:Int?

func saveSavingsData(savings:Int?) {
    UserDefaults.standard.set(savings, forKey: "mySavings")
}

func fetchSavingsData() -> Int? {
    if let saving = UserDefaults.standard.integer(forKey: "mySavings") as? Int {
        return saving
    } else {
        return 0
    }
}
