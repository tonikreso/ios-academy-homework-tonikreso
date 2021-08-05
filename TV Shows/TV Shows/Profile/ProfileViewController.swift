//
//  ProfileViewController.swift
//  TV Shows
//
//  Created by Infinum on 03.08.2021..
//

import UIKit
import Kingfisher
import KeychainAccess
import Alamofire

class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var logoutButton: UIButton!
    @IBOutlet private weak var profileImageView: UIImageView!
    private var authInfo: AuthInfo!
    private var profileInfo: UserResponse!
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfileInfo()
        logoutButton.layer.cornerRadius = 25
        profileImageView.layer.cornerRadius = 50
        setupNavigationLook()
        imagePicker.delegate = self
    }
}

//MARK: - Private utility

private extension ProfileViewController {
    
    func setupProfile(user: UserResponse) {
        print("imageUrl -> \(String(describing: user.imageUrl))")
        profileInfo = user
        
        nameLabel.text = profileInfo.email
        profileImageView.kf.setImage(
            with: URL(string: profileInfo.imageUrl ?? ""),
            placeholder: UIImage(named: "ic-profile-placeholder")
        )
    }
    
    func getProfileInfo() {
        let router = Router.getMe(authInfo: authInfo)
        NetworkService
            .shared
            .service
            .request(router)
            .validate()
            .responseDecodable(of: LoginResponse.self) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(let profileResponse):
                    self.setupProfile(user: profileResponse.user)
                case .failure(_):
                    break
                }
            }
    }
    
    @objc func didSelectClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupNavigationLook() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(didSelectClose)
          )
        
        self.title = "My Account"
    }
    
    func changeImageUrl(imageUrl: String) {
        let router = Router.putNewImageUrl(
            authInfo: authInfo,
            imageUrl: imageUrl,
            email: profileInfo.email
        )
        
        NetworkService
            .shared
            .service
            .request(router)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
            //print(response)
            }
    }
}

//MARK: - Public utility

extension ProfileViewController {
    
    func addAuthInfo(authInfo: AuthInfo) {
        self.authInfo = authInfo
    }
}

//MARK: - IBActions

private extension ProfileViewController {
    
    @IBAction func changeProfilePhotoButtonPressed(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
                
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        dismiss(animated: true) {
            let keychain = Keychain(service: "userInfo")
            keychain["accessToken"] = nil
            keychain["client"] = nil
            keychain["tokenType"] = nil
            keychain["expiry"] = nil
            keychain["uid"] = nil
            
            let notification = Notification(name: Notification.Name(rawValue: "Logout"))
            NotificationCenter.default.post(notification)
        }
    }
}

//MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.profileImageView.image = pickedImage
                
                guard let imageData = pickedImage.jpegData(compressionQuality: 0.9) else { return }
                
                let requestData = MultipartFormData()
                requestData.append(
                    imageData,
                    withName: "image",
                    fileName: "image.jpg",
                    mimeType: "image/jpg"
                )
                
                print(imageData.count)
                
                let headers: HTTPHeaders = [
                    "client": self.authInfo.client,
                    "access-token": self.authInfo.accessToken,
                    "uid": self.authInfo.uid,
                    "Content-type": "multipart/form-data",
                    "Content-Disposition" : "form-data"
                ]
                let url = "https://tv-shows.infinum.academy/users"
                AF
                    .upload(
                        multipartFormData: requestData,
                        to: url,
                        method: .put,
                        headers: headers)
                    .validate()
                    .responseDecodable(of: LoginResponse.self) { [weak self] response in
                        switch response.result {
                        case .success(let user):
                            self?.changeImageUrl(imageUrl: user.user.imageUrl ?? "")
                        case .failure(_):
                            break
                        }
                    }
            }
        }
    }
}

//MARK: - UINavigationControllerDelegate

extension ProfileViewController: UINavigationControllerDelegate {
    
}
