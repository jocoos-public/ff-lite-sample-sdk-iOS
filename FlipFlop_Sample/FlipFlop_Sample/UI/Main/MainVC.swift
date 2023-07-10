//
//  MainVC.swift
//  FlipFlop_iOS_Sample
//
//  Created by DoHyoung Kim on 2023/06/30.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let topBgView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
        topBgView.backgroundColor = .orangeYellow
        view.addSubview(topBgView)
        
        let titleLabel = UILabel(frame: CGRect(x: 20,
                                               y: 123,
                                               width: view.frame.width - 40,
                                               height: 26))
        titleLabel.backgroundColor = .clear
        titleLabel.attributedText = NSAttributedString(string: "DEMO MENU",
                                                       attributes: [
                                                        .foregroundColor: UIColor.white,
                                                        .font: UIFont.systemFont(ofSize: 28, weight: .bold)
                                                       ])
        titleLabel.sizeToFit()
        view.addSubview(titleLabel)
        
        let guideLabel = UILabel(frame: CGRect(x: 20,
                                               y: titleLabel.getGapPos(gap: 20).y,
                                               width: view.frame.width - 40,
                                               height: 17))
        guideLabel.backgroundColor = .clear
        guideLabel.attributedText = NSAttributedString(string: "테스트를 진행 할 데모 메뉴를 선택하세요.",
                                                       attributes: [
                                                        .foregroundColor: UIColor.white,
                                                        .font: UIFont.systemFont(ofSize: 12)
                                                       ])
        guideLabel.sizeToFit()
        view.addSubview(guideLabel)
        
        let firstCard = MainCardView(frame: CGRect(x: 20,
                                                   y: 236,
                                                   width: view.frame.width - 40,
                                                   height: 220),
                                     type: 0)
        firstCard.tag = 0
        view.addSubview(firstCard)
        
        let secondCard = MainCardView(frame: CGRect(x: 20,
                                                    y: firstCard.getGapPos(gap: 10).y,
                                                    width: view.frame.width - 40,
                                                    height: 220),
                                      type: 1)
        view.addSubview(secondCard)
        
        let makeTapGesture = UITapGestureRecognizer(target: self, action: #selector(makeAction))
        makeTapGesture.numberOfTapsRequired = 1
        firstCard.addGestureRecognizer(makeTapGesture)
        
        let goLIstGesture = UITapGestureRecognizer(target: self, action: #selector(goListAction))
        goLIstGesture.numberOfTapsRequired = 1
        secondCard.addGestureRecognizer(goLIstGesture)
    }
    
    @objc private func makeAction() {
        let nextVC = BroadcastViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func goListAction() {
        let nextVC = BroadcastListViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
