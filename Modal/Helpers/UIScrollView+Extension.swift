//
//  UIScrollView+Extension.swift
//  Modal
//
//  Created by Bruno Alves on 24/08/20.
//  Copyright © 2020 Bruno Alves. All rights reserved.
//

import UIKit

extension UIScrollView {
    func  isNearBottomEdge(edgeOffset: CGFloat = 200) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}
