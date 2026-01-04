//
//  HomeView.swift
//  YKD_Anniversary
//
//  Created by 鍵本大地 on 2026/01/03.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack{
            //ヘッダー
            HStack{
                Text("背景変更ボタン")
                    .padding(20)
                Spacer()
                Text("予定追加ボタン")
                    .padding(20)
                
            }
            Spacer()
            Text("記念日から今までの時間")
            Text("全て・記念日・イベント選択")
            Text("リスト")
            Spacer()
        }
    }
}

#Preview {
    HomeView()
}
