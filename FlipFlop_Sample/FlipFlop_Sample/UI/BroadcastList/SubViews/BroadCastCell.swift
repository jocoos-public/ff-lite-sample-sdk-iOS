//
//  BroadCastCell.swift
//  FlipFlop_iOS_Sample
//
//  Created by DoHyoung Kim on 2023/07/03.
//

import Foundation
import UIKit
import SDWebImage

class BroadcastCell: UITableViewCell {
    let cellWidth = UIScreen.main.bounds.width
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, data: BroadcastListContent) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        let imgView = UIImageView(frame: CGRect(x: 20,
                                                y: 0,
                                                width: 110,
                                                height: 160))
        imgView.backgroundColor = .veryLightPink
        imgView.image = UIImage(named: "img_placeholder")
        imgView.layer.cornerRadius = 8
        imgView.layer.masksToBounds = true
        addSubview(imgView)
        
        let titleLabel = UILabel(frame: CGRect(x: imgView.getGapPos(gap: 12).x,
                                               y: 10,
                                               width: cellWidth - imgView.getGapPos(gap: 12).x - 20,
                                               height: 26))
        titleLabel.backgroundColor = .clear
        titleLabel.attributedText = NSAttributedString(string: data.title ?? "",
                                                       attributes: [
                                                        .foregroundColor: UIColor.black,
                                                        .font: UIFont.systemFont(ofSize: 16, weight: .bold),
                                                        .baselineOffset: (26 - UIFont.systemFont(ofSize: 16, weight: .bold).lineHeight) / 4
                                                       ])
        titleLabel.sizeToFit()
        addSubview(titleLabel)
        
        let detailLabel = UILabel(frame: CGRect(x: imgView.getGapPos(gap: 12).x,
                                                y: titleLabel.getGapPos(gap: 4).y,
                                                width: cellWidth - imgView.getGapPos(gap: 12).x - 43,
                                                height: 20))
        detailLabel.backgroundColor = .clear
        detailLabel.attributedText = NSAttributedString(string: data.description ?? "",
                                                        attributes: [
                                                            .foregroundColor: UIColor.greyBlack3,
                                                            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
                                                        ])
        detailLabel.numberOfLines = 2
        detailLabel.sizeToFit()
        addSubview(detailLabel)
        
        let dateLabel = UILabel(frame: CGRect(x: imgView.getGapPos(gap: 12).x,
                                              y: detailLabel.getGapPos(gap: 6).y,
                                              width: cellWidth - imgView.getGapPos(gap: 12).x - 43,
                                              height: 20))
        dateLabel.backgroundColor = .clear
        dateLabel.attributedText = NSAttributedString(string: data.createdAt?.convertTime() ?? "",
                                                      attributes: [
                                                            .foregroundColor: UIColor.brownGrey,
                                                            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
                                                      ])
        dateLabel.sizeToFit()
        addSubview(dateLabel)
        
        let userImgView = UIImageView(frame: CGRect(x: imgView.getGapPos(gap: 12).x,
                                                    y: imgView.getGapPos(gap: -38).y,
                                                    width: 32,
                                                    height: 32))
        userImgView.sd_setImage(with: URL(string: data.member?.appUserProfileImgURL ?? "")) { image, error, _, requestUrl in
            if error != nil {
                userImgView.image = UIImage(named: "ico_user")
            }
        }
        userImgView.backgroundColor = .clear
        userImgView.layer.cornerRadius = 16
        userImgView.layer.masksToBounds = true
        addSubview(userImgView)
        
        let userNameLabel = UILabel(frame: CGRect(x: userImgView.getGapPos(gap: 8).x,
                                                  y: 0,
                                                  width: 100,
                                                  height: 20))
        userNameLabel.backgroundColor = .clear
        userNameLabel.attributedText = NSAttributedString(string: data.member?.appUserName ?? "",
                                                          attributes: [
                                                            .foregroundColor: UIColor.black,
                                                            .font: UIFont.systemFont(ofSize: 12, weight: .bold)
                                                          ])
        userNameLabel.sizeToFit()
        userNameLabel.center.y = userImgView.center.y
        addSubview(userNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
