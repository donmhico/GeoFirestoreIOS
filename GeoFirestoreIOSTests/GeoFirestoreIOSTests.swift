//
//  GeoFirestoreIOSTests.swift
//  GeoFirestoreIOSTests
//
//  Created by Mico on 19/03/2019.
//  Copyright © 2019 HELPEE-TECH INC. All rights reserved.
//

import XCTest
import Firebase
import FirebaseFirestore

@testable import GeoFirestoreIOS

class GeoFirestoreIOSTests: XCTestCase {
    
    private static var _fireStore: Firestore!
    
    private static var _collectionRef: CollectionReference!
    
    private var _geoFireStoreIOS: GeoFirestoreIOS!
    
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
                
                // Init firestore
                GeoFirestoreIOSTests._fireStore = Firestore.firestore()
                
                // Create collection reference
                GeoFirestoreIOSTests._collectionRef = GeoFirestoreIOSTests._fireStore.collection("locations")
                
            }
            
        }
        
    }
    
    override class func tearDown() {
        super.tearDown()
        
        print("FINAL TEAR DOWN")
        
        GeoFirestoreIOSTests._fireStore = nil
        
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self._geoFireStoreIOS = GeoFirestoreIOS(collectionRef: GeoFirestoreIOSTests._collectionRef)

    }
    
    func testSaveWithErrors() {
        
        // Test no ["l"] in data
        let data1: [String: Any] = ["test": "testing"]
        
        self._geoFireStoreIOS.save(data: data1) { (documentID, geohash, error)  in
            
            if let e = error {
                
                XCTAssertEqual(GeoFirestoreIOSError.NO_GEOPOINT_FOUND_IN_DATA.rawValue, e.code)
                
                // There should be no documentID
                XCTAssertNil(documentID)
                
            }
            else {
                
                // Make sure the test fail if no error was produced
                XCTAssertTrue(false)
                
            }
            
        }
        
    }
    
    func testSave() {
        
        var docID = ""
        var savedGeohash = ""
        let geoPoint = GeoPoint(latitude: 5.587654321, longitude: 11.123456789)
        
        let expectSaveLocation = XCTestExpectation(description: "Save location")
        
        let data: [String: Any] = ["l": geoPoint, "d": ["first_name": "Michael", "hobby": "Music"]]
        
        self._geoFireStoreIOS.save(data: data) { (documentID, geoFirestoreDocument, error) in
            
            if let _ = error {
                
                // Make sure the test fails if an error was produced
                XCTAssertTrue(false)
                
            }
            
            docID = documentID!
            
            if let doc = geoFirestoreDocument {
                
                savedGeohash = doc.geohash!
                
            }
            
            expectSaveLocation.fulfill()
            
        }
        
        wait(for: [expectSaveLocation], timeout: 5, enforceOrder: true)
        
        let expectReadLocation = XCTestExpectation(description: "Read location")
        
        GeoFirestoreIOSTests._collectionRef.document(docID).getDocument { (snap, error) in
            
            if let _ = error {
                
                // Make sure the test fails if an error was produced
                XCTAssertTrue(false)
                
            }
            
            if let snapshot = snap, snapshot.exists {
                
                if let data = snapshot.data() {
                    
                    // Check if hashtag is saved
                    if let ghash = data["g"] as? String {
                        
                        if !ghash.elementsEqual(savedGeohash) {
                            
                            XCTAssertTrue(false)
                            
                        }
                        
                    }
                    else {
                        
                        XCTAssertTrue(false)
                        
                    }
                    
                    // Check if geopoint is saved
                    if let gp = data["l"] as? GeoPoint {
                        
                        if !geoPoint.latitude.isEqual(to: gp.latitude) {
                            
                            XCTAssertTrue(false)
                            
                        }
                        
                        if !geoPoint.longitude.isEqual(to: gp.longitude) {
                            
                            XCTAssertTrue(false)
                            
                        }
                        
                    }
                    else {
                        
                        XCTAssertTrue(false)
                        
                    }
                    
                    // Check if the rest of the data is saved
                    if let restOfData = data["d"] as? [String: Any] {
                        
                        if let firstName = restOfData["first_name"] as? String {
                            
                            if !firstName.elementsEqual("Michael") {
                                
                                 XCTAssertTrue(false)
                                
                            }
                            
                        }
                        else {
                            
                            XCTAssertTrue(false)
                            
                        }
                        
                        if let hobby = restOfData["hobby"] as? String {
                            
                            if !hobby.elementsEqual("Music") {
                             
                                 XCTAssertTrue(false)
                                
                            }
                            
                        }
                        else {
                            
                            XCTAssertTrue(false)
                            
                        }
                        
                    }
                    else {
                        
                        XCTAssertTrue(false)
                        
                    }
                    
                }
                else {
                    
                    XCTAssertTrue(false)
                    
                }
                
            }
            else {
                
                XCTAssertTrue(false)
                
            }
            
            expectReadLocation.fulfill()
            
        }
        
        wait(for: [expectReadLocation], timeout: 5, enforceOrder: true)
        
    }
    
    func testGet() {
        
        var docID = ""
        var savedGeohash = ""
        
        // Save a new document first
        let geoPoint = GeoPoint(latitude: 5.587654321, longitude: 11.123456789)
        
        let expectSaveLocation = XCTestExpectation(description: "Save location")
        
        let data: [String: Any] = ["l": geoPoint, "d": ["first_name": "John", "last_name": "Doe", "hobby": "Music"]]
        
        self._geoFireStoreIOS.save(data: data) { (documentID, geoFirestoreDocument, error) in
            
            if let _ = error {
                
                // Make sure the test fails if an error was produced
                XCTAssertTrue(false)
                
            }
            
            docID = documentID!
            
            if let doc = geoFirestoreDocument {
                
                savedGeohash = doc.geohash!
                
            }
            
            expectSaveLocation.fulfill()
            
        }
        
        wait(for: [expectSaveLocation], timeout: 5, enforceOrder: true)
        
        // End save
        
        // Get the data
        let expectGet = XCTestExpectation(description: "Get")
        
        self._geoFireStoreIOS.get(withDocumentId: docID) { (documentID, geoFirestoreDocument, error) in
            
            if let _ = error {
                
                // Make sure the test fails if an error was produced
                XCTAssertTrue(false)
                
            }
            
            // Compare the data
            XCTAssertEqual(geoPoint, geoFirestoreDocument?.point)
            XCTAssertEqual(savedGeohash, geoFirestoreDocument?.geohash)
            XCTAssertEqual("John", geoFirestoreDocument?.data!["first_name"] as! String)
            XCTAssertEqual("Doe", geoFirestoreDocument?.data!["last_name"] as! String)
            XCTAssertEqual("Music", geoFirestoreDocument?.data!["hobby"] as! String)
            
            expectGet.fulfill()
            
        }
        
        wait(for: [expectGet], timeout: 5, enforceOrder: true)
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }

}
