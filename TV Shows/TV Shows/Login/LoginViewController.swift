//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 13.07.2021..
//

import Foundation
import UIKit

final class LoginViewController: UIViewController {
    @IBOutlet private weak var counterButton: UIButton!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var numberOfTaps = 0
    private var stopActivityIndicatorDispatch: DispatchWorkItem!
    
    @IBAction func buttonTouchUpInside(_ sender: Any) {
        numberOfTaps += 1
        counterLabel.text = "The button has been tapped \(numberOfTaps) times!"
        
        //every time the button is pressed if indicator is spinning stop it,
        //if not, start spinning for 3 seconds
        if !stopActivityIndicatorDispatch.isCancelled {
            stopAndCancelActivityIndicator()
        } else {
            createTimerAndShowActivityIndicator()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapCounterLabel()
        createTimerAndShowActivityIndicator()
    }
    
    func createDispatchWorkItem() {
        //create new DispatchWorkItem every time the countdown starts
        stopActivityIndicatorDispatch = DispatchWorkItem { [weak self] in
            self?.stopAndCancelActivityIndicator()
        }
    }
    
    func createTimerAndShowActivityIndicator() {
        createDispatchWorkItem()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: stopActivityIndicatorDispatch)
        activityIndicatorView.startAnimating()
    }
    
    func setupTapCounterLabel() {
        counterLabel.text = "Please tap the button."
        counterLabel.layer.cornerRadius = 10
    }
    
    func stopAndCancelActivityIndicator() {
        stopActivityIndicatorDispatch.cancel()
        activityIndicatorView.stopAnimating()
    }
    
}
