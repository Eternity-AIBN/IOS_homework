//
//  Reminder.swift
//  FinalProj
//
//  Created by AIBN on 2021/1/25.
//

import UIKit
import os.log

class Reminder: NSObject,NSCoding {
    //MARK: Properties
    var thing: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("reminders")
    
    //MARK: Types
    struct PropertyKey{
        static let thing = "thing"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    //MARK: Initialization
    init?(thing: String, photo: UIImage?, rating: Int){
        
        //The thing must not be empty
        guard !thing.isEmpty else{
            return nil
        }
        
        //The rating must be 0~5
        guard (rating >= 0) && (rating <= 5) else{
            return nil
        }
        
        //Initialize stored properties
        self.thing = thing
        self.photo = photo
        self.rating = rating
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(thing, forKey: PropertyKey.thing)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    required convenience init?(coder decoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let thing = decoder.decodeObject(forKey: PropertyKey.thing) as? String else {
            os_log("Unable to decode the thing for a Reminder object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = decoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = decoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer.
        self.init(thing: thing, photo: photo, rating: rating)
        
    }
    
}

