//
//  Category.swift
//  ToDoApp
//
//  Created by Sonali Patel on 9/18/18.
//  Copyright © 2018 Sonali Patel. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
