//
//  BaseViewController.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Foundation
import UIKit
import RxSwift

@objc protocol BaseViewControllerDelegate: AnyObject {
    @objc optional func showLoadProgress(state: Bool)
    @objc optional func showErrorMessage(errorMessage: String)
    
    @objc optional func screenActiveCallback(value: Bool)
}

class BaseViewController: UIViewController {
    
    weak var delegateBase: BaseViewControllerDelegate?
    
    private lazy var loadingOverlayView: UIView = {
        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        
        let box = UIView()
        box.translatesAutoresizingMaskIntoConstraints = false
        box.backgroundColor = UIColor.secondarySystemBackground
        box.layer.cornerRadius = 14
        box.layer.shadowColor = UIColor.black.cgColor
        box.layer.shadowOpacity = 0.15
        box.layer.shadowOffset = CGSize(width: 0, height: 4)
        box.layer.shadowRadius = 8
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .systemBlue
        indicator.startAnimating()
        
        box.addSubview(indicator)
        overlay.addSubview(box)
        
        NSLayoutConstraint.activate([
            box.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            box.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),
            box.widthAnchor.constraint(equalToConstant: 80),
            box.heightAnchor.constraint(equalToConstant: 80),
            
            indicator.centerXAnchor.constraint(equalTo: box.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: box.centerYAnchor)
        ])
        
        return overlay
    }()
    
    public var screenName: String = ""
    public var sharedData: [String: Any] = [:]
    public weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    private var disposeBag = DisposeBag()
    //
    var isScreenActive: Bool = false
    private var workItem: DispatchWorkItem?
}

// MARK: - Overriding method
extension BaseViewController {
    override func viewWillAppear(_ animated: Bool) {
        isScreenActive = true
        delegateBase?.screenActiveCallback?(value: isScreenActive)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isScreenActive = false
        delegateBase?.screenActiveCallback?(value: isScreenActive)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogAnalytic(mScreenName: screenName)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            let isDarkMode = traitCollection.userInterfaceStyle == .dark
            return isDarkMode ? .lightContent : .darkContent
        } else {
            return .default // Default status bar style for iOS 12 and earlier
        }
    }
}

// MARK: Showing Info / Indicator
extension BaseViewController {
    public func showLoadProgress(isLoad: Bool) {
        if isLoad {
            showProgressDialog()
        } else {
            hideProgressDialog()
        }
    }
    
    public func erroHandler<VC: UIViewController>(_ controller: VC, error: String) {
        Log.debug("🔴 ERROR HANDLER NOTICED 🔴 ~> \(error)")
        DispatchQueue.main.async {
            let message = error.isEmpty ? "An unexpected error occurred. Please try again later." : error
            let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            controller.present(alert, animated: true)
        }
    }
    
    public func LogAnalytic(mScreenName: String) {
        if !mScreenName.isEmpty {
            Log.debug("🟢 INFO 🟢 Analytic Screen Name: \(mScreenName)")
            //Analytics.logEvent(AnalyticsEventScreenView, parameters: [AnalyticsParameterScreenName: mScreenName])
        }
    }
}

// MARK: - Handle progress indicator listener
extension BaseViewController {
    func showProgressDialog() {
        DispatchQueue.main.async {
            guard self.loadingOverlayView.superview == nil else { return }
            self.view.addSubview(self.loadingOverlayView)
            NSLayoutConstraint.activate([
                self.loadingOverlayView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.loadingOverlayView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.loadingOverlayView.topAnchor.constraint(equalTo: self.view.topAnchor),
                self.loadingOverlayView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
            self.loadingOverlayView.alpha = 0
            UIView.animate(withDuration: 0.2) {
                self.loadingOverlayView.alpha = 1.0
            }
        }
    }
    
    func hideProgressDialog() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                self.loadingOverlayView.alpha = 0
            }) { _ in
                self.loadingOverlayView.removeFromSuperview()
            }
        }
    }
}
