//
//  TeachingNews.swift
//  NJUNews
//
//  Created by AIBN on 2020/12/27.
//

import UIKit

class TeachingNews: NSObject{
    var content: String
    var date: String
    var href: String
    
    //MARK: Initialization
    init?(content: String, date: String, href: String) {
        // The name must not be empty
        guard !content.isEmpty else {
            return nil
        }
        // The reason must not be empty
        guard !date.isEmpty else {
            return nil
        }
        guard !href.isEmpty else {
            return nil
        }
        // Initialize stored properties.
        self.content = content
        self.date = date
        self.href = href
    }
    
}
