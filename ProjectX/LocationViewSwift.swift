//
//  LocationViewSwift.swift
//  ProjectX
//
//  Created by aadhya on 8/6/19.
//  Copyright © 2019 Charge. All rights reserved.
//

import UIKit
import Firebase
class LocationViewSwift: UIViewController {

    var db : Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        
        getDocumentNearBy(latitude: 38.819, longitude: -122.47, distance: 10)
        
        // Do any additional setup after loading the view.
    }
    func getDocumentNearBy(latitude: Double, longitude: Double, distance: Double) {
        
        // ~1 mile of lat and lon in degrees
        let lat = 0.0144927536231884
        let lon = 0.0181818181818182
        
        let lowerLat = latitude - (lat * distance)
        let lowerLon = longitude - (lon * distance)
        
        let greaterLat = latitude + (lat * distance)
        let greaterLon = longitude + (lon * distance)
        
        let lesserGeopoint = GeoPoint(latitude: lowerLat, longitude: lowerLon)
        let greaterGeopoint = GeoPoint(latitude: greaterLat, longitude: greaterLon)
        
        let docRef = Firestore.firestore().collection("Event")
        let query = docRef.whereField("location", isGreaterThan: lesserGeopoint).whereField("location", isLessThan: greaterGeopoint)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    print("\(document.documentID) => \(document.data()["name"])")
                }
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
