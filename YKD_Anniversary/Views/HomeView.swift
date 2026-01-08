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
import PhotosUI

struct HomeView: View {

    let user: User                          // 自分
    @State private var partnerUser: User?   // 連携済みの相手
    @State private var tempPartnerImage: UIImage?
    @State private var showPartnerImagePicker = false

    // 現在時刻（1秒更新）
    @State private var now: Date = Date()

    // MARK: - 相手アバター表示用画像
    private var displayPartnerImage: UIImage? {

        // 連携済み → 相手ユーザーの画像
        if let partnerUser {
            return partnerUser.iconImage
        }

        // 未連携 → 自分が設定した相手用画像
        if let savedPartnerImage = user.partnerIconImage {
            return savedPartnerImage
        }

        // 未保存 → 一時選択画像
        if let tempPartnerImage {
            return tempPartnerImage
        }

        return nil
    }

    var body: some View {

        VStack {

            // MARK: ヘッダー
            HStack {

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

            // MARK: ステータスメッセージ
            Text("2人が" + (user.statusMessage ?? "出会ってから"))
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 46)

            // MARK: アバター
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
                    image: displayPartnerImage,
                    size: 100,
                    isEditable: partnerUser == nil && user.partnerIconImage == nil,
                    onTap: {
                        guard partnerUser == nil,
                              user.partnerIconImage == nil
                        else { return }

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

            // 仮コンテンツ
            Text("全て・記念日・イベント選択")
                .font(.footnote)
                .foregroundColor(.secondary)

            Text("リスト")
                .foregroundColor(.secondary)

            Spacer()
        }

        // MARK: 現在時刻更新
        .onReceive(
            Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        ) { _ in
            now = Date()
        }

        // MARK: 未連携時の相手画像選択
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

// プレビュー
#Preview {
    MainView()
}
