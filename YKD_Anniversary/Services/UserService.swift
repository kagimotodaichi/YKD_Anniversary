//
//  UserService.swift
//  YKD_Anniversary
//
//  Created by 鍵本大地 on 2026/01/05.
//


import Foundation

final class UserService {

    private let key = "local_user"

    // 読み込み
    func load() -> User {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let user = try? JSONDecoder().decode(User.self, from: data)
        else {
            // 初回起動 or 保存なしの場合
            return User(
                displayName: "",
                statusMessage: "出会ってから"
            )
        }
        return user
    }

    // 保存
    func save(_ user: User) {
        guard let data = try? JSONEncoder().encode(user) else {
            return
        }
        UserDefaults.standard.set(data, forKey: key)
    }

    //全削除したい時用
    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
