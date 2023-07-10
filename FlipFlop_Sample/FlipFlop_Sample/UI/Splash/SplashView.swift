//
//  SplashVC.swift
//  FlipFlop_iOS_Sample
//
//  Created by DoHyoung Kim on 2023/06/30.
//

import Foundation
import UIKit

class SplashView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let logoView = UIImageView(frame: CGRect(x: (frame.width - 167) / 2,
                                                 y: (frame.height - 120) / 2,
                                                 width: 167,
                                                 height: 120))
        logoView.image = UIImage(named: "logo")
        addSubview(logoView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
