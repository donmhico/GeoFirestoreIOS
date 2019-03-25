//
//  GFIOSGeoHashTests.swift
//  GeoFirestoreIOSTests
//
//  Created by Mico on 19/03/2019.
//  Copyright © 2019 HELPEE-TECH INC. All rights reserved.
//

import XCTest

@testable import GeoFirestoreIOS

class GFIOSGeoHashTests: XCTestCase {

    override func setUp() {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    func testGetGeoHash() {
        
        do {
            
            // Test using the values from https://www.movable-type.co.uk/scripts/geohash.html
            
            let gfiosGeoHash1 = try GFIOSGeoHash(latitude: 14.641945010908996, longitude: 121.02201305329801, lPrecision: 10)
            let gfiosGeoHash2 = try GFIOSGeoHash(latitude: 48.668983, longitude: -4.329021, lPrecision: 9)
            let gfiosGeoHash3 = try GFIOSGeoHash(latitude: 14.641994, longitude: 121.0220742, lPrecision: 5)
            let gfiosGeoHash4 = try GFIOSGeoHash(latitude: 14.6400383, longitude: 121.0277761, lPrecision: 9)
            let gfiosGeoHash5 = try GFIOSGeoHash(latitude: 14.642385529133763, longitude: 121.02275099605322, lPrecision: 10)
            
            XCTAssertEqual("wdw53cmx92", gfiosGeoHash1.getGeoHash())
            XCTAssertEqual("gbsuv7ztq", gfiosGeoHash2.getGeoHash())
            XCTAssertEqual("wdw53", gfiosGeoHash3.getGeoHash())
            XCTAssertEqual("wdw5611sr", gfiosGeoHash4.getGeoHash())
            XCTAssertEqual("wdw53cw446", gfiosGeoHash5.getGeoHash())
            
        }
        catch {
            
            XCTAssertTrue(false)
            
        }
        
    }
    
    func testInitInvalidPrecisionGreaterThanOne() {
        
        do {
            
            let _ = try GFIOSGeoHash(latitude: 14.6419502, longitude: 121.0198245, lPrecision: 0)
            
            // Make sure that the code above threw an error
            XCTAssertTrue(false)
            
        }
        catch {
            
            let e = error as NSError
            
            XCTAssertEqual(GFIOSGeoHashError.INVALID_PRECISION.rawValue, e.code)
            
        }
        
    }
    
    func testInitInvalidPrecisionGreaterThanPrecision() {
        
        do {
            
            let _ = try GFIOSGeoHash(latitude: 14.6419502, longitude: 121.0198245, lPrecision: 23)
            
            // Make sure that the code above threw an error
            XCTAssertTrue(false)
            
        }
        catch {
            
            let e = error as NSError
            
            XCTAssertEqual(GFIOSGeoHashError.INVALID_PRECISION.rawValue, e.code)
            
        }
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }

}
