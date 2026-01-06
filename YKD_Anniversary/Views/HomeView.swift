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
    @State private var partnerUser: User?   //相手側ユーザー情報
    @State private var tempPartnerImage: UIImage?
    @State private var showPartnerImagePicker = false


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
            
            HStack(spacing: 24) {
                Spacer()
                // 自分
                AvatarView(
                    image: user.iconImage,
                    size: 100,
                    isEditable: false,
                    onTap: nil
                )

                Text("♡")
                    .font(.title)

                // 相手
                AvatarView(
                    image: partnerUser?.iconImage ?? tempPartnerImage,
                    size:100,
                    isEditable: partnerUser == nil,
                    onTap: {
                        guard partnerUser == nil else { return }
                        showPartnerImagePicker = true
                    }
                )
                Spacer()
            }
            .padding(.leading, 16)
            
            // MARK: 経過時間
            Text(
                ElapsedTimeFormatter.format(
                    from: user.startDate,
                    to: now
                )
            )
            .font(.title)
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
        //カップル未連携の場合に相手側を画像選択させる為
        .photosPicker(
            isPresented: $showPartnerImagePicker,
            selection: Binding(
                get: { nil },
                set: { item in
                    guard let item else { return }
                    Task {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            tempPartnerImage = image
                        }
                    }
                }
            ),
            matching: .images
        )
    }
}

// プレビュー用
#Preview {
    MainView()
}
