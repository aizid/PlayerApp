//
//  BaseViewController.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Foundation
import UIKit
import RxSwift
import IQKeyboardManagerSwift

@objc protocol BaseViewControllerDelegate: AnyObject {
    @objc optional func showLoadProgress(state: Bool)
    @objc optional func showErrorMessage(errorMessage: String)
}

class BaseViewController: UIViewController {
    
    weak var delegateBase: BaseViewControllerDelegate?
    
    private var loadingCounter = 0 {
        didSet {
            if loadingCounter > 0 {
                showProgressDialog()
            } else {
                hideProgressDialog()
            }
        }
    }
    
    private lazy var loadingDialog: UIActivityIndicatorView = {
        // Create an indicator.
        let loadingDialog = UIActivityIndicatorView()
        loadingDialog.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        loadingDialog.center = self.view.center
        
        // Also show the indicator even when the animation is stopped.
        loadingDialog.hidesWhenStopped = false
        loadingDialog.style = UIActivityIndicatorView.Style.white
        
        // Start animation.
        loadingDialog.startAnimating()
        
        return loadingDialog
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
        if !error.isEmpty {
            /*let rc = error.getResponseCode
            let message = error.getResponseMessage
            let messageDesc = error.getResponseMessageDescription
            let lastEndpoint = error.getRecentEndpoint
            
            CrashLog.nonFatal(
                userId: SkollaPreference.getEncrypt(for: PreferKey.idAccountNF.rawValue),
                viewName: String(describing: self),
                error: error,
                crashErrorCode: Constant.ERROR_VISIBLE_USER,
                responseCode: rc,
                serviceLink: lastEndpoint)
            
            switch rc {
            case "\(ErrMsgConst.SESSION_TIME_OUT)", "0": DialogMapper.sessionLogoutMessage(controller, error: error)
            case "\(ErrMsgConst.BAD_REQUEST)": DialogMapper.messageBadRequested(lastEndpoint, self, rc, error, message, messageDesc)
            case "\(ErrMsgConst.DB_INVALID_INSTANCE)":
                DialogMapper.defaultMessageError(controller, rc: rc, message: message, messageDesc: "msg_reinstall_app".localized())
            case "\(ErrMsgConst.RESOURCE_NOT_FOUND)":
                if lastEndpoint == "itembank/app/item" {
                    DialogMapper.showPopupDeniedStartLatSoal(self)
                } else {
                    DialogMapper.messageGeneralError(self, responseCode: rc, message: message)
                }
            case "\(ErrMsgConst.ERROR_INFO)": DialogMapper.messageErrorInfo(controller, message: message)
            case "\(ErrMsgConst.DETECT_NEW_DEVICE)":
                DialogMapper.showPopupDetectNewDevice(self, responseCode: rc, message: message)
            default:
                if rc.contains("\(ErrMsgConst.INACTIVE_ACCOUNT)") {
                    DialogMapper.showPopupInActiveAccount(self, responseCode: rc, message: Messages.inActiveAccount.isMessageTitle)
                } else {
                    DialogMapper.messageGeneralError(self, responseCode: rc, message: message, recentEndpoint: lastEndpoint)
                }
            }*/
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
            self.loadingCounter += 1
            self.loadingDialog.startAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    func hideProgressDialog() {
        DispatchQueue.main.async {
            self.loadingCounter -= 1
            if self.loadingCounter <= 0 {
                self.loadingDialog.stopAnimating()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.loadingCounter = 0 // Reset to prevent negative values
            }
        }
    }
}
