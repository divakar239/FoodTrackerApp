//
//  ViewController.swift
//  Food Tracker
//
//  Created by Divakar Kapil on 2016-02-27.
//  Copyright © 2016 Divakar Kapil. All rights reserved.
//

import UIKit

// The MealViewController maintains a ref to the Text fields; adopt UITextfieldDelegate protocol to act as a TextField Delegate

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    // @IBOutlet weak var mealNameLabel: UILabel!    we deleted it as we no ,longer require it
    //@IBOutlet weak var setDefaultLabelText: UIButton!   We removed the button as we don't need it
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    // We want to add a new Meal object when the Save button is tapped; in order to keep track of it we need to create an outlet of the button in the MealViewController 
    
    // We can now identify the Save button
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    //This value is either passed by "MealableViewController" in prepareForSegue(_ :sender:)or constructed as part of adding a new Meal object
    var meal: Meal?
    // So we declared an optional Meal which means it may be nil  at any point in the program.
        override func viewDidLoad() {
        super.viewDidLoad()
        // self refers to the View Controller Class instance
        
        
        //self.setDefaultLabelText.setTitle("Set Default Text", forState:UIControlState.Normal)
        //self.mealNameLabel.text="Meal Name"
        
        //Handle the text field's input named nameTextField by Delegate callbacks
        nameTextField.delegate=self
            
            
            /*if let meal = meal {
                
               // This code sets each of the views in MealViewController to display data from the meal property if the meal property is non-nil, which happens only when an existing meal is being edited. SO THROUGH THIS CODE WE CAN ADD A NEW meal OBJECT.
                
                navigationItem.title = meal.name
                nameTextField.text   = meal.name
                photoImageView.image = meal.photo
                ratingControl.rating = meal.rating
                
            }*/
            
            
        
        checkValidMealName()
        // Enable the Save button only when the nameTextField has a valid name in the text field.
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK: UITextFieldDelegate
    
       func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidMealName()
        navigationItem.title = textField.text
        
        //The first line calls checkValidMealName() to check if the text field has text in it, which enables the Save button if it does. The second line sets the title of the scene to that text.

    }
    
    
    
    // addition of the new UITextField Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidMealName() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
        //This is a helper method that helps the save button to be enabled when text field is empty
    }

    
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        
        // Dismiss the picker if the user canceled
    }
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        // Allows us to do something with the image taht the user selected; in this case we dis[play it in our UI
        
        let selectedImage=info[UIImagePickerControllerOriginalImage] as! UIImage
        // This was casting as we know for sure that the object will be a UIImage
        
        //the info dictionary stores the original image that was selected by the picker
        
        photoImageView.image = selectedImage
        // Set photoImage to display teh selected image
        
        dismissViewControllerAnimated(true, completion: nil)
        // Diamiss the Picker
    }
    
    // MARK: Navigation
    
    //The task now is to pass the Meal object to MealTableViewController when a user taps the Save button and discard it when a user taps the Cancel button, switching from displaying the meal scene to displaying the meal list in either case.
    
    //To accomplish this, you’ll use an unwind segue. An unwind segue moves backward through one or more segues to return the user to an existing instance of a view controller. You use unwind segues to implement reverse navigation.
    
    // Whenever a segue gets triggered, it provides a place for you to add your own code that gets executed. This method is called prepareForSegue(_:sender:), and it gives you a chance to store data and do any necessary cleanup on the source view controller (the view controller that the segue is coming from). You’ll implement this method in MealViewController to do exactly that.
    
    // This method allows us to configure the view controller before its presented
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //This code uses the (===) operator which checks if the object referenced by the Save button outlet is the same object instance as sender.
    
        if saveButton === sender{
            
            //This code creates constants from the current text field text, selected mage and rating in the scene.
            
            let name = nameTextField.text ?? ""
            let photo = photoImageView.image
            let rating = ratingControl.rating
            
            // Configyres the meal property with the appropriate values before the segue executes.
            meal = Meal(name:name, photo: photo, rating:rating)
        }
        
        
    }
    
    
    
    //MARK: Actions
    
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        
        // This ensures that if the user taps the image while typing in the text field, the keyboard is dismissed properly
        nameTextField.resignFirstResponder()
        
        // We created an instance of the class to llow the user to pick images from a library; note its a constant ref/instance
        let imagePickerController=UIImagePickerController()
        
        // This sets the image picker controller's source to Photolibrary
        imagePickerController.sourceType = .PhotoLibrary
        // .PhotoLibraray is short for UIImagePickerControllerSourceType.PhotoLibrary as it's an enum
        
        imagePickerController.delegate = self
        // note we needed to include the UINavigationDelegate
        
        presentViewController(imagePickerController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        // Depending on the style of the presentation Modal ( when an item is added using the ADD button) and Push ( when an item is added using the TableViewcell) the view controller has to be dismissed in 2 different ways.

        
        let isPresentinginAddMealMode = presentingViewController is UINavigationController
        
        //This creates a Boolean value that indicates whether the view controller that presented this scene is of type UINavigationController. As the constant name isPresentingInAddMealMode indicates, this means that the meal scene was presented using the Add button. This is because the meal scene is embedded in its own navigation controller when it’s presented in this manner, which means that navigation controller is what presents it.
        
        
        // This method is used to dismiss the view controller which is in place due to Modal presentaion(ADD button).
        
        if isPresentinginAddMealMode{
            
        dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        else{
            
            //This is now an if statement with an else clause that executes the code within the if statement only when isPresentingInAddMealMode is true, and executes the code within the else clause otherwise.
            
            //The else clause gets executed when the meal scene was pushed onto the navigation stack on top of the meal list scene. The code within the else clause executes a method called popViewControllerAnimated, which pops the current view controller (meal scene) off the navigation stack of navigationController and performs an animation of the transition.
            
            navigationController!.popViewControllerAnimated(true)
        }
        
    }
        
    //    @IBAction func setDefaultLabelText(sender:UIButton){
    //        self.mealNameLabel.text="Default Name"
    //    }
    //    
}


