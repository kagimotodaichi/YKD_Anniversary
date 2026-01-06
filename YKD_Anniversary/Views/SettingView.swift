//
//  SettingView.swift
//  YKD_Anniversary
//
//  設定画面
//  ・編集UIのみ
//  ・未保存(dirty)通知
//  ・保存要求通知
//

import SwiftUI
import PhotosUI

struct SettingView: View {

    // MainView からの保存要求
    let saveRequest: Bool

    // MARK: - 編集用 State
    @State private var displayName: String
    @State private var statusMessage: String
    @State private var emotionTags: Set<EmotionTag>
    @State private var startDate: Date

    // プロフィール画像（未保存）
    @State private var selectedImage: UIImage?
    @State private var selectedPhotoItem: PhotosPickerItem?

    // MARK: - 受け取り
    private let originalUser: User
    let onSave: (User) -> Void
    let onDirtyChange: (Bool) -> Void
    let onOpenPairing: () -> Void

    // MARK: - Init
    init(
        user: User,
        saveRequest: Bool,
        onSave: @escaping (User) -> Void,
        onDirtyChange: @escaping (Bool) -> Void,
        onOpenPairing: @escaping () -> Void
    ) {
        self.originalUser = user
        self.saveRequest = saveRequest
        self.onSave = onSave
        self.onDirtyChange = onDirtyChange
        self.onOpenPairing = onOpenPairing

        _displayName = State(initialValue: user.displayName)
        _statusMessage = State(initialValue: user.statusMessage ?? "")
        _emotionTags = State(initialValue: user.emotionTags)
        _startDate = State(initialValue: user.startDate)
    }

    // MARK: - 差分判定
    private var hasChanges: Bool {
        displayName != originalUser.displayName ||
        statusMessage != (originalUser.statusMessage ?? "") ||
        emotionTags != originalUser.emotionTags ||
        startDate != originalUser.startDate ||
        selectedImage != nil
    }

    // MARK: - 表示用プロフィール画像
    private var displayImage: UIImage? {
        selectedImage ?? ImageService.loadImage(from: originalUser.iconUrl)
    }

    var body: some View {
        Form {

            // MARK: ユーザー情報
            Section(header: Text("ユーザー情報")) {

                HStack {
                    Spacer()
                    ZStack {
                        if let image = displayImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .padding(24)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(width: 120, height: 120)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
                    Spacer()
                }
                .padding(.vertical)

                PhotosPicker(
                    selection: $selectedPhotoItem,
                    matching: .images
                ) {
                    Text("プロフィール画像を選択")
                }

                // 表示名
                TextField("表示名", text: $displayName)
                    .onChange(of: displayName) {
                        onDirtyChange(hasChanges)
                    }

                // ステータスメッセージ
                TextField("出会ってから", text: $statusMessage)
                    .onChange(of: statusMessage) {
                        onDirtyChange(hasChanges)
                    }
            }

            // MARK: 交際開始日
            Section(header: Text("交際開始日")) {
                DatePicker(
                    "開始日",
                    selection: $startDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .onChange(of: startDate) {
                    onDirtyChange(hasChanges)
                }
            }

            // MARK: 感情タグ
            Section(header: Text("気分（複数選択可）")) {
                ForEach(EmotionTag.allCases, id: \.self) { tag in
                    Toggle(
                        tag.rawValue,
                        isOn: Binding(
                            get: { emotionTags.contains(tag) },
                            set: { isOn in
                                if isOn {
                                    emotionTags.insert(tag)
                                } else {
                                    emotionTags.remove(tag)
                                }
                                onDirtyChange(hasChanges)
                            }
                        )
                    )
                }
            }

            // MARK: カップル共有
            Section(header: Text("カップル共有")) {

                if let coupleId = originalUser.coupleId {
                    Text("カップルID：\(coupleId)")
                        .font(.footnote)
                } else {
                    Text("未連携")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Button {
                    onOpenPairing()
                } label: {
                    Label("共有・連携画面を開く", systemImage: "person.2.fill")
                }
            }
        }
        .navigationTitle("設定")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("保存") {
                    save()
                }
                .disabled(!hasChanges)
            }
        }
        // 外部からの保存要求
        .onChange(of: saveRequest) {
            guard saveRequest else { return }
            save()
        }
        // 画像選択後
        .onChange(of: selectedPhotoItem) {
            guard let item = selectedPhotoItem else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                    onDirtyChange(hasChanges)
                }
            }
        }
    }

    // MARK: - 保存処理
    private func save() {
        guard hasChanges else { return }

        var iconUrl = originalUser.iconUrl

        // 新しく画像が選ばれていたら保存
        if let image = selectedImage {
            iconUrl = ImageService.save(image: image)
        }

        let updatedUser = User(
            id: originalUser.id,
            coupleId: originalUser.coupleId,
            displayName: displayName,
            iconUrl: iconUrl,
            startDate: startDate,
            statusMessage: statusMessage.isEmpty ? nil : statusMessage,
            emotionTags: emotionTags,
            updatedAt: Date()
        )

        onSave(updatedUser)
        onDirtyChange(false)
    }
}
