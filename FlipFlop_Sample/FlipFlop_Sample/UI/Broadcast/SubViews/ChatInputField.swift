//
//  ChatInputField.swift
//  FlipFlop_Sample
//
//  Created by DoHyoung Kim on 2023/07/06.
//

import Foundation
import UIKit

class ChatInputField: UIView {
    
    private var inputField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black.withAlphaComponent(0.2)
        layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
        layer.cornerRadius = 35 / 2
        
        inputField = UITextField(frame: CGRect(x: 20,
                                               y: 8,
                                               width: frame.width - 40,
                                               height: frame.height - 16))
        inputField.backgroundColor = .clear
        inputField.delegate = self
        inputField.returnKeyType = .send
        inputField.attributedPlaceholder = NSAttributedString(string: "메세지를 입력하세요.",
                                                              attributes: [
                                                                .foregroundColor: UIColor.white,
                                                                .font: UIFont.systemFont(ofSize: 13, weight: .regular)
                                                              ])
        inputField.defaultTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 13, weight: .regular)
        ]
        
        addSubview(inputField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatInputField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let inputText = textField.text, inputText.count != 0 else {return false}
        
        if let vc = findViewController() {
            if let broadCastVC = vc as? BroadcastViewController {
                broadCastVC.chatSendAction(text: inputText)
            } else if let watchVC = vc as? BroadcastWatchViewController {
                watchVC.sendMessage(text: inputText)
            }
        }
        
        textField.text = ""
        return false
    }
}
