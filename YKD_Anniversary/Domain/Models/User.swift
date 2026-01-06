//
//  User.swift
//  YKD_Anniversary
//
//  Created by 鍵本大地 on 2026/01/05.
//

import Foundation
import UIKit

struct User: Identifiable, Equatable, Codable {
    
    let id: String                      //ユーザーID
    let coupleId: String?               //カップルID
    let displayName: String             //表示名
    let iconUrl: String?                //プロフィール画像URL
    let startDate: Date                 //カウント開始日
    let statusMessage: String?          //始まり文字列
    let emotionTags: Set<EmotionTag>    //感情タグ
    let updatedAt: Date                 //更新日時

    init(
        id: String = UUID().uuidString,
        coupleId: String? = nil,
        displayName: String,
        iconUrl: String? = nil,
        startDate: Date = Date(),
        statusMessage: String? = nil,
        emotionTags: Set<EmotionTag> = [],
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.coupleId = coupleId
        self.displayName = displayName
        self.iconUrl = iconUrl
        self.startDate = startDate
        self.statusMessage = statusMessage
        self.emotionTags = emotionTags
        self.updatedAt = updatedAt
    }
    
}
extension User {
    var iconImage: UIImage? {
        ImageService.loadImage(from: iconUrl)
    }
}
