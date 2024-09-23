//
//  ViewController.swift
//  DRTruncationLabel
//
//  Created by 吴灶洲 on 2024/9/23.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var truncationLabel: DRTruncationLabel = {
        let view = DRTruncationLabel()
        view.numberOfLines = 3
        view.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.orange.cgColor
        view.layer.borderWidth = 0.5
        view.addTarget(self, action: #selector(didClickLabelAction), for: .touchUpInside)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(truncationLabel)
        truncationLabel.frame = CGRect(x: 10, y: 100, width: UIScreen.main.bounds.width-20, height:  200)
        
        
        truncationLabel.attributedText = NSMutableAttributedString(string: "是的话是谁的 护手霜的奥斯岛的的哦的ho打的的打的大大萨热让人啊让大大大让阿达达达达达达达法儿而让大大丰富肉色如清热闻风丧胆粉色的防晒乳粉啊大叔大大分为热舞范围覆盖维特温热为人父为额外让微风微风温热温热为人沃尔维斯福斯特让我通过闺蜜俄方很佩服我i哦额我我认为红色方式分为哦让我平日平稳而为 ")
        truncationLabel.numberOfLines = 3
        truncationLabel.reload()
    }
    
    
    @objc private func didClickLabelAction() {
        truncationLabel.isOpen.toggle()
        truncationLabel.reload()
    }

}

