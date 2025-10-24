//
//  LCSegmentedCell.swift
//
//
//  Created by DevLiuSir on 2018/4/26.
//

import Cocoa
import Foundation

/// 自定义的 NSSegmentedCell，用于绘制带有圆角选中背景和文字样式的 Segment。
final public class LCSegmentedCell: NSSegmentedCell {
    
    /// 重绘指定段（segment）的显示内容，包括背景和文本。
    ///
    /// - Parameters:
    ///   - segment: 当前绘制的段索引。
    ///   - frame: 当前段的绘制区域。
    ///   - controlView: 拥有该 cell 的控件视图（通常是 NSSegmentedControl）。
    public override func drawSegment(_ segment: Int, inFrame frame: NSRect, with controlView: NSView) {
        // 判断该 segment 是否为选中状态
        let isSelected = self.isSelected(forSegment: segment)
        
        if isSelected {
            // 绘制选中背景圆角矩形
            NSColor.controlAccentColor.setFill()
            let path = NSBezierPath(
                roundedRect: NSRect(
                    x: frame.origin.x - 8,
                    y: frame.origin.y - 1,
                    width: frame.size.width + 16,
                    height: frame.size.height + 4), xRadius: 5, yRadius: 5 )
            path.fill()
        }
        
        // 获取该 segment 的标题文字
        let label = self.label(forSegment: segment)
        
        // 设置文字属性：字体、颜色（选中为白色，未选中为系统标签颜色）
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 13),
            .foregroundColor: isSelected ? NSColor.white : NSColor.labelColor
        ]
        
        // 计算文字的尺寸
        let textSize = label?.size(withAttributes: attributes)
        guard let width = textSize?.width else { return }
        guard let height = textSize?.height else { return }
        
        // 计算文字绘制区域，使文字居中
        let textRect = NSRect(x: frame.midX - width / 2.0, y: frame.midY - height / 2.0,
                              width: width, height: height)
        
        // 绘制文字
        label?.draw(in: textRect, withAttributes: attributes)
    }
}
