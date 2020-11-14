//
//  Goods.swift
//  ShoppingList
//
//  Created by AIBN on 2020/11/12.
//

import UIKit
import os.log

class Goods: NSObject, NSCoding{
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var reason: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("goods")
    
    //MARK: Types
    struct PropertyKey{
        static let name = "name"
        static let photo = "photo"
        static let reason = "reason"
    }
    
    //MARK: Initialization
    init?(name: String, photo: UIImage?, reason: String) {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        // The reason must not be empty
        guard !reason.isEmpty else {
            return nil
        }
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.reason = reason
    }
    
    //MARK: NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(photo, forKey: PropertyKey.photo)
        coder.encode(reason, forKey: PropertyKey.reason)
    }
    
    required convenience init?(coder decoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = decoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Goods object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = decoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        guard let reason = decoder.decodeObject(forKey: PropertyKey.reason) as? String else {
            os_log("Unable to decode the reason for a Goods object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, reason: reason)
        
    }
}
