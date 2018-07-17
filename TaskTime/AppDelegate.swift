//
//  AppDelegate.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/2/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //check if first time
        let firstTimeVal = fetchFirstTimeVal()
        if (firstTimeVal!) {
            //play slideshow
        } else {
            //dont
        }
        
        //check if new day
        let currentDate = getCurrentDate()
        if (currentDate > fetchDateData()!) {
            saveDateData(date: currentDate)
            clearDoneHabits()
            print(currentDate)
        }
        
        //color
        if let colorVal = fetchColorVal() {
            color = colorVal
        } else {
            color = "Pine Green"
            saveColorVal(name: "Pine Green")
        }
        
        //sound
        if let musicVal = fetchBackgroundMusicVal() {
            backgroundMusicOn = musicVal
        } else {
            backgroundMusicOn = true
            saveBackgroundMusicVal(isOn: backgroundMusicOn!)
        }
        if (backgroundMusicOn!) {
            backgroundMusicToOn()
        } else {
            backgroundMusicToOff()
        }
        if let soundEffectVal = fetchSoundEffectVal() {
            soundEffectOn = soundEffectVal
        } else {
            soundEffectOn = true
            saveSoundEffectVal(isOn: soundEffectOn!)
        }
        
        //point val
        if let val = fetchPointVal() {
            pointVal = val
        } else {
            pointVal = 5
        }
        if pointVal == 0 {
            pointVal = 5
            savePointVal(pointVal: pointVal)
        }
        
        //enabled habits
        if let done = fetchDoneHabitsData() {
            doneHabits = done
        } else {
            doneHabits = []
        }
        
        //points
        if let point = fetchPointsData() {
            points = point
        } else {
            points = 0
        }
        
        //tasks
        if let task = fetchTaskData() {
            tasks = task
        } else {
            tasks = [String]()
            saveTaskData(tasks: tasks)
        }
        
        //habits
        if let habit = fetchHabitsData() {
            habits = habit
        } else {
            habits = [String]()
            saveHabitsData(habits: habits)
        }
        if habits?.count == 0 {
            habits = ["Work out"]
            saveHabitsData(habits: habits)
        }
        
        //reminders
        if let reminder = fetchReminderData() {
            reminders = reminder
        } else {
            reminders = [String]()
            saveReminderData(reminders: reminders)
        }

        //rewards
        if let reward = fetchRewardsData() {
            rewards = reward
        } else {
            rewards = [String]()
        }
        if rewards?.count == 0 {
            rewards = ["Watch TV"]
            saveRewardsData(rewards: rewards)
        }
        
        //rewards dict
        if let rewardDict = fetchRewardsDictData() {
            rewardsDict = rewardDict
        } else {
            rewardsDict = [String:Int]()
        }
        if rewardsDict?.count == 0 {
            rewardsDict = [
                "Watch TV": 1
            ]
            saveRewardsDictData(rewardsDict: rewardsDict)
        }
        
        //premium rewards
        if let premiumReward = fetchPremiumRewardsData() {
            premiumRewards = premiumReward
        } else {
            premiumRewards = [String]()
            savePremiumRewardsData(premiumRewards: premiumRewards)
        }
        if premiumRewards?.count == 0 {
            premiumRewards = ["Purchase"]
            savePremiumRewardsData(premiumRewards: premiumRewards)
        }
        if !(premiumRewards?.contains("Purchase"))! {
            premiumRewards?.append("Purchase")
            savePremiumRewardsData(premiumRewards: premiumRewards)
        }

        //premium rewards dict
        if let premiumRewardDict = fetchPremiumRewardsDictData() {
            premiumRewardsDict = premiumRewardDict
        } else {
            premiumRewardsDict = [String:Int]()
            savePremiumRewardsDictData(premiumRewardsDict: premiumRewardsDict)
        }
        if premiumRewardsDict?.count == 0 {
            premiumRewardsDict = ["Purchase":0]
            savePremiumRewardsDictData(premiumRewardsDict: premiumRewardsDict)
        }

        //savings
        if let saving = fetchSavingsData() {
            savings = saving
        } else {
            savings = 0
            saveSavingsData(savings: savings)
        }
        
        //history
        if let hist = fetchHistoryData() {
            history = hist
        } else {
            history = [[String]]()
            saveHistoryData(history: history)
        }
        
        //resolutions
        if let resolution = fetchResolutionData() {
            resolutions = resolution
        } else {
            resolutions = [String]()
            saveResolutionData(resolutions: resolutions)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        savePointsData(points: points!)
        saveTaskData(tasks: tasks!)
        saveSavingsData(savings: savings!)
        saveReminderData(reminders: reminders!)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        savePointsData(points: points!)
        saveTaskData(tasks: tasks!)
        saveSavingsData(savings: savings!)
        saveReminderData(reminders:reminders!)
    }

}

