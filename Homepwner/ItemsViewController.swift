//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Roberto García on 05-12-17.
//  Copyright © 2017 Roberto García. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    var imageWidth: String = ""
    var imageHeight: String = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let statusBarHeight = UIApplication.shared.statusBarFrame.height
//
//        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
//        tableView.contentInset = insets
//        tableView.scrollIndicatorInsets = insets
        
        
        self.imageWidth = String(format: "%.0f", Double(UIScreen.main.bounds.width))
        self.imageHeight = String(format: "%.0f", Double(UIScreen.main.bounds.width))
        
        let imageUrl = "https://source.unsplash.com/random/\(self.imageWidth)x\(self.imageHeight)"
        
        if let url = URL(string: imageUrl) {
            downloadImage(url: url)
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemStore.allItems.count+1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (itemStore.allItems.count == 0 || indexPath.row == itemStore.allItems.count) {
            return 44
        }
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        var cellColor = UIColor.init(white: 1, alpha: 0.7)
        
        if (itemStore.allItems.count == 0 || indexPath.row == itemStore.allItems.count) {
            cell.nameLabel.text = "No more items!"
            cell.valueLabel.text = ""
            cell.serialNumberLabel.text = ""
        } else {
            let item = itemStore.allItems[indexPath.row]
            cell.nameLabel.text = item.name
            cell.serialNumberLabel.text = item.serialNumber
            cell.valueLabel.text = "$\(item.valueInDollars)"
            if item.valueInDollars >= 50 {
                cellColor = UIColor.init(red: 1, green: 0, blue: 0, alpha: 0.7)
            } else {
                cellColor = UIColor.init(red: 0, green: 1, blue: 0, alpha: 0.7)
            }
//            cell.textLabel?.font = cell.textLabel?.font.withSize(20)
//            cell.detailTextLabel?.font = cell.detailTextLabel?.font.withSize(20)
        }

        cell.backgroundColor = cellColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageUrl = "https://source.unsplash.com/random/\(self.imageWidth)x\(self.imageHeight)"
        
        if let url = URL(string: imageUrl) {
            downloadImage(url: url)
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                let imageView = UIImageView.init(image: UIImage(data: data))
                imageView.frame = self.tableView.frame
                self.tableView.backgroundView = imageView
            }
        }
    }
    
//    @IBAction func toggleEditingMode(_ sender: UIButton) {
//        // If you are currently in editing mode...
//        if isEditing {
//            // Change text of button to inform user of state
//            sender.setTitle("Edit", for: .normal)
//            // Turn off editing mode
//            setEditing(false, animated: true)
//        } else {
//            // Change text of button to inform user of state
//            sender.setTitle("Done", for: .normal)
//            // Enter editing mode
//            setEditing(true, animated: true)
//        }
//    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        let newItem = itemStore.createItem()
        
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section:0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }

    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction.init(title: "Delete", style: .destructive, handler: { (action) -> Void in
                self.itemStore.removeItem(item)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
            
            present(ac,animated: true, completion: nil)
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            if (indexPath.row == itemStore.allItems.count) {
                return .none
            }
        }
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.row == itemStore.allItems.count) {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showItem"?:
            if let row = tableView.indexPathForSelectedRow?.row {
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }

    

}
