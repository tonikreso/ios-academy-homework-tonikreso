//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 13.07.2021..
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet private weak var counterButton: UIButton!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var numberOfTaps = 0
    private var timer: Timer!
    
    @IBAction func buttonTouchUpInside(_ sender: Any) {
        numberOfTaps += 1
        counterLabel.text = "The button has been tapped \(numberOfTaps) times!"
        
        //every time the button is pressed if indicator is spinning stop it,
        //if not, start spinning for 3 seconds
        if timer.isValid {
            timer.invalidate()
            activityIndicatorView.stopAnimating()
        } else {
            resetTimer()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapCounterLabel()
        createTimer()
    }
    
    func createTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            self?.activityIndicatorView.stopAnimating()
        }
        activityIndicatorView.startAnimating()
    }
    
    func resetTimer() {
        timer.invalidate()
        createTimer()
    }
    
    func setupTapCounterLabel() {
        counterLabel.text = "Please tap the button."
        counterLabel.layer.cornerRadius = 10
    }
    
}
