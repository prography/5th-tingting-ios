//
//  User.swift
//  tingting
//
//  Created by 김선우 on 1/4/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var id: Int?
    var name: String?
    var birth: String?
    var height: Int?
    var thumbnail: String?
    var gender: GenderType?
    var schoolName: String?
    var is_deleted: Int? = 0
    
    init() { }
    
    init(name: String?,
         birth: String?,
         height: Int?,
         thumbnail: String?,
         gender: GenderType?,
         is_deleted: Int)
    {
        self.name = name
        self.birth = birth
        self.height = height
        self.thumbnail = thumbnail
        self.gender = gender
        self.is_deleted = is_deleted
    }
    
}
extension User {
    var age: Int {
        guard let birth = birth else { return -1 }
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-mm-dd"
        guard let bornDate = formatter.date(from: birth) else { return -2 }
        
        let bornYear = getYear(bornDate)
        let thisYear = getYear(Date())
        
        return thisYear - bornYear + 1
    }
 
    private func getYear(_ date: Date) -> Int {
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        let year = formatter.string(from: date)
        return Int(year)!
    }
    
}
