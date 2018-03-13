//
//  Points.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/12/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import Foundation

var points:Int?

func savePointsData(points:Int?) {
    UserDefaults.standard.set(points, forKey: "myPoints")
}

func fetchPointsData() -> Int? {
    if let point = UserDefaults.standard.integer(forKey: "myPoints") as? Int {
        return point
    } else {
        return 0
    }
}
