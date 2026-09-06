//
//  LoadingView.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import UIKit

public class LoadingView {
    private static var container: UIView?
    private static var spinner: UIActivityIndicatorView?
    private static var isObserving = false
    
    public static func show(on view: UIView? = nil, blocksInteraction: Bool = true) {
        DispatchQueue.main.async {
            guard container == nil else { return } // already shown
            
            if !isObserving {
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(update),
                                                       name: UIDevice.orientationDidChangeNotification,
                                                       object: nil)
                isObserving = true
            }
            
            // Find current key window in a scene-safe way
            let window = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })
            
            guard let window else { return }
            
            // Overlay container
            let overlay = UIView(frame: window.bounds)
            overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlay.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            
            // Activity Indicator
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.startAnimating()
            
            overlay.addSubview(indicator)
            NSLayoutConstraint.activate([
                indicator.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
                indicator.centerYAnchor.constraint(equalTo: overlay.centerYAnchor)
            ])
            
            window.addSubview(overlay)
            
            container = overlay
            spinner = indicator
        }
    }
    
    public static func hide() {
        DispatchQueue.main.async {
            if isObserving {
                NotificationCenter.default.removeObserver(self,
                                                          name: UIDevice.orientationDidChangeNotification,
                                                          object: nil)
                isObserving = false
            }
            spinner?.stopAnimating()
            container?.removeFromSuperview()
            spinner = nil
            container = nil
        }
    }
    
    @objc public static func update() {
        DispatchQueue.main.async {
            guard let overlay = container,
                  let window = overlay.superview ?? UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) else { return }
            // Keep overlay full-screen on orientation change
            overlay.frame = window.bounds
        }
    }
}
