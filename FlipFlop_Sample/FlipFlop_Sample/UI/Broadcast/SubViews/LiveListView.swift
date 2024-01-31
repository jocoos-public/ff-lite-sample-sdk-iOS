//
//  LiveListView.swift
//  FlipFlop_Sample
//

import Foundation

import UIKit
import FlipFlopLiteSDK

class LiveListView: UIView {
    private var bgView: UIView!
    private var liveItemView: LiveItemView!
    private var confirmBtn: UIButton!
    
    private var list: [VideoRoom] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    }
    
    private func getList() {
        RequestManager.req(url: .getVideoRooms,
                           type: VideoRooms.self) { [weak self] isComplete, response, error in
            guard let weakSelf = self else {return}
            
            if isComplete {
                if let res = response {
                    var items: [VideoRoom] = []
                    items.append(contentsOf: res.content)
                    
                    weakSelf.list = items.filter { item in
                        item.liveUrl != nil
                    }
                    
                    weakSelf.detailViews()
                    weakSelf.liveItemView.isHidden = false
                }
            }
        }
    }
    
    func showAction() {
        self.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.bgView.frame.origin.y = self.frame.height * 2 / 3
        }
        
        getList()
    }
    
    private func detailViews() {
        liveItemView = LiveItemView(frame: CGRect(x: 0,
                                                y: 10,
                                                width: frame.width,
                                                  height: frame.height / 3), list: self.list)
        //liveItemView.isHidden = true
        bgView.addSubview(liveItemView)
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

class LiveItemView: UIView {
    
    private var list: [VideoRoom] = []
    
    init(frame: CGRect, list: [VideoRoom]) {
        super.init(frame: frame)
        
        self.list = list
        
        backgroundColor = .clear
        
        let contentSArea = UIScrollView(frame: bounds)
        contentSArea.backgroundColor = .clear
        
        var startPos: CGFloat = 0
        for index in 0..<list.count {
            let btn = UIButton(type: .custom)
            btn.tag = index
            btn.frame = CGRect(x: startPos, y: (frame.height - 56) / 2, width: 168, height: 112)
            btn.backgroundColor = .white.withAlphaComponent(0.2)
            btn.addTarget(self, action: #selector(selectItem(selectBtn:)), for: .touchUpInside)
            btn.layer.cornerRadius = 5
            btn.layer.masksToBounds = true
            
            if list.count > index {
                let title = list[index].title
                btn.setAttributedTitle(NSAttributedString(string: title,
                                                          attributes: [
                                                              .foregroundColor: UIColor.white,
                                                              .font: UIFont.systemFont(ofSize: 14, weight: .medium)
                                                          ]),
                                                          for: .normal)
            }
            
            contentSArea.addSubview(btn)
            startPos = btn.getGapPos(gap: 10).x
        }
        
        contentSArea.contentSize = CGSize(width: startPos - 10, height: frame.height)
        contentSArea.showsVerticalScrollIndicator = false
        contentSArea.showsHorizontalScrollIndicator = false
        addSubview(contentSArea)
        
        if contentSArea.frame.width >= contentSArea.contentSize.width {
            contentSArea.isScrollEnabled = true
            contentSArea.frame.size.width = contentSArea.contentSize.width
            contentSArea.frame.origin.x = (frame.width - contentSArea.frame.width) / 2
        }
    }
    
    @objc private func selectItem(selectBtn: UIButton) {
        if let vc = findViewController() as? BroadcastViewController {
            let live = list[selectBtn.tag]
            let liveUrl = live.httpFlvPlayUrl ?? live.rtmpPlayUrl ?? live.liveUrl ?? ""
            vc.watchVideo(liveUrl: liveUrl)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
