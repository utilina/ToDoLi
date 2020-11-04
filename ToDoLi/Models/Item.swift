//
//  Item.swift
//  ToDoLi
//
//  Created by Анастасия Улитина on 04.11.2020.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

