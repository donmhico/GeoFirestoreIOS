//
//  GeoFirestoreIOSTests.swift
//  GeoFirestoreIOSTests
//
//  Created by Mico on 19/03/2019.
//  Copyright © 2019 HELPEE-TECH INC. All rights reserved.
//

import XCTest
@testable import GeoFirestoreIOS

class GeoFirestoreIOSTests: XCTestCase {
    
    var geoFirestore1: GeoFirestoreIOS!
    var geoFirestore2: GeoFirestoreIOS!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        geoFirestore1 = GeoFirestoreIOS(lat: 14.6419502, lng: 121.0198245)
        geoFirestore2 = GeoFirestoreIOS(lat: 15.6419502, lng: 122.0198245)
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        geoFirestore1 = nil
        geoFirestore2 = nil
        
    }

}
