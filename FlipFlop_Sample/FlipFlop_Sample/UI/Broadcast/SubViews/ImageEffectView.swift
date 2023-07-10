//
//  ImageEffectView.swift
//  FlipFlop_Sample
//
//  Created by DoHyoung Kim on 2023/07/07.
//

import Foundation
import UIKit
import Photos
import FlipFlopLiteSDK

class ImageEffectView: UIView {
    private var bgView: UIView!
    private var confirmBtn: UIButton!
    private var soundSwitch: UISwitch!
    
    private let types = ["Pip", "Fade", "Normal", "Top", "Bottom", "Left"]
    private let bitRates: [String] = ["auto", "4000", "3000", "2000", "1000"]
    private var selectType: TransitionType?
    private var bitButtons: [UIButton] = []
    
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
        
        var pos: CGFloat = 0.0
        
        let bitArea = UIView(frame: CGRect(x: 0,
                                           y: 0,
                                           width: bgView.frame.width,
                                           height: bgView.frame.height / 4))
        bitArea.backgroundColor = .clear
        bgView.addSubview(bitArea)
        
        for (index, rate) in bitRates.enumerated() {
            let btn = UIButton(type: .custom)
            btn.tag = index
            btn.setBackgroundColor(UIColor.clear, for: .normal)
            btn.setBackgroundColor(UIColor.greyBlack3, for: .selected)
            btn.frame = CGRect(x: pos, y: 0, width: bgView.frame.width / CGFloat(bitRates.count), height: bitArea.frame.height)
            btn.setAttributedTitle(NSAttributedString(string: rate,
                                                      attributes: [
                                                        .foregroundColor: UIColor.white,
                                                        .font: UIFont.systemFont(ofSize: 12, weight: .regular)
                                                      ]),
                                   for: .normal)
            btn.addTarget(self, action: #selector(changeBit(selectBtn: )), for: .touchUpInside)
            bitArea.addSubview(btn)
            bitButtons.append(btn)
            pos = btn.getGapPos(gap: 0).x
        }
        
        let binder = UIView(frame: CGRect(x: 0, y: bitArea.getGapPos(gap: -1).y, width: bgView.frame.width, height: 1))
        binder.backgroundColor = .white
        bgView.addSubview(binder)
        
        let imageArea = UIView(frame: CGRect(x: 0,
                                             y: bitArea.getGapPos(gap: 0).y,
                                             width: bgView.frame.width,
                                             height: bgView.frame.height / 4))
        imageArea.backgroundColor = .clear
        bgView.addSubview(imageArea)
        
        pos = 0
        
        for (index, text) in types.enumerated() {
            let btn = UIButton(type: .custom)
            btn.backgroundColor = .clear
            btn.tag = index
            btn.frame = CGRect(x: pos,
                               y: 0,
                               width: bgView.frame.width / CGFloat(types.count),
                               height: imageArea.frame.height)
            btn.setAttributedTitle(NSAttributedString(string: text,
                                                      attributes: [
                                                        .foregroundColor: UIColor.white,
                                                        .font: UIFont.systemFont(ofSize: 12, weight: .regular)
                                                      ]),
                                   for: .normal)
            btn.addTarget(self, action: #selector(selectTypeAction(selectBtn:)), for: .touchUpInside)
            imageArea.addSubview(btn)
            pos += bgView.frame.width / CGFloat(types.count)
        }
        
        let secBinder = UIView(frame: CGRect(x: 0, y: imageArea.getGapPos(gap: -1).y, width: bgView.frame.width, height: 1))
        secBinder.backgroundColor = .white
        bgView.addSubview(secBinder)
        
        let micArea = UIView(frame: CGRect(x: 0,
                                           y: secBinder.getGapPos(gap: 0).y,
                                           width: bgView.frame.width,
                                           height: bgView.frame.height / 4))
        micArea.backgroundColor = .clear
        bgView.addSubview(micArea)
        
        let micLabel = UILabel(frame: CGRect(x: 15,
                                             y: 0,
                                             width: 200,
                                             height: 20))
        micLabel.backgroundColor = .clear
        micLabel.attributedText = NSAttributedString(string: "mic on",
                                                     attributes: [
                                                        .foregroundColor: UIColor.white,
                                                        .font: UIFont.systemFont(ofSize: 12, weight: .regular)
                                                     ])
        micLabel.sizeToFit()
        micArea.addSubview(micLabel)
        
        soundSwitch = UISwitch(frame: CGRect(x: bgView.frame.width - 85,
                                             y: (micArea.frame.height - 30) / 2,
                                             width: 80,
                                             height: 30))
        soundSwitch.isOn = true
        soundSwitch.addTarget(self, action: #selector(soundAction), for: .touchUpInside)
        micArea.addSubview(soundSwitch)
        
        micLabel.center.y = soundSwitch.center.y
        
        confirmBtn = UIButton(type: .custom)
        confirmBtn.backgroundColor = UIColor.white
        confirmBtn.frame = CGRect(x: (bgView.frame.width - 120) / 2,
                                  y: micArea.getGapPos(gap: 10).y,
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
    
    @objc private func changeBit(selectBtn: UIButton) {
        for btn in bitButtons {
            btn.isSelected = false
        }
        
        selectBtn.isSelected = true
        
        let selectBit = bitRates[selectBtn.tag]
        
        if let vc = findViewController() as? BroadcastViewController {
            if selectBtn.tag == 0 {
                vc.changeBitrate(bitRate: 0)
            } else {
                vc.changeBitrate(bitRate: Int(selectBit)!)
            }
            
        }
    }
    
    @objc private func soundAction() {
        if let vc = findViewController() as? BroadcastViewController {
            vc.soundSwitchAction()
        }
    }
    
    @objc private func selectTypeAction(selectBtn: UIButton) {
        if selectBtn.tag == 0 {
            selectType = .fade_in_pip
        } else if selectBtn.tag == 1 {
            selectType = .fade_in_out
        } else if selectBtn.tag == 2 {
            if let vc = findViewController() as? BroadcastViewController {
                vc.showImage(image: nil, type: .none)
            }
            return
        } else if selectBtn.tag == 3 {
            selectType = .slide_to_top
        } else if selectBtn.tag == 4 {
            selectType = .slide_to_camera_bottom
        } else if selectBtn.tag == 5 {
            selectType = .slide_to_left
        }
        
        let photos = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if photos == .authorized {
            self.openPicker()
        } else if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                if status == .authorized {
                    self.openPicker()
                }
            }
        }
    }
    
    private func openPicker() {
        DispatchQueue.main.async {
            let picker = UIImagePickerController()
            picker.delegate = self
            if let vc = self.findViewController() {
                vc.present(picker, animated: true)
            }
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

extension ImageEffectView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let vc = findViewController() as? BroadcastViewController {
                vc.showImage(image: image, type: selectType!)
            }
        }
        
        picker.dismiss(animated: true)
    }
}
