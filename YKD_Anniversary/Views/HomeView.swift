//
//  HomeView.swift
//  YKD_Anniversary
//
//  Created by 鍵本大地 on 2026/01/03.
//
//  ホーム画面
//  ・ステータスメッセージ表示
//  ・記念日から現在までの経過時間をリアルタイム表示
//

import SwiftUI

struct HomeView: View {

    let user: User   // ユーザー情報

    // 現在時刻(1秒ごとに更新)
    @State private var now: Date = Date()

    var body: some View {

        VStack {

            // MARK: ヘッダー
            HStack {

                // 背景変更ボタン
                QuarterCircleButton(
                    position: .rightBottom,
                    size: 70,
                    backgroundColor: .blue,
                    iconName: "photo.fill",
                    iconColor: .white,
                    iconSizeRatio: 0.4,
                    iconOffsetRatio: -1
                ) {
                    print("背景変更")
                }
                .ignoresSafeArea()
                .opacity(0.5)

                Spacer()

                // 記念日・イベント追加ボタン
                QuarterCircleButton(
                    position: .leftBottom,
                    size: 70,
                    backgroundColor: .pink,
                    iconName: "plus",
                    iconColor: .white,
                    iconSizeRatio: 0.45,
                    iconOffsetRatio: -1
                ) {
                    print("記念日・イベント追加")
                }
                .ignoresSafeArea()
                .opacity(0.5)
            }

            Spacer().frame(height: 24)

            // ステータスメッセージ
            Text("2人が" + (user.statusMessage ?? "出会ってから"))
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 46)
            
            // MARK: 経過時間
            Text(
                ElapsedTimeFormatter.format(
                    from: user.startDate,
                    to: now
                )
            )
            .font(.title2)
            .fontWeight(.semibold)
            .monospacedDigit()
            .padding(.top, 4)

            Spacer().frame(height: 32)

            // MARK: TODO: フィルタ & リスト（仮)
            Text("全て・記念日・イベント選択")
                .font(.footnote)
                .foregroundColor(.secondary)

            Text("リスト")
                .foregroundColor(.secondary)

            Spacer()
        }
        // MARK: 1秒ごとに現在時刻更新
        .onReceive(
            Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        ) { _ in
            now = Date()
        }
    }
}

// プレビュー用
#Preview {
    MainView()
}
