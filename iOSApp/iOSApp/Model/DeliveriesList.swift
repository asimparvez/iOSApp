//
//  File.swift
//  NACTA-Tatheer
//
//  Created by Asim Parvez on 12/6/17.
//  Copyright © 2017 Asim Parvez. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData

class DeliveriesList: Mappable {
    
    
    var array : Array<Delivery>?
    
    required init?(map: Map) {
        
    }
    
    init(deliveries: [Delivery]) {
        array = deliveries
    }
    
    func mapping(map: Map) {
        array   <-  map["data"]
    }
}


class Delivery: NSManagedObject, Mappable {
    
    @NSManaged  var descriptionStr:String
    @NSManaged  var idValue: NSNumber
    @NSManaged  var imageUrl:String
    @NSManaged  var address: String
    @NSManaged  var lat: NSNumber
    @NSManaged  var lng: NSNumber

    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        
        
        super.init(entity: entity, insertInto: CoreDataManager.shared.context)
        
    }

    
    required init?(map: Map) {
        
        let ctx = CoreDataManager.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "Delivery", in: ctx!)
        super.init(entity: entity!, insertInto: ctx)
    }
    
    
    func mapping(map: Map) {
        
        descriptionStr  <- map["description"]
        idValue              <- map["id"]
        imageUrl        <- map["imageUrl"]
        address         <- map["location.address"]
        lat             <- map["location.lat"]
        lng             <- map["location.lng"]

    }
}
