//
//  Diary.swift
//  YKD_Anniversary
//
//  Created by 鍵本大地 on 2026/01/05.
//

import Foundation

struct Diary: Identifiable, Equatable, Codable {
    let id: String          //DiaryId
    let userId: String
    let targetDate: Date    //JST前提
    var content: String
    let updatedAt: Date
    
    init(
        id: String = UUID().uuidString,
        userId: String,
        targetDate: Date,
        content: String,
        updatedAt: Date = Date()
    ){
        self.id = id
        self.userId = userId
        self.targetDate = targetDate
        self.content = content
        self.updatedAt = updatedAt
    }
}
