//
//  ElapsedTimeFormatter.swift
//  YKD_Anniversary
//
//  Created by 鍵本大地 on 2026/01/05.
//
//  経過時間表示用ロジック
//

import Foundation

struct ElapsedTimeFormatter {

    /// 開始日時から現在日時までの経過時間を文字列で返す
    static func format(
        from startDate: Date,
        to now: Date = Date()
    ) -> String {

        let components = Calendar.current.dateComponents(
            [.day, .hour, .minute, .second],
            from: startDate,
            to: now
        )

        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0

        return "\(day)日 \(hour)時間 \(minute)分 \(second)秒"
    }
}
