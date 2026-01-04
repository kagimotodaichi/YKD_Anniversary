//
//  HomeView.swift
//  YKD_Anniversary
//
//  Created by 鍵本大地 on 2026/01/03.
//
//  ホーム画面
//  設定で選択した設定日からのカウントダウンが表示
//  記念日・イベントがリストで表示

import SwiftUI

struct HomeView: View {
    var body: some View {
        //ホーム画面VStack
        VStack{
            //ヘッダー
            HStack{
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
                    // 背景変更
                    print("背景変更")
                }
                .ignoresSafeArea()
                .opacity(0.5)
                
                Spacer()
                
                //記念日・イベント追加ボタン
                QuarterCircleButton(
                    position: .leftBottom,
                    size: 70,
                    backgroundColor: .pink,
                    iconName: "plus",
                    iconColor: .white,
                    iconSizeRatio: 0.45,
                    iconOffsetRatio: -1
                ) {
                    // 記念日・イベント追加処理
                    print("記念日・イベント追加")
                }
                .ignoresSafeArea()
                .opacity(0.5)
                
            }//ヘッダーHStackここまで

            Text("２人が出会ってから")
            Text("記念日から今までの時間")
            Text("全て・記念日・イベント選択")
            Text("リスト")
            Spacer()
            
        }//ホーム画面VStackここまで
    }//Bodyここまで
}//HomeViewここまで

//プレビュー用
#Preview {
    MainView()
}
