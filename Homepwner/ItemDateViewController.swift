//
//  ItemDateViewController.swift
//  Homepwner
//
//  Created by Roberto García on 10-12-17.
//  Copyright © 2017 Roberto García. All rights reserved.
//

import UIKit

class ItemDateViewController: UIViewController {

    var item: Item!
    
    @IBOutlet weak var itemDate: UIDatePicker!
    
    @IBAction func itemDatePicked(_ sender: UIDatePicker) {
        item.dateCreated = sender.date
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.itemDate.setDate(item.dateCreated, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
