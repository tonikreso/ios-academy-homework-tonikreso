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
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailLineView: UIView!
    @IBOutlet private weak var passwordLineView: UIView!
    @IBOutlet private weak var rememberMeButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    
    private var passwordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationBarClear()
        setupTextFields()
        setupButtons()
    }
}

// MARK: - IBActions

private extension LoginViewController {
    
    @IBAction func rememberMeButtonPressed(_ sender: Any) {
        rememberMeButton.isSelected.toggle()
    }
    
    @IBAction func passwordButtonPressed(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
        passwordButton.isSelected.toggle()
    }
    
    @IBAction func loginButtonPressed() {
        //in the future when returning to login screen will be disabled
        //loginButton.isEnabled = false
        
        loginOrRegisterButtonPressed(errorDescription: "Login error") { username, password in
            
            let router = Router.login(
                user: UserLogin(
                    email: username,
                    password: password
                )
            )
            NetworkService
                .shared
                .service
                .request(router)
                .validate()
                .responseDecodable(of: LoginResponse.self) { [weak self] response in
                    switch response.result {
                    case .success(_):
                            SVProgressHUD.showSuccess(withStatus: "Success")
                    case .failure(_):
                            SVProgressHUD.showError(withStatus: "Failure")
                    }
                    SVProgressHUD.dismiss(withDelay: 1)
                    self?.navigateToHomeViewController()
                }
        }
    }
    
    @IBAction func registerButtonPressed() {
        //in the future when returning to login screen will be disabled
        //registerButton.isEnabled = false
        
        loginOrRegisterButtonPressed(errorDescription: "Registration error") { username, password in
            
            let router = Router.register(
                user: UserRegister(
                    email: username,
                    password: password,
                    passwordConfirmation: password
                )
            )
            NetworkService
                .shared
                .service
                .request(router)
                .validate()
                .responseDecodable(of: LoginResponse.self) { [weak self] response in
                    switch response.result {
                    case .success(_):
                        SVProgressHUD.showSuccess(withStatus: "Success")
                    case .failure(_):
                        SVProgressHUD.showError(withStatus: "Failure")
                    }
                    SVProgressHUD.dismiss(withDelay: 1)
                    self?.navigateToHomeViewController()
                }
        }
    }
}

//MARK: -UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if usernameTextField.text != "" && passwordTextField.text != "" && !loginButton.isEnabled {
            
            loginButton.isEnabled = true
            registerButton.isEnabled = true
            loginButton.backgroundColor = .white
        }
    }
}

//MARK: -Utility

private extension LoginViewController {
    
    func makeNavigationBarClear() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setupButtons() {
        loginButton.isEnabled = false
        registerButton.isEnabled = false
        
        loginButton.layer.cornerRadius = 25
        loginButton.setTitleColor(.lightText, for: .disabled)
        loginButton.setTitleColor(UIColor(red: 82/255, green: 54/255, blue: 140/255, alpha: 1), for: .normal)
        
        registerButton.setTitleColor(.lightText, for: .disabled)
        registerButton.setTitleColor(.white, for: .normal)
        
        rememberMeButton.setImage( UIImage(named: "ic-checkbox-unselected"), for: .normal)
        rememberMeButton.setImage( UIImage(named: "ic-checkbox-selected"), for: .selected)
        
        passwordButton.setImage(UIImage(named: "visibility-icon-closed"), for: .selected)
        passwordButton.setImage(UIImage(named: "visibility-icon-open"), for: .normal)
    }
    
    func setupTextFields() {
        passwordButton = UIButton()
        passwordButton.setImage(UIImage(named: "visibility-icon-open"), for: .normal)
        passwordTextField.rightViewMode = .whileEditing
        passwordTextField.rightView = passwordButton
        passwordButton.addTarget(self, action: #selector(passwordButtonPressed), for: .touchUpInside)
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func navigateToHomeViewController() {
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func loginOrRegisterButtonPressed(errorDescription: String, doWork: (_ username: String, _ password: String) -> Void) {
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty
        else {
            let alert = UIAlertController(title: errorDescription, message: "Please enter username and password", preferredStyle: .alert)
        
            self.present(alert, animated: true) {
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
            }
            return
        }
        
        SVProgressHUD.show()
        doWork(username, password)
    }
    
    @objc func dismissOnTapOutside(){
       self.dismiss(animated: true, completion: nil)
    }
}
