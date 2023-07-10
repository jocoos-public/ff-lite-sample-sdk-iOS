//
//  EffectSetView.swift
//  FlipFlop_Sample
//
//  Created by DoHyoung Kim on 2023/07/07.
//

import Foundation
import UIKit
import FlipFlopLiteSDK

class EffectSetView: UIView {
        
    private var bgView: UIView!
    private var zoomBtn: UIButton!
    private var reverseBtn: UIButton!
    private var rotationBtn: UIButton!
    private var filterBtn: UIButton!
    private var confirmBtn: UIButton!
    
    private var zoomView: ZoomScaleView!
    private var filterView: FilterSettingView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.backgroundColor = .clear
        closeBtn.frame = bounds
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        addSubview(closeBtn)
        
        bgView = UIView(frame: CGRect(x: 0,
                                      y: frame.height,
                                      width: frame.width,
                                      height: frame.height / 3))
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        addSubview(bgView)
        
        setEffectUI()
        detailViews()
        showAction()
    }
    
    private func setEffectUI() {
        let startPos = (frame.width - 190) / 2
        
        zoomBtn = UIButton(type: .custom)
        zoomBtn.frame = CGRect(x: startPos,
                               y: 10,
                               width: 40,
                               height: 40)
        zoomBtn.setBackgroundColor(.clear, for: .normal)
        zoomBtn.setBackgroundColor(.orangeYellow, for: .selected)
        zoomBtn.setImage(UIImage(named: "01AssetIcon2424IcoSize"), for: .normal)
        zoomBtn.addTarget(self, action: #selector(changeEffectAction(selectBtn: )), for: .touchUpInside)
        zoomBtn.layer.cornerRadius = 20
        zoomBtn.layer.masksToBounds = true
        bgView.addSubview(zoomBtn)
        
        reverseBtn = UIButton(type: .custom)
        reverseBtn.frame = CGRect(x: zoomBtn.getGapPos(gap: 10).x,
                                  y: 10,
                                  width: 40,
                                  height: 40)
        reverseBtn.setBackgroundColor(.clear, for: .normal)
        reverseBtn.setBackgroundColor(.orangeYellow, for: .selected)
        reverseBtn.setImage(UIImage(named: "01AssetIcon2424IcoReversed"), for: .normal)
        reverseBtn.addTarget(self, action: #selector(changeEffectAction(selectBtn: )), for: .touchUpInside)
        reverseBtn.layer.cornerRadius = 20
        reverseBtn.layer.masksToBounds = true
        bgView.addSubview(reverseBtn)
        
        rotationBtn = UIButton(type: .custom)
        rotationBtn.frame = CGRect(x: reverseBtn.getGapPos(gap: 10).x,
                                  y: 10,
                                  width: 40,
                                  height: 40)
        rotationBtn.setBackgroundColor(.clear, for: .normal)
        rotationBtn.setBackgroundColor(.orangeYellow, for: .selected)
        rotationBtn.setImage(UIImage(named: "01AssetIcon2424IcoRotate"), for: .normal)
        rotationBtn.addTarget(self, action: #selector(changeEffectAction(selectBtn: )), for: .touchUpInside)
        rotationBtn.layer.cornerRadius = 20
        rotationBtn.layer.masksToBounds = true
        bgView.addSubview(rotationBtn)
        
        filterBtn = UIButton(type: .custom)
        filterBtn.frame = CGRect(x: rotationBtn.getGapPos(gap: 10).x,
                                 y: 10,
                                 width: 40,
                                 height: 40)
        filterBtn.setBackgroundColor(.clear, for: .normal)
        filterBtn.setBackgroundColor(.orangeYellow, for: .selected)
        filterBtn.setImage(UIImage(named: "01AssetIcon2424IcoFilter"), for: .normal)
        filterBtn.addTarget(self, action: #selector(changeEffectAction(selectBtn: )), for: .touchUpInside)
        filterBtn.layer.cornerRadius = 20
        filterBtn.layer.masksToBounds = true
        bgView.addSubview(filterBtn)
        
        zoomBtn.isSelected = true
        
        confirmBtn = UIButton(type: .custom)
        confirmBtn.backgroundColor = UIColor.white
        confirmBtn.frame = CGRect(x: (bgView.frame.width - 120) / 2,
                                  y: bgView.frame.height - 94,
                                  width: 120,
                                  height: 50)
        confirmBtn.setAttributedTitle(NSAttributedString(string: "확인",
                                                         attributes: [
                                                            .foregroundColor: UIColor.black,
                                                            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
                                                         ]),
                                      for: .normal)
        confirmBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        confirmBtn.layer.cornerRadius = 25
        confirmBtn.layer.masksToBounds = true
        bgView.addSubview(confirmBtn)
    }
    
    private func detailViews() {
        zoomView = ZoomScaleView(frame: CGRect(x: 0,
                                               y: zoomBtn.getGapPos(gap: 25).y,
                                               width: bgView.frame.width,
                                               height: confirmBtn.frame.origin.y - zoomBtn.getGapPos(gap: 25).y))
        bgView.addSubview(zoomView)
        
        filterView = FilterSettingView(frame: CGRect(x: 0,
                                                     y: zoomBtn.getGapPos(gap: 25).y,
                                                     width: bgView.frame.width,
                                                     height: confirmBtn.frame.origin.y - zoomBtn.getGapPos(gap: 25).y))
        filterView.isHidden = true
        bgView.addSubview(filterView)
    }
    
    @objc private func changeEffectAction(selectBtn: UIButton) {
        if selectBtn == zoomBtn {
            zoomBtn.isSelected = true
            reverseBtn.isSelected = false
            rotationBtn.isSelected = false
            filterBtn.isSelected = false
            
            zoomView.isHidden = false
            filterView.isHidden = true
        } else if selectBtn == reverseBtn {
            zoomBtn.isSelected = false
            reverseBtn.isSelected = true
            rotationBtn.isSelected = false
            filterBtn.isSelected = false
            
            zoomView.isHidden = true
            filterView.isHidden = true
            
            if let vc = findViewController() as? BroadcastViewController {
                vc.changeReverse()
            }
        } else if selectBtn == rotationBtn {
            zoomBtn.isSelected = false
            reverseBtn.isSelected = false
            rotationBtn.isSelected = true
            filterBtn.isSelected = false
            
            zoomView.isHidden = true
            filterView.isHidden = true
            
            if let vc = findViewController() as? BroadcastViewController {
                vc.switchAction()
            }
        } else if selectBtn == filterBtn {
            zoomBtn.isSelected = false
            reverseBtn.isSelected = false
            rotationBtn.isSelected = false
            filterBtn.isSelected = true
            
            zoomView.isHidden = true
            filterView.isHidden = false
        }
    }
    
    func showAction() {
        self.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.bgView.frame.origin.y = self.frame.height * 2 / 3
        }
    }
    
    @objc private func closeAction() {
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.bgView.frame.origin.y = self.frame.height
        } completion: { _ in
            self.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ZoomScaleView: UIView {
    
    private var firstBtn: UIButton!
    private var secondBtn: UIButton!
    
    private let selectAttr: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.white,
        .font: UIFont.systemFont(ofSize: 13, weight: .medium)
    ]
    
    private let normalAttr: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.white.withAlphaComponent(0.5),
        .font: UIFont.systemFont(ofSize: 13, weight: .medium)
    ]
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        firstBtn = UIButton(type: .custom)
        firstBtn.backgroundColor = .clear
        firstBtn.frame = CGRect(x: (frame.width / 2) - 60,
                                y: 0,
                                width: 50,
                                height: 50)
        firstBtn.setAttributedTitle(NSAttributedString(string: "1X",
                                                       attributes: normalAttr),
                                    for: .normal)
        firstBtn.setAttributedTitle(NSAttributedString(string: "1X",
                                                       attributes: selectAttr),
                                    for: .selected)
        firstBtn.addTarget(self, action: #selector(selectAction(selectBtn:)), for: .touchUpInside)
        firstBtn.layer.borderColor = UIColor.white.cgColor
        firstBtn.layer.borderWidth = 2
        firstBtn.layer.cornerRadius = 25
        firstBtn.layer.masksToBounds = true
        addSubview(firstBtn)
        
        secondBtn = UIButton(type: .custom)
        secondBtn.backgroundColor = .clear
        secondBtn.frame = CGRect(x: (frame.width / 2) + 10,
                                y: 0,
                                width: 50,
                                height: 50)
        secondBtn.setAttributedTitle(NSAttributedString(string: "2X",
                                                       attributes: normalAttr),
                                    for: .normal)
        secondBtn.setAttributedTitle(NSAttributedString(string: "2X",
                                                       attributes: selectAttr),
                                    for: .selected)
        secondBtn.addTarget(self, action: #selector(selectAction(selectBtn:)), for: .touchUpInside)
        secondBtn.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        secondBtn.layer.borderWidth = 2
        secondBtn.layer.cornerRadius = 25
        secondBtn.layer.masksToBounds = true
        addSubview(secondBtn)
        
        firstBtn.isSelected = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func selectAction(selectBtn: UIButton) {
        var scale: CGFloat = 0.0
        if selectBtn == firstBtn {
            firstBtn.isSelected = true
            secondBtn.isSelected = false
            firstBtn.layer.borderColor = UIColor.white.cgColor
            secondBtn.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
            scale = 1.0
        } else {
            firstBtn.isSelected = false
            secondBtn.isSelected = true
            firstBtn.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
            secondBtn.layer.borderColor = UIColor.white.cgColor
            scale = 2.0
        }
        
        if let vc = findViewController() as? BroadcastViewController {
            vc.changeZoomScale(scale: scale)
        }
    }
}

enum FilterCase {
    case clean, pink(alpha: CGFloat), babyPink(alpha: CGFloat), violet(alpha: CGFloat), bright(alpha: CGFloat)
}
class FilterSettingView: UIView {
    
    let filterList: [(String, FilterCase, UIImage?)] = [
        ("clean", .clean, UIImage(named: "imgFilterOriginal")),
        ("pink",  .pink(alpha: 0.2), UIImage(named: "imgFilterPink")),
        ("baby", .babyPink(alpha: 0.3), UIImage(named: "imgFilterBabypink")),
        ("violet", .violet(alpha: 0.3), UIImage(named: "imgFilterViolet")),
        ("bright", .bright(alpha: 0.4), UIImage(named: "imgFilterBright")),
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        let contentSArea = UIScrollView(frame: bounds)
        contentSArea.backgroundColor = .clear
        
        var startPos: CGFloat = 0
        for index in 0..<filterList.count {
            let btn = UIButton(type: .custom)
            btn.tag = index
            btn.frame = CGRect(x: startPos, y: (frame.height - 56) / 2, width: 56, height: 56)
            btn.backgroundColor = .blue.withAlphaComponent(0.2)
            btn.setImage(filterList[index].2, for: .normal)
            btn.addTarget(self, action: #selector(selectFilter(selectBtn:)), for: .touchUpInside)
            btn.layer.cornerRadius = 5
            btn.layer.masksToBounds = true
            contentSArea.addSubview(btn)
            startPos = btn.getGapPos(gap: 10).x
        }
        
        contentSArea.contentSize = CGSize(width: startPos - 10, height: frame.height)
        contentSArea.showsVerticalScrollIndicator = false
        contentSArea.showsHorizontalScrollIndicator = false
        addSubview(contentSArea)
        
        if contentSArea.frame.width >= contentSArea.contentSize.width {
            contentSArea.isScrollEnabled = false
            contentSArea.frame.size.width = contentSArea.contentSize.width
            contentSArea.frame.origin.x = (frame.width - contentSArea.frame.width) / 2
        }
    }
    
    @objc private func selectFilter(selectBtn: UIButton) {
        if let vc = findViewController() as? BroadcastViewController {
            vc.setFilter(selectFilter: filterList[selectBtn.tag].1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
