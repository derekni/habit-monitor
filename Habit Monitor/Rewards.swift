//
//  Rewards.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/16/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import Foundation

var rewards:[String]?
var rewardsDict:[String:Int]?

func saveRewardsData(rewards:[String]?) {
    UserDefaults.standard.set(rewards, forKey: "myRewards")
}

func saveRewardsDictData(rewardsDict:[String:Int]?) {
    UserDefaults.standard.set(rewardsDict, forKey:"myRewardsDict")
}

func fetchRewardsData() -> [String]? {
    if let reward = UserDefaults.standard.array(forKey: "myRewards") as? [String] {
        return reward
    } else {
        return nil
    }
}

func fetchRewardsDictData() -> [String:Int]? {
    if let dict = UserDefaults.standard.dictionary(forKey: "myRewardsDict") as? [String:Int] {
        return dict
    } else {
        return nil
    }

}


