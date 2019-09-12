//
//  HistoryTableViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/22/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit
import AVFoundation

//history
var history:[[String]]?

func saveHistoryData(history:[[String]]?) {
    UserDefaults.standard.set(history, forKey: "myHistory")
}

func fetchHistoryData() -> [[String]]? {
    if let hist = UserDefaults.standard.array(forKey: "myHistory") as? [[String]] {
        return hist
    } else {
        return nil
    }
}

func addHistory(hist: String) {
    if hist != "" {
        //date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, h:mm a"
        
        let date = Date()
        let data = String(describing: dateFormatter.string(from: date))
        
        var histValue = [String]()
        histValue.append(hist)
        histValue.append(data)
        history!.insert(histValue, at: 0)
        
        if (history!.count == 100) {
            history!.removeLast()
        }
        
        saveHistoryData(history: history!)
    }
}

//history cell
class HistoryTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

//history controller
class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var myHistory: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: fetchColorCode()!)
        navigationBar.barTintColor = UIColor(hex: fetchColorCode()!)
        
        myHistory.delegate = self
        myHistory.dataSource = self
        
        myHistory.tableFooterView = UIView(frame: .zero)
        myHistory.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: myHistory.frame.size.width, height: 1))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in myHistory: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ myHistory: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history!.count
    }
    
    func tableView(_ myHistory: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myHistory.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as? HistoryTableViewCell else {
            fatalError("Cell is not a HistoryTableViewCell")
        }
        cell.activityLabel.text = history![indexPath.row][0]
        cell.dateLabel.text = history![indexPath.row][1]
        
        return cell
    }
    
}
