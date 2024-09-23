//
//  DRTruncationLabel.swift
//  DRTruncationLabel
//
//  Created by 吴灶洲 on 2024/9/23.
//

import UIKit



class DRTruncationLabel: UIControl {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var textLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var displayAttributedText: NSAttributedString?

    var truncationToken: (open: NSAttributedString, close: NSAttributedString) = (
        NSAttributedString(string: " ... [展开]", attributes: [
            .foregroundColor: UIColor(red: 31/255.0, green: 112/255.0, blue: 255/255.0, alpha: 1.0)
        ]),
        NSAttributedString(string: " [折叠]", attributes: [
            .foregroundColor: UIColor(red: 31/255.0, green: 112/255.0, blue: 255/255.0, alpha: 1.0)
        ])
    )
    
    var attributedText: NSMutableAttributedString? {
        didSet {
            guard attributedText != oldValue else { return }
            displayAttributedText = attributedText

        }
    }

    var isOpen = false
    var numberOfLines: Int = 3
    var contentEdgeInsets: UIEdgeInsets = .zero
}


private extension DRTruncationLabel {
    func initSubViews() {
        addSubview(textLabel)
    }
}


extension DRTruncationLabel {
    func reload() {
        guard let attributedText = attributedText, let textFont = textLabel.font else { return  }
        attributedText.addAttribute(.font, value: textFont , range: NSRange(location: 0, length: attributedText.string.count))
        
        guard Thread.isMainThread else { return DispatchQueue.main.async { self.reload() } }
        textLabel.frame = self.bounds;
        textLabel.backgroundColor = UIColor.red
        self.backgroundColor = UIColor.blue
        let width = self.frame.size.width
        let lines = attributedText.lines(width)
        if numberOfLines > 0,
           lines.count >= numberOfLines
        {
            let additionalAttributedText = isOpen ? truncationToken.close : truncationToken.open
            let length = lines.prefix(numberOfLines).reduce(0) { $0 + CTLineGetStringRange($1).length }
            textLabel.attributedText = additionalAttributedText
            let truncationTokenWidth = textLabel.sizeThatFits(.zero).width
            let maxLength = isOpen ? attributedText.length : min(CTLineGetStringIndexForPosition(lines[numberOfLines - 1], CGPoint(x: width - truncationTokenWidth, y: 0)), length) - 1
            displayAttributedText = {
                let attributedText = NSMutableAttributedString(attributedString: attributedText.attributedSubstring(from: NSRange(location: 0, length: maxLength)))
                attributedText.append(additionalAttributedText)
                return attributedText
            }()
        }
        textLabel.attributedText = displayAttributedText
    }

}

extension NSAttributedString {
    /// 计算行数
    func calculateLines(_ width: CGFloat) -> Int {
        lines(width).count
    }

    /// 根据字体和每一行宽度切割字符串
    func separatedLines(_ width: CGFloat) -> [NSAttributedString] {
        let lines = lines(width)
        var linesArray = [NSAttributedString]()
        for line in lines {
            let lineRange: CFRange = CTLineGetStringRange(line)
            let range = NSRange(location: lineRange.location, length: lineRange.length)
            linesArray.append(attributedSubstring(from: range))
        }
        return linesArray
    }

    /// ctLines array
    func lines(_ width: CGFloat) -> [CTLine] {
        let framesetter = CTFramesetterCreateWithAttributedString(self)
        let path = CGMutablePath(rect: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude), transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        return CTFrameGetLines(frame) as? [CTLine] ?? []
    }
}
