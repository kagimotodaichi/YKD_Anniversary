//
//  MainView.swift
//  YKD_Anniversary
//
//  メイン画面
//  ・Tab切り替え制御
//  ・設定画面の未保存ガード
//  ・破棄時に SettingView を作り直す
//

import SwiftUI

struct MainView: View {

    @State private var user: User           //ユーザー情報
    private let userService = UserService() // Service は1インスタンス
    //service経由でload
    init() {
        let service = UserService()
        _user = State(initialValue: service.load())
    }

    //タブ種類enum
    enum Tab {
        case home       //ホーム画面
        case setting    //設定画面
    }

    // タブ制御
    @State private var selectedTab: Tab = .home
    @State private var pendingTab: Tab? = nil
    
    // 設定画面の未保存状態
    @State private var isSettingDirty = false
    @State private var showDiscardAlert = false
    @State private var requestSaveSetting = false
    
    // SettingView を作り直すためのトリガー
    @State private var settingResetID = UUID()

    var body: some View {

        //タブビュー
        TabView(selection: $selectedTab) {

            // MARK: ホーム画面タブ
            NavigationStack {
                HomeView(user: user)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("ホーム")
            }
            .tag(Tab.home)

            // MARK: 設定画面タブ
            NavigationStack {
                SettingView(
                    user: user,
                    saveRequest: requestSaveSetting,
                    onSave: { updatedUser in
                        user = updatedUser
                        userService.save(updatedUser)
                        isSettingDirty = false
                        settingResetID = UUID()
                        requestSaveSetting = false
                    },
                    onDirtyChange: { dirty in
                        isSettingDirty = dirty
                    },
                    onOpenPairing: { }
                )
                // これが超重要：State を完全リセット
                .id(settingResetID)
            }
            .tabItem {
                Image(systemName: "gear")
                Text("設定")
            }
            .tag(Tab.setting)
        }
        // タブ切り替えガード
        .onChange(of: selectedTab) { _, newTab in
            if isSettingDirty && newTab != .setting {
                pendingTab = newTab
                selectedTab = .setting
                showDiscardAlert = true
            }
        }
        // MARK: 未保存警告
        .alert("変更が保存されていません", isPresented: $showDiscardAlert) {

            //保存して移動ボタン押下
            Button("保存して移動") {
                requestSaveSetting = true   // ★ 保存要求
                if let tab = pendingTab {
                    selectedTab = tab
                }
            }

            //破棄して移動ボタン押下
            Button("破棄して移動", role: .destructive) {
                isSettingDirty = false
                settingResetID = UUID()
                if let tab = pendingTab {
                    selectedTab = tab
                }
            }
            
            //キャンセルボタン押下
            Button("キャンセル", role: .cancel) {}
        }
    }
}

#Preview {
    MainView()
}
