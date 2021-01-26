//
//  Reminder.swift
//  FinalProj
//
//  Created by AIBN on 2021/1/25.
//

import UIKit

class Reminder{
    
    //MARK: Properties
    
    var thing: String
    var photo: UIImage?
    var rating: Int
    
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
    
}

