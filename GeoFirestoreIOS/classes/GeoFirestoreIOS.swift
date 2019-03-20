//
//  GeoFirestoreIOS.swift
//  GeoFirestoreIOS
//
//  Created by Mico on 19/03/2019.
//  Copyright © 2019 HELPEE-TECH INC. All rights reserved.
//

import Foundation
import FirebaseFirestore

class GeoFirestoreIOS {
    
    /**
     * Path where the lat / lng coords will be saved
     */
    public static var coordinatesPath: String = "l"
    
    /**
     * Path where the geohash will be saved
     */
    public static var geoHashPath: String = "h"
    
    /**
     * The collection reference to be used
     */
    private var collectionRef: CollectionReference
    
    /**
     * Initialize a new instance using the given collection reference
     *
     * @param collectionRef The collection reference to be used
     */
    init(collectionRef: CollectionReference) {
        
        self.collectionRef = collectionRef
        
    }
    
    
}
