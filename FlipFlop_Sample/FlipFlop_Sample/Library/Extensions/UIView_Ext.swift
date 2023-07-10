//
//  UIView_Ext.swift
//  FlipFlop_iOS_Sample
//
//  Created by DoHyoung Kim on 2023/06/30.
//

import Foundation
import UIKit

extension UIView {
    func getGapPos(gap: CGFloat) -> CGPoint {
        return CGPoint(x: self.frame.origin.x + self.frame.size.width + gap,
                       y: self.frame.origin.y + self.frame.size.height + gap)
    }
    
    func findViewController() -> UIViewController? {
            if let nextResponder = self.next as? UIViewController {
                return nextResponder
            } else if let nextResponder = self.next as? UIView {
                return nextResponder.findViewController()
            } else {
                return nil
            }
        }
}
