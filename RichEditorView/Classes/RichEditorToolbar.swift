//
//  RichEditorToolbar.swift
//
//  Created by Caesar Wirth on 4/2/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//

import UIKit

/// RichEditorToolbarDelegate is a protocol for the RichEditorToolbar.
/// Used to receive actions that need extra work to perform (eg. display some UI)
@objc public protocol RichEditorToolbarDelegate: class {

    /// Called when the Text Color toolbar item is pressed.
    @objc optional func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar)

    /// Called when the Background Color toolbar item is pressed.
    @objc optional func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar)

    /// Called when the Insert Image toolbar item is pressed.
    @objc optional func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar)

    /// Called when the Insert Link toolbar item is pressed.
    @objc optional func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar)
}

/// RichBarButtonItem is a subclass of UIBarButtonItem that takes a callback as opposed to the target-action pattern
open class RichBarButtonItem: UIBarButtonItem {
    open var actionHandler: ((Void) -> Void)?
    
    public convenience init(image: UIImage? = nil, handler: ((Void) -> Void)? = nil) {
        self.init(image: image, style: .plain, target: nil, action: nil)
        target = self
        action = #selector(RichBarButtonItem.buttonWasTapped)
        actionHandler = handler
    }
    
    public convenience init(title: String = "", handler: ((Void) -> Void)? = nil) {
        self.init(title: title, style: .plain, target: nil, action: nil)
        target = self
        action = #selector(RichBarButtonItem.buttonWasTapped)
        actionHandler = handler
    }
    
    func buttonWasTapped() {
        actionHandler?()
    }
}

open class RichButton: UIButton {
    open var actionHandler: ((Void) -> Void)?
    
    public convenience init(image: UIImage? = nil, handler: ((Void) -> Void)? = nil) {
        self.init()
        setImage(image, for: .normal)
        addTarget(self, action: #selector(RichButton.buttonWasTapped), for: .touchUpInside)
        actionHandler = handler
    }
    
    public convenience init(title: String = "", handler: ((Void) -> Void)? = nil) {
        self.init()
        setTitle(title, for: .normal)
        addTarget(self, action: #selector(RichButton.buttonWasTapped), for: .touchUpInside)
        actionHandler = handler
    }
    
    func buttonWasTapped() {
        actionHandler?()
    }
}

/// RichEditorToolbar is UIView that contains the toolbar for actions that can be performed on a RichEditorView
open class RichEditorToolbar: UIView {

    /// The delegate to receive events that cannot be automatically completed
    open weak var delegate: RichEditorToolbarDelegate?

    /// A reference to the RichEditorView that it should be performing actions on
    open weak var editor: RichEditorView?

    /// The list of options to be displayed on the toolbar
    open var options: [RichEditorOption] = [] {
        didSet {
            updateToolbar()
        }
    }

    /// The tint color to apply to the toolbar background.
//    open var barTintColor: UIColor? {
//        get { return backgroundToolbar.barTintColor }
//        set { backgroundToolbar.barTintColor = newValue }
//    }

    private var toolbarScroll: UIScrollView
    private var toolbar: UIView
    
    public override init(frame: CGRect) {
        toolbarScroll = UIScrollView()
        toolbar = UIView()
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        toolbarScroll = UIScrollView()
        toolbar = UIToolbar()
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        autoresizingMask = .flexibleWidth
        backgroundColor = .clear
        
        toolbar.autoresizingMask = .flexibleWidth
        toolbar.backgroundColor = .clear

        toolbarScroll.frame = bounds
        toolbarScroll.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        toolbarScroll.showsHorizontalScrollIndicator = false
        toolbarScroll.showsVerticalScrollIndicator = false
        toolbarScroll.backgroundColor = .clear

        toolbarScroll.addSubview(toolbar)
        
        addSubview(toolbarScroll)
        updateToolbar()
    }
    
    private func updateToolbar() {
        
        toolbar.subviews.forEach { $0.removeFromSuperview() }
        
        var buttons = [UIButton]()
        for option in options {
            let handler = { [weak self] in
                if let strongSelf = self {
                    option.action(strongSelf)
                }
            }

            if let image = option.image {
                let button = RichButton(image: image, handler: handler)
                button.tintColor = option.tintColor
                buttons.append(button)
            } else {
                let title = option.title
                let button = RichButton(title: title, handler: handler)
                button.tintColor = option.tintColor
                buttons.append(button)
            }
        }
        
        let width = 44
        let height = 44
        let totalWidth = buttons.count * width
        for (index, element) in buttons.enumerated() {
            toolbar.addSubview(element)
            element.frame = CGRect(x: index * width, y: 0, width: width, height: height)
        }
        
        toolbar.frame.size = CGSize(width: totalWidth, height: height)
        toolbarScroll.contentSize = toolbar.frame.size
    }
    
}
