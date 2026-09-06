//
//  LaunchView.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//
import Foundation
import UIKit

protocol LaunchViewDelegate: AnyObject {
    // Collection
}

protocol LaunchViewDataSource: AnyObject {
    // Tabel
}

class LaunchView: UIView {
    
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    func reloadModeView() {
//        vwAbout.setSquaredTextCustom(radius: 8, brdrColor: "border_line", bgColor: "bg_white")
    }
}

extension LaunchView {
    private func setupLayout() {
        setupLayoutConstraint()
        
//        vwSearchEipoAbout.setSquaredTextCustom(radius: 8, brdrColor: "border_line", bgColor: "bg_white")
    }
    
    private func setupLayoutConstraint() {
        self.layoutIfNeeded()
        
    }
    
    private func registerListener() {
        //btn.addTarget(self, action: #selector(actionUpdateListener(_:)), for: .touchUpInside)
    }
}
