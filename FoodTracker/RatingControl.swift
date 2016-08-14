//
//  RatingControl.swift
//  Food Tracker
//
//  Created by Divakar Kapil on 2016-02-29.
//  Copyright © 2016 Divakar Kapil. All rights reserved.
//

import UIKit

class RatingControl: UIView {
    
    //MARK: Properties
    var rating=0{
        
        didSet{
            // A Property Observer observes and responds to changes in the property's values. they are called everytime a property's values are changed. The didSet Property Observer is aclled immediately after he property's value has been set.
            
            // The setNeedsLayout updates the layput everytime the ratings are changed This ensures that the UI is always showing an accurate represantation of the rating property
            
            setNeedsLayout()
        }
    }
    
    var ratingButtons=[UIButton]()
    var stars = 5
    var spacing = 5
    
    let filledStarImage = UIImage(named: "filledStar")  // Adding the images to the initializer
    let emptyStarImage = UIImage(named: "emptyStar")
    
    //MARK: Initialization
    
    required init?(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)
        
        
        // The for loop allows us to make 5 buttons
        for _ in 0..<5{
            
            
            //Creating a new button
            
            let button=UIButton()   //(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
            //button.backgroundColor=UIColor.redColor()
            
            // NOTICE: as we mentioned the new layout size in the layoutSubView , we no longer need to specify the size in the initializer
            
            
            //Here we are manually linking the action called ratingButtonTapped to the button object we just created; self is the target i.e. the RatingControl class as it contains the button; the action will be triggered whnever the .Touchdown event occurs.
            
            // Since we are not using the Interface Builder, we don't have to specify @IBAction; we can declare the action just like any ordinary method.
            
            button.setImage(emptyStarImage, forState: .Normal)
            button.setImage(filledStarImage, forState: .Selected)
            button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
            
            // Here we are setting the the different staets of the button; when it is unselected it displays the empty star; when it is selected it displays the filled star; when the user is in the process of tapping the button it displays the flledStar
            
            button.adjustsImageWhenHighlighted = false //To ensure that the image doesn't show any additional highlight when selected
            
            
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)), forControlEvents: .TouchDown)
            
            //As we keep adding more buttons we store them in the ratingButtons array
            ratingButtons += [button]
            
            // add the button to the subclass of the UIView that is RatingControl
            addSubview(button)
        }
        
        // NOTE: We just created 5 buttons, however they have been stacked on top of each other; To layout the buttons in the view, we use the layoutSubViews
        
    }
    
    //To tell the stack view how to layout the button; passing in the same measurements in the InterfaceBuilder
    
    override func intrinsicContentSize()->CGSize{
        
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize + spacing) * stars
        return CGSize(width: width, height: buttonSize)
        
        // Important to update the size in the intrinsicContentSize
    }
    
    //
    override func layoutSubviews(){
        
        let buttonSize = Int(frame.size.height)  // we replaced all hard coded values for the buttons by buttonSize variable to let the layout be more flexible.
        
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        // Adjusting the distance of each button from the origin
        for (index, button) in ratingButtons.enumerate(){
            
            buttonFrame.origin.x = CGFloat(index*(buttonSize+5))  // setting the new index
            button.frame=buttonFrame                      // setting the new frame
        }
        // In the above loop, the code creates a frame and then sets the frame for each button;
        
        // the enumearte() method contains the elements in ratingButton array with their indexes; this is a collection of tuples in this case its index and button.
        
        // index and button are local variables which are being used to set a new location for each button and also set the new frame on the already created buttons.
        
        updateButtonSelectionStates()   // It's important to update the selection state of the buttons whenever the views load again; not just when the rating changes
    }
    
    
    //MARK: Action Button
    
    func ratingButtonTapped(button: UIButton){
        rating = ratingButtons.indexOf(button)! + 1
        
        // The indexOf( :) method attempts to find the selected buttton in the array of buttons and return the index of the selected one. The method returns an optional Int as the object may not be in the collection; since we know it contains buttons we can force unwrap it
        
        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates(){
        
        for(index,button) in ratingButtons.enumerate(){
            button.selected = index < rating
            
            //Select all the buttons with an index less than the button that has been actually selected
        }
    }
}
