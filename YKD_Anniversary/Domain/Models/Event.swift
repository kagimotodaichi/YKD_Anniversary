//
//  Event.swift
//  YKD_Anniversary
//
//  Created by 鍵本大地 on 2026/01/05.
//

import Foundation

struct Event: Identifiable, Equatable, Codable {
    
    let id: String          //イベントID
    let coupleId: String    //カップルID
    let type: EventType     //イベント種別(記念日orイベント)
    let title: String       //記念日・イベントタイトル
    let eventDate: Date     //記念日・イベント日付
    let memo: String?       //メモ
    let createdBy: String   //作成者
    let updatedBy: String   //更新者
    let updatedAt: Date     //更新日時
    let isDeleted: Bool     //削除フラグ
    
    init(
        id: String,
        coupleId: String,
        type: EventType,
        title: String,
        eventDate: Date,
        memo: String?,
        createdBy: String,
        updatedBy: String,
        updatedAt: Date,
        isDeleted: Bool
    ) {
        self.id = id
        self.coupleId = coupleId
        self.type = type
        self.title = title
        self.eventDate = eventDate
        self.memo = memo
        self.createdBy = createdBy
        self.updatedBy = updatedBy
        self.updatedAt = updatedAt
        self.isDeleted = isDeleted
    }
}
