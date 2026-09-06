//
//  ViewController.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//
import UIKit
import RxSwift

class MainVC: BaseViewController, UITextFieldDelegate, StoryboardInstantiable, Alertable {
    
    private var delegate: MainVC!
    
    @IBOutlet var mainView: MainView!
    private var viewModel: MainVM!
    static let myNotification = Notification.Name(ConstantKey.KEY_LAYOUT_MAIN)
    
    // MARK: - Lifecycle
    
    static func create(with viewModel: MainVM) -> MainVC {
        let view = MainVC.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        initDataResponse()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationDialog(notification:)), name: MainVC.myNotification, object: nil)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: MainVC.myNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // MARK: - Private
    
    private func setupViews() {
        
    }

    func initNavigation(){
    }
    
    
    // MARK: - NotificationCenterResponse
    @objc func onNotificationDialog(notification:Notification) {
    }
    
    
    // MARK: - initDataResponse
    private func initDataResponse() {
        
    }
    
}

