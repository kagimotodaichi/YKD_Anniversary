//
//  ContentView.swift
//  YKD_Anniversary
//
//  Created by 鍵本大地 on 2026/01/03.
//
//メイン画面
//タブメニューでの繊維制御のみ

import SwiftUI

struct MainView: View {
    var body: some View {

        //タブビュー
        TabView{
            
            //ホーム画面
            NavigationStack{
                HomeView()  //ホーム画面に遷移(デフォルト)
            }
            .tabItem{
                Image(systemName: "house.fill") //家
                Text("ホーム")
            }//ホーム画面ここまで
            
            
            //設定画面
            NavigationStack{
                SettingView()   //設定画面に遷移
            }
            .tabItem{
                Image(systemName: "gear") //歯車
                Text("設定")
            }//設定画面ここまで
            
        }//タブビューここまで
    }
}

//プレビュー表示用
#Preview {
    MainView()
}
