//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 13.07.2021..
//

import Foundation
import UIKit

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var verticalStackView: UIStackView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailLineView: UIView!
    @IBOutlet private weak var passwordLineView: UIView!
    @IBOutlet private weak var rememberMeButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    
    private var passwordButton: UIButton!
    
    override func viewDidLoad() {
        setupTextFields()
        setupButtons()
        
    }
    
    private func setupButtons() {
        loginButton.isEnabled = false
        registerButton.isEnabled = false
        loginButton.layer.cornerRadius = 25
        loginButton.setTitleColor(.lightText, for: .normal)
        registerButton.setTitleColor(.lightText, for: .normal)
    }
    
    private func setupTextFields() {
        passwordButton = UIButton()
        passwordButton.setImage(UIImage(named: "visibility-icon-open"), for: .normal)
        passwordTextField.rightViewMode = .whileEditing
        passwordTextField.rightView = passwordButton
        passwordButton.addTarget(self, action: #selector(refreshPasswordVisibility), for: .touchUpInside)
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func rememberMeAction(_ sender: Any) {
        if rememberMeButton.tag == 0 {
            rememberMeButton.tag = 1
            rememberMeButton.setImage( UIImage(named: "ic-checkbox-selected"), for: .normal)
        } else {
            rememberMeButton.tag = 0
            rememberMeButton.setImage( UIImage(named: "ic-checkbox-unselected"), for: .normal)
        }
    }
    @IBAction func refreshPasswordVisibility(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
        if passwordTextField.isSecureTextEntry {
            passwordButton.setImage(UIImage(named: "visibility-icon-open"), for: .normal)
        } else {
            passwordButton.setImage(UIImage(named: "visibility-icon-closed"), for: .normal)
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            //once the button becomes active it will not become inactive again
            //even if user empties a text field
            //delegates are removed so code doesn't run for nothing
            emailTextField.delegate = nil
            passwordTextField.delegate = nil
            
            loginButton.isEnabled = true
            registerButton.isEnabled = true
            
            loginButton.backgroundColor = .white
            let color = UIColor(red: 82/255, green: 54/255, blue: 140/255, alpha: 1)
            loginButton.setTitleColor(color, for: .normal)
            registerButton.setTitleColor(.white, for: .normal)
        }
    }
}
