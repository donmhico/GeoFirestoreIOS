//
//  GeoFirestoreIOS.swift
//  GeoFirestoreIOS
//
//  Created by Mico on 19/03/2019.
//  Copyright © 2019 HELPEE-TECH INC. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase
import CoreLocation

enum GeoFirestoreIOSError: Int {
    case NO_GEOPOINT_FOUND_IN_DATA = 101
    case NO_GEOFIRESTOREIOS_DOCUMENT = 102
}

struct GeoFirestoreDocument {
    
    var point: GeoPoint?
    var data: [String: Any]?
    var geohash: String?
    
}

class GeoFirestoreIOS {
    
    typealias completionBlock = (_ documentID: String?, _ GeoFirestoreDocument: GeoFirestoreDocument?, _ error: NSError?) -> Void
    
    /**
     * Default precision to be used
     */
    public static var DEFAULT_PRECISION = 10
    
    /**
     * Path where the lat / lng coords will be saved
     */
    public static var GEOPOINT_PATH: String = "l"
    
    /**
     * Path where the geohash will be saved
     */
    public static var GEOHASH_PATH: String = "g"
    
    /**
     * Path where the rest of the data are saved
     */
    public static var DATA_PATH: String = "d"
    
    /**
     * The collection reference to be used
     */
    private var _collectionRef: CollectionReference
    
    /**
     * Saved data in the DB
     */
    public var document: GeoFirestoreDocument?

    /**
     * Initialize a new instance using the given collection reference
     *
     * @param collectionRef The collection reference to be used
     */
    init(collectionRef: CollectionReference) {
        
        self._collectionRef = collectionRef
        
    }
    
    public func get(withDocumentId: String, withCompletionBlock: @escaping (completionBlock)) -> Void {
        
        self._collectionRef.document(withDocumentId).getDocument { (snapshot, error) in
            
            if let snap = snapshot, snap.exists {
                
                var geoPoint: GeoPoint?
                var geoHash = ""
                var doc: [String: Any]?
                
                // Get the geopoint
                if let g = snap.get("l") as? GeoPoint {
                    
                    geoPoint = g
                    
                }
                
                // Get the geoHash
                if let gh = snap.get("g") as? String {
                    
                    geoHash = gh
                    
                }
                
                // Get the rest of the document
                if let d = snap.get("d") as? [String: Any] {
                    
                    doc = d
                    
                }
                
                // Make sure that we got the data required
                if geoPoint != nil && !geoHash.isEmpty {
                    
                    let geoFirestoreDocument = GeoFirestoreDocument(point: geoPoint!, data: doc, geohash: geoHash)
                    
                    withCompletionBlock(withDocumentId, geoFirestoreDocument, nil)
                    
                    return
                    
                }
                else {
                    
                    withCompletionBlock(withDocumentId, nil, NSError(domain: "com.GeoFirestoreIOS.GeoFirestoreIOSError", code: GeoFirestoreIOSError.NO_GEOFIRESTOREIOS_DOCUMENT.rawValue, userInfo: nil))
                    
                    return
                    
                }
                
            }
            else {
                
                withCompletionBlock(withDocumentId, nil, error! as NSError)
                
                return
                
            }
            
        }
        
    }
    
    /**
     * Save GeoFirestoreIOS document in the Firestore
     */
    public func save(data: [String : Any], withCompletionBlock: @escaping (completionBlock)) -> Void {
        
        var e: NSError?
        
        // First make sure that the data given by the user has coordinatesPath
        if let coords = data[GeoFirestoreIOS.GEOPOINT_PATH] as? GeoPoint {
            
            // Encode the coordinates to geoHash
            do {
                
                let gfiosGeoHash = try GFIOSGeoHash.init(latitude: coords.latitude,
                                                         longitude: coords.longitude,
                                                         lPrecision: GeoFirestoreIOS.DEFAULT_PRECISION)
                
                // Copy the data to be saved
                var toBeSavedData = data
                
                // Get the geohash
                let geohash = gfiosGeoHash.getGeoHash()
                
                // Include the geoHash in data
                toBeSavedData[GeoFirestoreIOS.GEOHASH_PATH] = geohash
                
                // Generate a new document ID
                let generatedDocumentID = self._collectionRef.document().documentID;
                
                // Save the data in DB
                self._collectionRef.document(generatedDocumentID).setData(toBeSavedData) { (dbError) in
                    
                    if let e = dbError as NSError? {
                        
                        withCompletionBlock(nil, nil, e)
                        return;
                        
                    }
                    
                    // Generate the GeoFirestoreDocument
                    let doc = GeoFirestoreDocument(point: coords, data: toBeSavedData[GeoFirestoreIOS.DATA_PATH] as? [String : Any], geohash: geohash)
                    
                    withCompletionBlock(generatedDocumentID, doc, nil)
                    return;
                    
                    
                }
                
                return;
                
            }
            catch {
                
                e = error as NSError
                
            }
            
        }
        else {
            
            e = NSError(domain: "com.GeoFirestoreIOS.GeoFirestoreIOSError", code: GeoFirestoreIOSError.NO_GEOPOINT_FOUND_IN_DATA.rawValue, userInfo: nil)
            
        }
        
        withCompletionBlock(nil, nil, e)
        
        return;
        
    }
    
    
}
