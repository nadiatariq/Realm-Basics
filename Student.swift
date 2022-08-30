//
//  Student.swift
//  DBFormForStudent
//
//  Created by sameeltariq on 19/08/2022.
//

import Foundation
import RealmSwift
class Student: Object{
    @objc  dynamic var ID = ""

     @objc  dynamic var rollNo = 0
    @objc dynamic var name : String?
    
    override static func primaryKey() -> String? {
       return  "rollNo"
     }
}
