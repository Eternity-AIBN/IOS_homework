//
//  ReminderTableViewController.swift
//  FinalProj
//
//  Created by AIBN on 2021/1/25.
//

import UIKit
import os.log

class ReminderTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var things = [Reminder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem

        // Load any saved reminders, otherwise load sample data.
        if let savedThings = loadReminders() {
            things += savedThings
        }
        else{
            // Load the sample data
            loadSampleThings()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return things.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ReminderTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ReminderTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate thing for the data source layout.
        let tmp = things[indexPath.row]
        
        cell.thingLabel.text = tmp.thing
        cell.photoImageView.image = tmp.photo
        cell.ratingControl.rating = tmp.rating
        
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
            things.remove(at: indexPath.row)
            saveReminders()
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
            
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new reminder.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let reminderDetailViewController = segue.destination as? ReminderViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? ReminderTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedReminder = things[indexPath.row]
            reminderDetailViewController.thing = selectedReminder
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    //MARK: Action
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ReminderViewController, let thing = sourceViewController.thing {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing reminder.
                things[selectedIndexPath.row] = thing
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new reminder.
                let newIndexPath = IndexPath(row: things.count, section: 0)
                
                things.append(thing)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            //Save the reminders
            saveReminders()
        }
    }
    
    //MARK: Private Methods
    private func loadSampleThings(){
        let photo1 = UIImage(named: "apple")
        let photo2 = UIImage(named: "banana")
        let photo3 = UIImage(named: "phone")
        
        guard let things1 = Reminder(thing: "Buy apple", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate things1")
        }
        
        guard let things2 = Reminder(thing: "Eat banana", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate things2")
        }
        
        guard let things3 = Reminder(thing: "Buy phone", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate things3")
        }
        
        things += [things1, things2, things3]
    }
    
    private func saveReminders(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(things, toFile: Reminder.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Reminders successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save reminders...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadReminders() -> [Reminder]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Reminder.ArchiveURL.path) as? [Reminder]
    }

}
