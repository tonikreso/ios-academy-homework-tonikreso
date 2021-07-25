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
                    SVProgressHUD.dismiss(withDelay: 1)
                    switch response.result {
                    case .success(let userResponse):
                        let headers = response.response?.headers.dictionary ?? [:]
                        let authInfo = self?.handleSuccesfulLoginOrRegister(for: userResponse.user, headers: headers)
                        guard let authInfo = authInfo else {
                            self?.showNoAuthInfoAlert(description: "Login error")
                            return
                        }
                        self?.navigateToHomeViewController(authInfo: authInfo)
                    case .failure(let error):
                        switch error.responseCode {
                        case 401:
                            self?.showLoginOrRequestServerError(description: "Login error", message: "Wrong username or password")
                        default:
                            SVProgressHUD.showError(withStatus: "Failure")
                        }
                    }
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
                    SVProgressHUD.dismiss(withDelay: 1)
                    switch response.result {
                    case .success(let userResponse):
                        let headers = response.response?.headers.dictionary ?? [:]
                        let authInfo = self?.handleSuccesfulLoginOrRegister(for: userResponse.user, headers: headers)
                        guard let authInfo = authInfo else {
                            self?.showNoAuthInfoAlert(description: "Registration error")
                            return
                        }
                        self?.navigateToHomeViewController(authInfo: authInfo)
                    case .failure(let error):
                        switch error.responseCode {
                        case 422:
                            self?.showLoginOrRequestServerError(description: "Registration error", message: "Invalid email or password")
                        default:
                            SVProgressHUD.showError(withStatus: "Failure")
                        }
                    }
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
    
    func navigateToHomeViewController(authInfo: AuthInfo) {
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
        homeVC.addAuthInfo(authInfo: authInfo)
        self.navigationController?.setViewControllers([homeVC], animated: true)
    }
    
    func loginOrRegisterButtonPressed(errorDescription: String, doWork: (_ username: String, _ password: String) -> Void) {
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty
        else {
            let alert = UIAlertController(title: errorDescription, message: "Please enter username and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return

        }
        SVProgressHUD.show()
        doWork(username, password)
    }
    
    func handleSuccesfulLoginOrRegister(for user: UserResponse, headers: [String: String]) -> AuthInfo?{
        guard let authInfo = try? AuthInfo(headers: headers) else {
            SVProgressHUD.showError(withStatus: "Missing headers")
            return nil
        }
        SVProgressHUD.showSuccess(withStatus: "Success")
        return authInfo
    }
    
    func showNoAuthInfoAlert(description: String) {
        let alert = UIAlertController(title: description, message: "No authorization info in server response. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showLoginOrRequestServerError(description: String, message: String) {
        let alert = UIAlertController(title: description, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
