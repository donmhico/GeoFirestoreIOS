//
//  GFIOSGeoHash.swift
//  GeoFirestoreIOS
//
//  Created by Mico on 19/03/2019.
//  Copyright © 2019 HELPEE-TECH INC. All rights reserved.
//

import Foundation

enum GFIOSGeoHashError: Int {
    case INVALID_PRECISION = 201
    case GEOHASH_NOT_GENERATED = 202
}

class GFIOSGeoHash: GeoPointProtocol {
    
    private let BASE32 = Array("0123456789bcdefghjkmnpqrstuvwxyz");
    
    private let BITS_PER_BASE32_CHAR = 4
    
    private let MAX_PRECISION = 22
    
    var lat: Double
    
    var lng: Double
    
    var precision: Int
    
    private var _geoHash: String = ""
    
    init(latitude: Double, longitude: Double, lPrecision: Int) throws {
        
        // Make sure precision is greater than 0
        guard lPrecision > 1 else {
            
            throw NSError(domain: "com.GeoFirestoreIOS.GFIOSGeoHashError", code: GFIOSGeoHashError.INVALID_PRECISION.rawValue, userInfo: nil)
            
        }
        
        // Make sure precision is less than MAX_PRECISION
        guard lPrecision < MAX_PRECISION else {
            
            throw NSError(domain: "com.GeoFirestoreIOS.GFIOSGeoHashError", code: GFIOSGeoHashError.INVALID_PRECISION.rawValue, userInfo: nil)
            
        }

        self.lat = latitude
        self.lng = longitude
        self.precision = lPrecision
        self._geoHash = encodeGeoHash()
        
        // Make sire geoHash isn't empty
        if self._geoHash.isEmpty {
            
            throw NSError(domain: "com.GeoFirestoreIOS.GFIOSGeoHashError", code: GFIOSGeoHashError.GEOHASH_NOT_GENERATED.rawValue, userInfo: nil)
            
        }
        
        
    }
    
    public func getGeoHash() -> String {
        
        return self._geoHash
        
    }
    
    /**
     * Encode location and GeoHash
     *
     * @see https://www.movable-type.co.uk/scripts/geohash.html
     */
    private func encodeGeoHash() -> String {
        
        var index = 0; // index into BASE32 map
        var bit = 0; // each char holds 5 bits
        var evenBit = true;
        var geohash = "";
        
        var latMin: Double =  -90, latMax: Double =  90;
        var lonMin: Double = -180, lonMax: Double = 180;
        
        while (geohash.count < precision) {
            
            if (evenBit) {
                // bisect E-W longitude
                let lonMid = (lonMin + lonMax) / 2;
                
                if (lng >= lonMid) {
                    index = index * 2 + 1;
                    lonMin = lonMid;
                } else {
                    index = index * 2;
                    lonMax = lonMid;
                }
                
            }
            else {
                
                // bisect N-S latitude
                let latMid = (latMin + latMax) / 2;
                
                if (lat >= latMid) {
                    index = index * 2 + 1;
                    latMin = latMid;
                } else {
                    index = index * 2;
                    latMax = latMid;
                }
                
            }
            
            evenBit = !evenBit;
            
            bit = bit + 1
            
            if (bit == 5) {
                
                // 5 bits gives us a character: append it and start over
                geohash.append(BASE32[index])
                bit = 0;
                index = 0;
                
            }
        }
        
        return geohash
        
    }
    
}
