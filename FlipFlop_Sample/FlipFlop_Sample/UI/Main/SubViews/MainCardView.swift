//
//  MainCardView.swift
//  FlipFlop_iOS_Sample
//
//  Created by DoHyoung Kim on 2023/06/30.
//

import Foundation
import UIKit

class MainCardView: UIView {
    
    init(frame: CGRect, type: Int) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = 10
        layer.masksToBounds = false
        
        let titleLabel = UILabel(frame: CGRect(x: 30,
                                               y: 30,
                                               width: frame.width - 60,
                                               height: 26))
        titleLabel.backgroundColor = .clear
        titleLabel.attributedText = NSAttributedString(string: type == 0 ? "LIVE Streaming" : "Video List",
                                                       attributes: [
                                                        .foregroundColor: UIColor.black,
                                                        .font: UIFont.systemFont(ofSize: 20, weight: .bold)
                                                       ])
        titleLabel.sizeToFit()
        addSubview(titleLabel)
        
        let descLabel = UILabel(frame: CGRect(x: 30,
                                              y: titleLabel.getGapPos(gap: 10).y,
                                              width: frame.width - 60,
                                              height: 26))
        descLabel.backgroundColor = .clear
        descLabel.attributedText = NSAttributedString(string: type == 0 ? "Live streaming description" : "Video list description",
                                                      attributes: [
                                                        .foregroundColor: UIColor.greyishBrown,
                                                        .font: UIFont.systemFont(ofSize: 12, weight: .regular)
                                                      ])
        descLabel.sizeToFit()
        addSubview(descLabel)
        
        let imgView = UIImageView(frame: CGRect(x: frame.width - 180,
                                                y: frame.height - 110,
                                                width: 180,
                                                height: 100))
        imgView.image = UIImage(named: type == 0 ? "demoImg1" : "demoImg2")
        addSubview(imgView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
