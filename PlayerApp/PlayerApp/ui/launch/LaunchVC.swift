//
//  LaunchVC.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//
import UIKit
import RxSwift

class LaunchVC: BaseViewController, UITextFieldDelegate, StoryboardInstantiable, Alertable {
    
    private var delegate: LaunchVC!
    
    @IBOutlet var launchView: LaunchView!
    private var viewModel: LaunchVM!
    static let myNotification = Notification.Name(ConstantKey.KEY_LAYOUT_LAUNCH)
    
    // MARK: - Lifecycle
    
    static func create(with viewModel: LaunchVM) -> LaunchVC {
        let view = LaunchVC.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initDataResponse()
        initNavigation()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationDialog(notification:)), name: LaunchVC.myNotification, object: nil)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: LaunchVC.myNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // MARK: - Private
    
    private func setupViews() {
        
        launchView.lblVersion.text = Bundle.main.ShowAppVersion
    }

    func initNavigation(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.viewModel.didShowMain()
        }
    }
    
    
    // MARK: - NotificationCenterResponse
    @objc func onNotificationDialog(notification:Notification) {
    }
    
    
    // MARK: - initDataResponse
    private func initDataResponse() {
        
    }
    
}

