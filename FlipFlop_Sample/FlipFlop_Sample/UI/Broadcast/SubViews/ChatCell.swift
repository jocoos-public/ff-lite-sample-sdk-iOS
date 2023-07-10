//
//  ChatCell.swift
//  FlipFlop_Sample
//
//  Created by DoHyoung Kim on 2023/07/06.
//

import Foundation
import UIKit
import FlipFlopLiteSDK

class ChatCell: UITableViewCell {
    
    public var cellHeight: CGFloat = 0
    
    private var userNMLabel: UILabel!
    private var messageLabel: UILabel!
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, message: FFMessage, fullWidth: CGFloat) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        if message.type == "JOIN" {
            let bgView = UIView(frame: CGRect(x: 0,
                                              y: 10,
                                              width: fullWidth,
                                              height: 25))
            bgView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            bgView.layer.cornerRadius = 12.5
            bgView.layer.masksToBounds = true
            addSubview(bgView)
            
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            
            let label = UILabel(frame: CGRect(x: 13,
                                              y: 0,
                                              width: bgView.frame.width - 26,
                                              height: 20))
            label.backgroundColor = .clear
            label.attributedText = NSAttributedString(string: "🥳\(message.userName) 님이 입장하셨습니다.",
                                                      attributes: [
                                                        .foregroundColor: UIColor.white,
                                                        .font: UIFont.systemFont(ofSize: 11, weight: .bold),
                                                        .paragraphStyle: style
                                                      ])
            bgView.addSubview(label)
            cellHeight = bgView.getGapPos(gap: 20).y
            
        } else {
            userNMLabel = UILabel(frame: CGRect(x: 0,
                                                y: 0,
                                                width: fullWidth / 3,
                                                height: 17))
            userNMLabel.backgroundColor = .clear
            userNMLabel.attributedText = NSAttributedString(string: message.userName,
                                                            attributes: [
                                                                .foregroundColor: message.data == "OWNER" ? UIColor.macaroniCheese : UIColor.white,
                                                                .font: UIFont.systemFont(ofSize: 11, weight: .medium)
                                                            ])
            userNMLabel.sizeToFit()
            addSubview(userNMLabel)
            
            messageLabel = UILabel(frame: CGRect(x: userNMLabel.getGapPos(gap: 5).x,
                                                 y: 0,
                                                 width: fullWidth * 2 / 3,
                                                 height: 17))
            messageLabel.backgroundColor = .clear
            messageLabel.numberOfLines = 0
            messageLabel.attributedText = NSAttributedString(string: message.message,
                                                             attributes: [
                                                                .foregroundColor: message.data == "OWNER" ? UIColor.macaroniCheese : UIColor.white,
                                                                .font: UIFont.systemFont(ofSize: 11, weight: .bold)
                                                             ])
            messageLabel.sizeToFit()
            addSubview(messageLabel)
            
            cellHeight = messageLabel.getGapPos(gap: 5).y
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
