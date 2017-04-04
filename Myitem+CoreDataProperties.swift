//
//  Myitem+CoreDataProperties.swift
//  nishisuji
//
//  Created by 西筋啓人 on 2017/04/04.
//  Copyright © 2017年 Hiroto Nishisuji. All rights reserved.
//

import Foundation
import CoreData


extension Myitem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Myitem> {
        return NSFetchRequest<Myitem>(entityName: "Myitem")
    }

    @NSManaged public var title: String?
    @NSManaged public var saveDate: NSDate?
    @NSManaged public var collection: String?
    @NSManaged public var memo: String?
    @NSManaged public var checkindate: NSDate?

}
