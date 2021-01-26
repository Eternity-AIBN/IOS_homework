//
//  FinalProjTests.swift
//  FinalProjTests
//
//  Created by AIBN on 2021/1/24.
//

import XCTest
@testable import FinalProj

class FinalProjTests: XCTestCase {
    //MAKR: Reminder Class Tests
    
    // Confirm that the Reminder initializer returns a Reminder object when passed valid parameters.
    func testReminderInitializationSucceeds() {
        
        //Zero rating
        let zeroRating = Reminder.init(thing: "Buy apple", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRating)
        
        //Positive rating
        let positiveRating = Reminder.init(thing: "But banana", photo: nil, rating: 4)
        XCTAssertNotNil(positiveRating)
        
    }
    
    // Confirm that the Reminder initialier returns nil when passed a negative rating or an empty thing.
    func testReminderInitializationFails() {
        // Negative rating
        let negativeRatingMeal = Reminder.init(thing: "Buy apple", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
         
        // Empty String
        let emptyStringMeal = Reminder.init(thing: "Buy apple", photo: nil, rating: 6)
        XCTAssertNil(emptyStringMeal)
        
        // Rating exceeds maximum
        let largeRatingMeal = Reminder.init(thing: "", photo: nil, rating: 0)
        XCTAssertNil(largeRatingMeal)
    }

}
