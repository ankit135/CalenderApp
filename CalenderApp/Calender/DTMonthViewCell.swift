//
//  DTMonthViewCell.swift
//

import UIKit

class DTMonthViewCell: UICollectionViewCell {
    
    var userContentView: UIView? {
        didSet {
            
            if let oldValue = oldValue {
                oldValue.removeFromSuperview()
            }
            
            guard let userContentView = userContentView else { return }
            contentView.addSubview(userContentView)
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let userContentView = userContentView {
            userContentView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height)
        }
    }
}
