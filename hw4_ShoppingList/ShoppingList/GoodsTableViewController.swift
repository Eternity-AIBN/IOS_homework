//
//  GoodsTableViewController.swift
//  ShoppingList
//
//  Created by AIBN on 2020/11/12.
//

import UIKit
import os.log

class GoodsTableViewController: UITableViewController {
    //MARK: Properties
    var goods = [Goods]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        // Load any saved meals, otherwise load sample data.
        if let savedGoods = loadGoods() {
            goods += savedGoods
        }
        else{
            // Load the sample data
            loadSampleGoods()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goods.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "GoodsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GoodsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let good = goods[indexPath.row]
        
        cell.nameLabel.text = good.name
        cell.photoImageView.image = good.photo
        cell.reasonLabel.text = good.reason
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            goods.remove(at: indexPath.row)
            saveGoods()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
            case "AddItem":
                os_log("Adding a new goods.", log: OSLog.default, type: .debug)
                
            case "ShowDetail":
                guard let mealDetailViewController = segue.destination as? GoodsViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedMealCell = sender as? GoodsTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedMeal = goods[indexPath.row]
                mealDetailViewController.good = selectedMeal
                
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    //MARK: Actions
    @IBAction func unwindToGoodList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? GoodsViewController, let good = sourceViewController.good {
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                //Update an existing goods
                goods[selectedIndexPath.row] = good
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                // Add a new goods.
                let newIndexPath = IndexPath(row: goods.count, section: 0)
                
                goods.append(good)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            //Save the goods.
            saveGoods()
        }
    }

    //MARK: Private Methods
    private func loadSampleGoods(){
        let photo1 = UIImage(named: "goods1")
        let photo2 = UIImage(named: "goods2")
        let photo3 = UIImage(named: "goods3")
        
        guard let goods1 = Goods(name: "Salad", photo: photo1, reason: "Delicious") else{
            fatalError("Unable to instantiate goods1")
        }
        guard let goods2 = Goods(name: "Salad", photo: photo2, reason: "Cheap") else{
            fatalError("Unable to instantiate goods2")
        }
        guard let goods3 = Goods(name: "Salad", photo: photo3, reason: "Look good") else{
            fatalError("Unable to instantiate goods3")
        }
        
        goods += [goods1, goods2, goods3]
    }
    private func saveGoods(){
        /*if let dataToBeArchived = try? NSKeyedArchiver.archivedData(withRootObject: goods, requiringSecureCoding: true) {
            try? dataToBeArchived.write(to: Goods.ArchiveURL)
        }*/
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(goods, toFile: Goods.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Goods successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save goods...", log: OSLog.default, type: .error)
        }
    }
    private func loadGoods() -> [Goods]?{
        /*if let dataBeArchived = try? Data(contentsOf: Goods.ArchiveURL){
            return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dataBeArchived) as? [Goods]
        }
        return nil*/
        return NSKeyedUnarchiver.unarchiveObject(withFile: Goods.ArchiveURL.path) as? [Goods]
    }
}
