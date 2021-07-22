//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 13.07.2021..
//

import Foundation
import UIKit
import SVProgressHUD

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var horizontalStackView: UIStackView!
    @IBOutlet private weak var verticalStackView: UIStackView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailLineView: UIView!
    @IBOutlet private weak var passwordLineView: UIView!
    @IBOutlet private weak var rememberMeButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    
    private var passwordButton: UIButton!
    
    @IBAction private func loginAction() {
        SVProgressHUD.show()
        
        //in the future when returning to login screen will be disabled
        //loginButton.isEnabled = false
        
        NetworkService.shared().service.request(Router.login(user: UserLogin(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")))
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(_):
                        SVProgressHUD.showSuccess(withStatus: "Success")
                case .failure(_):
                        SVProgressHUD.showError(withStatus: "Failure")
                }
                SVProgressHUD.dismiss(withDelay: 1) { [weak self] in
                    self?.navigateToHomeViewController()
                }
            }
    }
    
    @IBAction private func registerAction() {
        SVProgressHUD.show()
        
        //in the future when returning to login screen will be disabled
        //registerButton.isEnabled = false
        
        NetworkService.shared().service.request(Router.register(user: UserRegister(email: emailTextField.text ?? "", password: passwordTextField.text ?? "", passwordConfirmation: passwordTextField.text ?? "")))
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let user):
                    SVProgressHUD.showSuccess(withStatus: "Success")
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: "Failure")
                }
                SVProgressHUD.dismiss(withDelay: 1) { [weak self] in
                    self?.navigateToHomeViewController()
                }
            }
    }
    
    @IBAction private func refreshPasswordVisibility(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
        if passwordTextField.isSecureTextEntry {
            passwordButton.setImage(UIImage(named: "visibility-icon-open"), for: .normal)
        } else {
            passwordButton.setImage(UIImage(named: "visibility-icon-closed"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationBarClear()
        setupTextFields()
        setupButtons()
    }
    
    private func makeNavigationBarClear() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
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
    
    @IBAction private func rememberMeAction(_ sender: Any) {
        if rememberMeButton.tag == 0 {
            rememberMeButton.tag = 1
            rememberMeButton.setImage( UIImage(named: "ic-checkbox-selected"), for: .normal)
        } else {
            rememberMeButton.tag = 0
            rememberMeButton.setImage( UIImage(named: "ic-checkbox-unselected"), for: .normal)
        }
    }
    
    private func navigateToHomeViewController() {
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
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
