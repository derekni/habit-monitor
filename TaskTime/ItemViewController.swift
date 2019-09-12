//
//  ItemViewController.swift
//  TaskTime
//
//  Created by Whip Master on 6/18/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {

    // MARK: Properties
    var itemIndex: Int = 0
    var imageName: String = "" {
        didSet {
            if let imageView = image {
                imageView.image = UIImage(named: imageName)
            }
        }
    }
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        image.image = UIImage(named: imageName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
