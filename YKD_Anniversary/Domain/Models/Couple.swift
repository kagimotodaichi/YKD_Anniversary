//
//  Couple.swift
//  YKD_Anniversary
//
//  Created by 鍵本大地 on 2026/01/05.
//

import Foundation

struct Couple: Identifiable, Equatable, Codable {
    let id: String              // カップルID
    let startDate: Date         //開始日
    let createdAt: Date         //作成日

    init(
        id: String = UUID().uuidString,
        startDate: Date,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.startDate = startDate
        self.createdAt = createdAt
    }
}
