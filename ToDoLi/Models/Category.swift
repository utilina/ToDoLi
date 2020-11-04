//
//  Category.swift
//  ToDoLi
//
//  Created by Анастасия Улитина on 04.11.2020.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    let items = List<Item> ()
}
