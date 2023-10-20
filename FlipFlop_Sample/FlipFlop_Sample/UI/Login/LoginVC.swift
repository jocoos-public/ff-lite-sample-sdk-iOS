//
//  LoginVC.swift
//  FlipFlop_iOS_Sample
//
//  Created by DoHyoung Kim on 2023/06/30.
//

import Foundation
import UIKit
import Photos

class LoginViewController: UIViewController {
    private var userImgView: UIImageView!
    private var refreshBtn: UIButton!
    private var nameField: UITextField!
    private var loginBtn: UIButton!
    private var contentSArea: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHelper(notif:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHelper(notif:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        contentSArea = UIScrollView(frame: view.bounds)
        contentSArea.backgroundColor = .clear
        view.addSubview(contentSArea)
        
        userImgView = UIImageView(frame: CGRect(x: (view.frame.width - 120) / 2,
                                                y: 200,
                                                width: 120,
                                                height: 120))
        userImgView.image = UIImage(named: "img_defaultUser")
        userImgView.backgroundColor = .clear
        userImgView.isUserInteractionEnabled = true
        userImgView.layer.cornerRadius = 60
        userImgView.layer.masksToBounds = true
        contentSArea.addSubview(userImgView)
        
        refreshBtn = UIButton(type: .custom)
        refreshBtn.backgroundColor = .greyBlack3
        refreshBtn.frame = CGRect(x: userImgView.getGapPos(gap: -37).x,
                                  y: userImgView.getGapPos(gap: -33).y,
                                  width: 32,
                                  height: 32)
        refreshBtn.addTarget(self, action: #selector(picker), for: .touchUpInside)
        refreshBtn.setImage(UIImage(named: "transform"), for: .normal)
        refreshBtn.layer.cornerRadius = 16
        refreshBtn.layer.masksToBounds = true
        contentSArea.addSubview(refreshBtn)
        
        nameField = UITextField(frame: CGRect(x: 40,
                                              y: userImgView.getGapPos(gap: 20).y,
                                              width: view.frame.width - 80,
                                              height: 57))
        nameField.backgroundColor = .clear
        nameField.delegate = self
        nameField.returnKeyType = .continue
        nameField.attributedPlaceholder = NSAttributedString(string: "User name",
                                                             attributes: [
                                                                .foregroundColor: UIColor.black,
                                                                .font: UIFont.systemFont(ofSize: 20, weight: .bold)
                                                             ])
        nameField.defaultTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        contentSArea.addSubview(nameField)
        
        let border = UIView(frame: CGRect(x: 40,
                                          y: nameField.getGapPos(gap: 0).y,
                                          width: view.frame.width - 80,
                                          height: 1))
        border.backgroundColor = .veryLightPink
        contentSArea.addSubview(border)
        
        let firstGuide = UILabel(frame: CGRect(x: 40,
                                               y: border.getGapPos(gap: 20).y,
                                               width: view.frame.width - 80,
                                               height: 18))
        firstGuide.backgroundColor = .clear
        firstGuide.attributedText = NSAttributedString(string: "* Video will be deleted in an hour.",
                                                       attributes: [
                                                        .foregroundColor: UIColor.brownGrey,
                                                        .font: UIFont.systemFont(ofSize: 12)
                                                       ])
        contentSArea.addSubview(firstGuide)
        
        let secondGuide = UILabel(frame: CGRect(x: 40,
                                               y: firstGuide.getGapPos(gap: 9).y,
                                               width: view.frame.width - 80,
                                               height: 18))
        secondGuide.backgroundColor = .clear
        secondGuide.attributedText = NSAttributedString(string: "* You can change profile image.",
                                                       attributes: [
                                                        .foregroundColor: UIColor.brownGrey,
                                                        .font: UIFont.systemFont(ofSize: 12)
                                                       ])
        contentSArea.addSubview(secondGuide)
        
        loginBtn = UIButton(type: .custom)
        loginBtn.backgroundColor = .clear
        loginBtn.frame = CGRect(x: (view.frame.width - 295) / 2,
                                y: view.frame.height - 50 - 54,
                                width: 295,
                                height: 50)
        loginBtn.setImage(UIImage(named: "02ButtonSize50PrimaryButton50"), for: .normal)
        loginBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        contentSArea.addSubview(loginBtn)
        
        contentSArea.contentSize = CGSize(width: view.frame.width,
                                          height: loginBtn.getGapPos(gap: 20).y)
    }
    
    @objc func keyboardHelper(notif: Notification) {
        var keyboardHeight: CGFloat = 0
        if let keyboardFrame: NSValue = notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        
        if notif.name == UIResponder.keyboardWillShowNotification {
            contentSArea.contentSize = CGSize(width: view.frame.width, height: contentSArea.contentSize.height + keyboardHeight)
        } else {
            contentSArea.contentSize = CGSize(width: view.frame.width, height: loginBtn.getGapPos(gap: 20).y)
        }
    }
    
    @objc private func picker() {
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
            self.present(picker, animated: true)
        }
    }
    
    @objc private func loginAction() {
        guard let userName = nameField.text, userName.count != 0 else {
            let alert = UIAlertController(title: nil, message: "Please input username", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true) {
                self.nameField.becomeFirstResponder()
            }
            
            return
        }
        
        
        DataStorage.loginUser = LoginUserResModel(username: userName, email: "", createdAt: "", updatedAt: "", id: "\(Date().millisecondsSince1970)")
        DataStorage.isLogined = true
        let nextVC = MainViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImgView.image = image
        }
        
        dismiss(animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameField.text?.isEmpty == false {
            textField.endEditing(true)
            loginAction()
            return true
        }
        
        return true
    }
}
