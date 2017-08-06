//
//  LocationViewController.swift
//  NYPITP312
//
//  Created by Ng Wan Ying on 3/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Eureka
import GooglePlaces
import GooglePlacesRow

protocol SendLocationDelegate {
    func sendLocation(location: String! , locName: String!)
}



class LocationViewController: FormViewController {
    
    var delegate: SendLocationDelegate?
    
    // var a : GooglePlace
    var placesClient: GMSPlacesClient!
    var userPlaceId : String!
    var userGeoLocation : CLLocationCoordinate2D!
    var locationName : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        
        self.form = Form()
            +++ Section("Default row")
            <<< GooglePlacesAccessoryRow("nyan")
            +++ Section("Select preferred location meet up")
            <<< GooglePlacesTableRow("nyan2"){ row in
                row.onNetworkingError = { error in
                    print(error)
                }
                row.placeFilter?.country = "SG"
                row.placeFilter?.type = .address
                
                
            }
            
            
            
            //                .cellUpdate{ cell, row in
            //                    if row.wasChanged{
            //                    row.displayValueFor = {(a: (GooglePlace?)) in
            //                        var s = a as! GMSAutocompletePrediction
            //                        s.placeID
            //                        s.types[1]
            //
            //                        print(s.types[1])
            //                        print(s.placeID!)
            //
            //                        return s.placeID!
            //                    }
            //                    }
            //
            //            }
            
            
            
            +++ Section()
            <<< LabelRow(){ row in
                row.title = "Print values to console"
                }.cellSetup { cell, row in
                    cell.textLabel?.textAlignment = .center
                }.onCellSelection { cell, row in
                    for (tag, value) in row.section?.form?.values() ?? [:] {
                        if let val = value {
                            print("row \(tag) = \(val)")
                        } else {
                            print("row \(tag) = nil")
                        }
                    }
                    print("------------------------------")
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        var bookForm = form.values()
        var s : GooglePlace
        
        let row: GooglePlacesTableRow? = form.rowBy(tag: "nyan2")
        
        //  var kk : GMSAutocompletePrediction
        
        print(bookForm["nyan2"]! as! GooglePlace)
        s =  bookForm["nyan2"] as! GooglePlace
        
        //        let place: GooglePlace = row!.value!
        //
        //            switch place {
        //            case let GooglePlace.userInput(p):
        //            return val
        //            case let GooglePlace.prediction(pred):
        //            return pred.attributedFullText.string
        //            }
        //
        
        
        let place: GooglePlace = row!.value!
        
        switch place {
        case .userInput(value: let val):
            //  return val
            print(val)
        case .prediction(prediction: let pred):
            //   return pred.attributedFullText.string
            print(pred.placeID!)
            userPlaceId = pred.placeID
            //   pred.types["geocode"]
            
        }
        
        placesClient.lookUpPlaceID(userPlaceId, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(self.userPlaceId)")
                return
            }
            
            print("Place attributions \(place.coordinate)")
            self.userGeoLocation = place.coordinate
            self.locationName = place.name
            
            self.delegate?.sendLocation(location: self.userPlaceId, locName: self.locationName)
            
        })
          _ = navigationController?.popViewController(animated: true)
        
    }
    
    
}


       
