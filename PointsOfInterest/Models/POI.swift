//
//  POI.swift
//  PointsOfInterest
//
//  Created by elias on 9/8/21.
//

import Foundation
import RealmSwift

class POI: Object {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var geocoordinates = ""
    @objc dynamic var desc: String? = nil
    @objc dynamic var email: String? = nil
    @objc dynamic var phone: String? = nil
    @objc dynamic var transport: String? = nil
    @objc dynamic var address: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // Create POI from JSON
    convenience init(value: [String : Any]) {
        self.init()
        value.forEach { (key, value) in
            switch key {
            case "id":
                if let id = (value as? NSString)?.intValue {
                    self.id = Int(id)
                }
            case "title":
                self.title = (value as? String)!
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            case "geocoordinates":
                self.geocoordinates = (value as? String)!
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            case "description":
                self.desc = ["null", "undefined"]
                    .contains((value as? String)?.trimmingCharacters(in: .whitespacesAndNewlines))
                    ? nil
                    : (value as? String)
            case "email":
                self.email = ["null", "undefined"]
                    .contains((value as? String)?.trimmingCharacters(in: .whitespacesAndNewlines))
                    ? nil
                    : (value as? String)
            case "phone":
                self.phone = ["null", "undefined"]
                    .contains((value as? String)?.trimmingCharacters(in: .whitespacesAndNewlines))
                    ? nil
                    : (value as? String)
            case "transport":
                self.transport = ["null", "undefined"]
                    .contains((value as? String)?.trimmingCharacters(in: .whitespacesAndNewlines))
                    ? nil
                    : (value as? String)
            case "address":
                self.address = ["null", "undefined"]
                    .contains((value as? String)?.trimmingCharacters(in: .whitespacesAndNewlines))
                    ? nil
                    : (value as? String)
            default:
                print("none")
            }
        }
    }
}
