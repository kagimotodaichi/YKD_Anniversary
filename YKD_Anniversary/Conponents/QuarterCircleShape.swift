//
//  QuarterCircleButton.swift
//
//  Created by 鍵本大地 on 2026/01/04.
//
/// SwiftUI で 1/4円（扇形）＋アイコンを表示するボタンコンポーネント
/// ・4方向（左上 / 右上 / 左下 / 右下）に対応
/// ・レイアウト上も空白が一切残らない
/// ・iPhone / iPad / 横向き / Split View 対応
/// ・引数でアイコン名・サイズ・位置を指定可能（SF Symbols）

import SwiftUI

// MARK: - 1/4円の表示位置
/// 円のどの角を表示するかを表す enum
enum QuarterPosition {
    case leftTop        // 左上
    case rightTop       // 右上
    case leftBottom     // 左下
    case rightBottom    // 右下

    /// 円弧の開始・終了角度（SwiftUI基準）
    ///
    /// SwiftUI の角度定義：
    ///  0°   = 右
    ///  90°  = 下
    /// 180°  = 左
    /// 270°  = 上
    var angles: (start: Double, end: Double) {
        switch self {
        case .rightTop:     return (270, 360)
        case .rightBottom:  return (0, 90)
        case .leftBottom:   return (90, 180)
        case .leftTop:      return (180, 270)
        }
    }

    /// 円の中心点（rect の角）
    /// rect は 1/4円が収まる最小サイズ
    func center(in rect: CGRect) -> CGPoint {
        switch self {
        case .leftTop:
            return CGPoint(x: rect.maxX, y: rect.maxY)
        case .rightTop:
            return CGPoint(x: rect.minX, y: rect.maxY)
        case .leftBottom:
            return CGPoint(x: rect.maxX, y: rect.minY)
        case .rightBottom:
            return CGPoint(x: rect.minX, y: rect.minY)
        }
    }

    /// アイコンの基準表示位置（微調整前）
    private func baseIconPosition(in size: CGSize) -> CGPoint {
        switch self {
        case .rightBottom:
            return CGPoint(x: size.width * 0.75, y: size.height * 0.75)
        case .leftBottom:
            return CGPoint(x: size.width * 0.25, y: size.height * 0.75)
        case .rightTop:
            return CGPoint(x: size.width * 0.75, y: size.height * 0.25)
        case .leftTop:
            return CGPoint(x: size.width * 0.25, y: size.height * 0.25)
        }
    }

    /// アイコンの最終表示位置
    ///
    /// - parameter offsetRatio:
    ///   ボタンサイズに対する割合での微調整値
    ///   0.0 = 基準位置
    ///   正の値 = 中心寄り
    ///   負の値 = 角寄り
    func iconPosition(
        in size: CGSize,
        offsetRatio: CGFloat
    ) -> CGPoint {

        let base = baseIconPosition(in: size)

        // 中心方向へのベクトル
        let dx = (size.width / 2 - base.x) * offsetRatio
        let dy = (size.height / 2 - base.y) * offsetRatio

        return CGPoint(
            x: base.x + dx,
            y: base.y + dy
        )
    }
}

// MARK: - 1/4円 Shape（描画専用）
struct QuarterCircleShape: Shape {

    let position: QuarterPosition

    func path(in rect: CGRect) -> Path {

        var path = Path()

        // rect は 1/4円が収まる最小サイズ
        // 半径は rect の 2 倍（＝元の円の半径）
        let radius = rect.width * 2

        let center = position.center(in: rect)
        let angles = position.angles

        // 円の中心から描画開始
        path.move(to: center)

        // 円弧を描画
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(angles.start),
            endAngle: .degrees(angles.end),
            clockwise: false
        )

        // 扇形として閉じる
        path.closeSubpath()

        return path
    }
}

// MARK: - 扇形＋アイコン ボタン（完成形）
struct QuarterCircleButton: View {

    /// 扇形の向き
    let position: QuarterPosition

    /// 表示サイズ（1/4円の一辺）
    let size: CGFloat

    /// 背景色
    let backgroundColor: Color

    /// 表示する SF Symbols 名
    let iconName: String

    /// アイコン色
    let iconColor: Color

    /// ★追加：アイコンサイズ（割合）
    /// 例：0.22 = 標準
    let iconSizeRatio: CGFloat

    /// アイコン位置の微調整（割合）
    /// 0.0 = 基準位置
    let iconOffsetRatio: CGFloat

    /// タップ時の処理
    let action: () -> Void

    var body: some View {
        Button(action: action) {

            QuarterCircleShape(position: position)
                .fill(backgroundColor)
                .frame(width: size, height: size)

                // アイコンを相対配置で重ねる
                .overlay {
                    GeometryReader { geo in
                        Image(systemName: iconName)
                            .font(
                                .system(
                                    size: geo.size.width * iconSizeRatio,
                                    weight: .bold
                                )
                            )
                            .foregroundColor(iconColor)
                            .position(
                                position.iconPosition(
                                    in: geo.size,
                                    offsetRatio: iconOffsetRatio
                                )
                            )
                    }
                }

                // タップ判定を扇形に限定
                .contentShape(
                    QuarterCircleShape(position: position)
                )
        }
        .buttonStyle(.plain)
    }
}
