//
//  Category.swift
//  NewsDemo
//
//  Created by Arkar on 07/11/2023.
//

import SwiftyJSON

struct Category {
    let categoryName: String
    let image: String
    let createdOn: String
    let id: String
    let sort: String
    var  isSelected: Bool  
    let isDeleted: Bool

    init(json: JSON) {
        categoryName = json["category_name"].stringValue
        image = json["image"].stringValue
        id = json["_id"].stringValue
        sort = json["sort"].stringValue
        createdOn = json["created_on"].stringValue
        isSelected = json["is_selected"].boolValue
        isDeleted = json["is_deleted"].boolValue
    }
}
