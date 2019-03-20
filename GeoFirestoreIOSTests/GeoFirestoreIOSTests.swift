//
//  GeoFirestoreIOSTests.swift
//  GeoFirestoreIOSTests
//
//  Created by Mico on 19/03/2019.
//  Copyright © 2019 HELPEE-TECH INC. All rights reserved.
//

import XCTest
import Firebase

@testable import GeoFirestoreIOS

class GeoFirestoreIOSTests: XCTestCase {
    
    private var _fireStore: Firestore?
    
    /**
     * Run once before running the tests
     */
    override class func setUp() {
        
        super.setUp()
    
        // Get the GoogleService-Info.plist file
        if let pListPath = Bundle.init(for: GeoFirestoreIOSTests.self).path(forResource: "GoogleService-Info", ofType: "plist") {
            
            // Get the firebase options (contents of pList)
            if let firebaseOptions = FirebaseOptions(contentsOfFile: pListPath) {
                
                // Init firebase
                FirebaseApp.configure(options: firebaseOptions)
                
            }
            
        }
        
    }
    
    override class func tearDown() {
        super.tearDown()
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self._fireStore = Firestore.firestore()
        
    }
    
    func testSample() {
        
        XCTAssertTrue(true)
        
    }
    
    func testAnotherSample() {
        
        XCTAssertTrue(false)
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self._fireStore = nil
        
    }

}
