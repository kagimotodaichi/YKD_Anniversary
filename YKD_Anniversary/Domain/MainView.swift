//
//  ContentView.swift
//  YKD_Anniversary
//
//  Created by 鍵本大地 on 2026/01/03.
//

import SwiftUI

struct MainView: View {
    var body: some View {

        TabView{
            //ホーム画面
            NavigationStack{
                HomeView()
            }
            .tabItem{
                Image(systemName: "house.fill")
                Text("ホーム")
            }
            
            
            //設定画面
            NavigationStack{
                SettingView()
            }
            .tabItem{
                Image(systemName: "gear")
                Text("設定")
            }
        }
    }
}

#Preview {
    MainView()
}
