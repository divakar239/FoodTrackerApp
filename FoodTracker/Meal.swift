//
//  Meal.swift
//  Food Tracker
//
//  Created by Divakar Kapil on 2016-03-05.
//  Copyright © 2016 Divakar Kapil. All rights reserved.
//

import UIKit

// In order to store data and conform to the NSCoding protocol, Meal class has to inherit from the base class called NSObject. NSObject defines a basic interface for to the runtime ( the period during which a program is executing ) system.

class Meal : NSObject, NSCoding {
    // MARK: Properties
    
    // We have to store data entered in various app sessions. This file is responsible for storing and calling each of its properties. It needs to store its data by assigning the value of each property to a particular key, and load the data by looking up a particular key value.
    
    // We will implement NSCoding approach to do the stated function above.To make it clear which key value is associated with which property we need a structure to store the keys.
    
    // NSCoding is a lightweight solution for archiving data. Stores it on the disk and calls it back whenever needed.
    
    struct PropertyKey{
        
        static let nameKey = "name"
        static let photoKey = "photo"
        static let ratingKey = "ratng"
        
        // To be able to encode and decode itself and its properties, the Meal class needs to conform to the NSCoding protocol
    }
    
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    
    //MARK : Archiving Path
    
    // Next, we need a persistent path on the file system where data will be saved and loaded, so you know where to look for it.
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("meals")
    
    // We mark these constants with the static keyword, which means they apply to the class instead of an instance of the class. Outside of the Meal class, you’ll access the path using the syntax Meal.ArchiveURL.path!.
    
    
    // MARK: Initialization
    
    init?(name: String, photo: UIImage?, rating: Int) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        
        super.init();  // Calling the parents' class initializer is always necessary in iOS
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || rating < 0 {
            return nil
        }
    }
    
    //MARK : NSCoding
    
    // Since NSCOding is being adopted as a protocol, it's 2 methods have to be implemented by the child class.
    
    // method 1 : encodeWithCoder   -  This method prepares the class's information to be archived.
    // method 2 : init              -  The initializer ensures to decode all the encoded properties of the class
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeInteger(rating,forKey: PropertyKey.ratingKey)
        
        // encode Object can encode any object whereas encodeInteger can encode only integers. So we store a property with their respective keys.
    }
    
    // required means its necessary to implement the particular function for all subclasses.
    
    // convenience defines the initializer to be a secondary initializetr that acts as a s secondary/ helper function to the main initializer called the designated initializer. The ddesignated initializer is responsible for setting up all the properties etc.
    
    required convenience init?(coder aDecoder: NSCoder){
        
        //The return type of decodeObjectForKey is any object. This has to be downcast to the respective data types that we are using in our defined structure using the forced operators as!
        
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        let rating = aDecoder.decodeIntegerForKey(PropertyKey.ratingKey)
        
        // As a convenience initializer, this initializer is required to call one of its class’s designated initializers before completing. As the initializer’s arguments, you pass in the values of the constants you created while archiving the saved data.
        
        self.init(name: name, photo:photo, rating : rating)
    }
    
}