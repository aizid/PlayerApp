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
    
    private let lblAppTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "PlayerApp"
        lbl.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        lbl.textColor = .label
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let lblTagline: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Music Streaming Experience"
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .secondaryLabel
        lbl.textAlignment = .center
        return lbl
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    func reloadModeView() {
    }
}

extension LaunchView {
    private func setupLayout() {
        addSubview(lblAppTitle)
        addSubview(lblTagline)
        
        NSLayoutConstraint.activate([
            lblAppTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            lblAppTitle.topAnchor.constraint(equalTo: centerYAnchor, constant: 95),
            
            lblTagline.centerXAnchor.constraint(equalTo: centerXAnchor),
            lblTagline.topAnchor.constraint(equalTo: lblAppTitle.bottomAnchor, constant: 4)
        ])
        
        lblInfo.text = "Powered by iTunes & Apple Music API"
        lblInfo.textColor = .secondaryLabel
        lblInfo.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        lblVersion.textColor = .tertiaryLabel
        lblVersion.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    }
    
    private func setupLayoutConstraint() {
        self.layoutIfNeeded()
    }
    
    private func registerListener() {
    }
}
