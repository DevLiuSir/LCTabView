//
//  LCTabView.swift
//
//
//  Created by DevLiuSir on 2018/4/26.
//


import Cocoa
import Foundation


/// `LCTabView` 是一个自定义的 `NSTabView`，它使用一个自绘的 `NSSegmentedControl` 来替代系统默认的选项卡按钮，
/// 提供更灵活和美观的样式。
final public class LCTabView: NSTabView {
    
    /// 自定义的分段控件，用于替代默认的 tab 按钮
    private var customSegmentedControl: NSSegmentedControl?
    
    /// 初始化方法（使用 frame 初始化）
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialize()
    }
    
    /// 初始化方法（用于解档，比如在 Interface Builder 中使用）
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    /// 初始化自定义 segmentedControl 并添加到视图中
    private func initialize() {
        delegate = self
        let segmentedControl = NSSegmentedControl()
        segmentedControl.cell = LCSegmentedCell() // 使用自定义绘制 cell
        segmentedControl.segmentCount = self.numberOfTabViewItems
        segmentedControl.selectedSegment = 0
        segmentedControl.target = self
        segmentedControl.action = #selector(segmentedControlChanged)
        self.customSegmentedControl = segmentedControl
        self.addSubview(segmentedControl)
        refreshSegmentedControl()
    }
    
    /// 在视图布局更新时调整 segmentedControl 的位置
    public override func layout() {
        super.layout()
        guard let segmentedControl = customSegmentedControl else { return }
        
        if hasDefaultSegment() {
            // 如果存在系统默认的 segmentedControl，则移除自定义控件
            segmentedControl.removeFromSuperview()
            customSegmentedControl = nil
        } else {
            // 遍历子视图找到系统的 tab 按钮视图（NSTabViewButtons），隐藏它并使用其 frame 设置自定义 segmentedControl 的位置
            for subview in subviews {
                if String(describing: type(of: subview)) == "NSTabViewButtons" {
                    subview.isHidden = true
                    segmentedControl.frame = subview.frame
                }
            }
        }
    }
    
    /// 检查当前 tabView 是否已经有系统默认的 segmentedControl
    private func hasDefaultSegment() -> Bool {
        let ivar = class_getInstanceVariable(LCTabView.self, "_segmentedControl")
        if ivar != nil {
            if let value = self.value(forKey: "_segmentedControl") as? NSSegmentedControl {
                return value.isKind(of: NSSegmentedControl.self)
            }
        }
        return false
    }
    
    /// 添加一个新的 tabItem，并刷新 segmentedControl
    public override func addTabViewItem(_ tabViewItem: NSTabViewItem) {
        super.addTabViewItem(tabViewItem)
        if !hasDefaultSegment() {
            refreshSegmentedControl()
        }
    }
    
    /// 切换选中的 tab，同时更新 segmentedControl 的选中状态
    public override func selectTabViewItem(at index: Int) {
        super.selectTabViewItem(at: index)
        if !hasDefaultSegment() {
            customSegmentedControl?.selectedSegment = index
        }
    }
    
    /// 刷新 segmentedControl 的 segment 数量和每个 segment 的标签
    private func refreshSegmentedControl() {
        guard let segmentedControl = customSegmentedControl else { return }
        
        segmentedControl.segmentCount = self.numberOfTabViewItems
        for i in 0..<self.numberOfTabViewItems {
            segmentedControl.setLabel(self.tabViewItems[i].label, forSegment: i)
        }
        
        if let selectedItem = self.selectedTabViewItem {
            segmentedControl.selectedSegment = indexOfTabViewItem(selectedItem)
        } else {
            segmentedControl.selectedSegment = 0
        }
    }
    
    /// 当用户点击 segmentedControl 切换 tab 时触发的回调
    @objc private func segmentedControlChanged() {
        if let selectedIndex = customSegmentedControl?.selectedSegment {
            selectTabViewItem(at: selectedIndex)
        }
    }
}


// MARK: - NSTabViewDelegate
extension LCTabView: NSTabViewDelegate {
    // Tab 将要切换时调用
    public func tabView(_ tabView: NSTabView, willSelect tabViewItem: NSTabViewItem?) {
        // print("将要切换到: \(tabViewItem?.label ?? "unknown")")
    }
    
    // Tab 已经切换后调用
    public func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        // print("已经切换到: \(tabViewItem?.label ?? "unknown")")
        // 确保 segmented control 的选中状态同步
        if let item = tabViewItem {
            let index = indexOfTabViewItem(item)
            customSegmentedControl?.selectedSegment = index
            customSegmentedControl?.needsDisplay = true
        }
    }
}
