//
//  MealTableViewController.swift
//  Food Tracker
//
//  Created by Divakar Kapil on 2016-03-06.
//  Copyright © 2016 Divakar Kapil. All rights reserved.
//



import UIKit

class MealTableViewController: UITableViewController {
    // MARK: Properties
    
    var meals = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This creates a special type of bar button item that has editing behavior built into it. It then adds this button to the left side of the navigation bar in the meal list scene.

        navigationItem.leftBarButtonItem = editButtonItem()
        
        
        // If loadMeals succesfully returns an array then the if statement gets executed and we load the previously existing list of meals; else we load only the sampleMeals as our pre-loaded list.
        
        if let savedMeals = loadMeals(){
            
            meals = meals+savedMeals
        }
        
        else{
        // Load the sample data.
        loadSampleMeals()
        }
    }
    
    func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")!
        let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4)!
        
        let photo2 = UIImage(named: "meal2")!
        let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5)!
        
        let photo3 = UIImage(named: "meal3")!
        let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3)!
        
        meals += [meal1, meal2, meal3]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section :Int)->Int{
        
        
        
        return meals.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }
    

    
    
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue){
        
        //This code checks whether a row in the table view is selected. If it is, that means a user tapped one of the table views cells to edit a meal. In other words, this if statement gets executed if an existing meal is being edited.
        
        
        if let sourceViewController = sender.sourceViewController as?
            
            MealViewController, meal = sourceViewController.meal{
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                
                meals[selectedIndexPath.row] = meal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                
            }

            else{
                
                let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
                meals.append(meal) // Add the new Meal object created
                
                // This animates th creation of the new Meal object in a row in the Table View ; thus it faciliatates the addition of a new row for the new cell that contains the contents of the new Meal object.
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
            saveMeals() // To save the Meals list
        }
        
    }

    
    //TO DELETE SELECTED ROW FROM THE TABLE    
    
    //To perform any sort of editing on a table view, you need to implement one of its delegate methods, tableView(_:commitEditingStyle:forRowAtIndexPath:). This delegate method is in charge of managing the table rows when it’s in editing mode.
    
    //You also need to uncomment the implementation of tableView(_:canEditRowAtIndexPath:) to support editing.

    
    // Override to support conditional editing of the table view.
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
    // Return false if you do not want the specified item to be editable.
        
        
    return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
        
    // Delete the row from the data source
        meals.removeAtIndex(indexPath.row)
        
        saveMeals() // Saves the list whenever an item is deleted from the array.
        
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
        
        
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
        
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // This if-else if block decides the type of segue as per the identification tags attached to them.
        
   
        if segue.identifier == "ShowDetail"{
    
            let mealDetailViewController = segue.destinationViewController as! MealViewController
            
            
            //The above piece of code tries to downcast the destination view controller of the segue to a MealViewController using the forced type cast operator (as!). If the cast is successful, the local constant mealDetailViewController gets assigned the value of segue.destinationViewController cast as type MealViewController.
            
            
           // This code tries to downcast sender to a MealCell using the optional type cast operator (as?). If the cast is successful, the local constant selectedMealCell gets assigned the value of sender cast as type MealTableViewCell, and the if statement proceeds to execute. If the cast is unsuccessful, the expression evaluates to nil and the if statement isn’t executed.
            
            if let selectedMealCell = sender as? MealTableViewCell{
                
                //This code fetches the Meal object corresponding to the selected cell in the table view. It then assigns that Meal object to the meal property of the destination view controller, an instance of MealViewController. (You’ll configure MealViewController to display the information from its meal property when it loads.)
                
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                let selectedMeal=meals[indexPath.row]
                mealDetailViewController.meal = selectedMeal
                
            }
            
            
            
        }
        
        else if segue.identifier == "AddItem"{
            
            print("Adding new meal")
            
        }
    }
    
    
    // MARK : NSCoding
    
    // We implemented NSCoding in Meal.swift which allows us to save and load an individual meal, the code in this file will permit us to save and load an entire meal list created or edited by the user.
    
    func saveMeals(){
        
        // This method attempts to archive the meals array to a specific location, and returns true if it’s successful. It uses the constant Meal.ArchiveURL that you defined in the Meal class to identify where to save the information.
        
        let isSuccesfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path!)
        
        if !isSuccesfulSave{
            
            print("Failed to save meals...")
        }
    }
    
    func loadMeals() -> [Meal]?{
        //This method has a return type of an optional array of Meal objects, meaning that it might return an array of Meal objects or might return nothing (nil).
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Meal.ArchiveURL.path!) as? [Meal]
        
        // This method attempts to unarchive the object stored in the Meal.Archive.path! and downcast the object to an array of Meal object
        
    }
}
 