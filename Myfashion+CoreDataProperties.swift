//
//  Myfashion+CoreDataProperties.swift
//  nishisuji
//
//  Created by 西筋啓人 on 2017/04/05.
//  Copyright © 2017年 Hiroto Nishisuji. All rights reserved.
//

import Foundation
import CoreData


extension Myfashion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Myfashion> {
        return NSFetchRequest<Myfashion>(entityName: "Myfashion")
    }

    @NSManaged public var checkindate: NSDate?
    @NSManaged public var memo: String?
    @NSManaged public var fashion: String?
    @NSManaged public var saveDate: NSDate?
    @NSManaged public var title: String?

}
