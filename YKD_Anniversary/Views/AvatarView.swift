//
//  AvatarView.swift
//  YKD_Anniversary
//
//  Created by 鍵本大地 on 2026/01/06.
//

import SwiftUI

struct AvatarView: View {

    let image: UIImage?
    let size: CGFloat
    let isEditable: Bool
    let onTap: (() -> Void)?

    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .contentShape(Circle())
        .onTapGesture {
            guard isEditable else { return }
            onTap?()
        }
    }
}
