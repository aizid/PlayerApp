//
//  PlayerBarView.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import UIKit
import Kingfisher

public final class PlayerBarView: UIView {
    
    // MARK: - Callbacks
    public var onPlayPauseTapped: (() -> Void)?
    public var onNextTapped: (() -> Void)?
    public var onPreviousTapped: (() -> Void)?
    public var onSeek: ((Float) -> Void)?
    
    public private(set) var isSeeking: Bool = false
    
    // MARK: - Subviews
    private let containerCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.15, green: 0.15, blue: 0.17, alpha: 0.96)
                : UIColor(red: 0.97, green: 0.97, blue: 0.99, alpha: 0.96)
        }
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.12
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 8
        return view
    }()
    
    private let ivArtwork: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        iv.image = UIImage(named: "Plays")
        return iv
    }()
    
    private let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        lbl.textColor = .label
        lbl.text = "Select a song to play"
        return lbl
    }()
    
    private let lblArtist: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        lbl.textColor = .secondaryLabel
        lbl.text = "Music Player"
        return lbl
    }()
    
    private let btnPrevious: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        btn.setImage(UIImage(systemName: "backward.fill", withConfiguration: config), for: .normal)
        btn.tintColor = .label
        return btn
    }()
    
    private let btnPlayPause: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        btn.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        btn.tintColor = .systemBlue
        return btn
    }()
    
    private let btnNext: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        btn.setImage(UIImage(systemName: "forward.fill", withConfiguration: config), for: .normal)
        btn.tintColor = .label
        return btn
    }()
    
    public let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.0
        slider.tintColor = .systemBlue
        slider.setThumbImage(UIImage(systemName: "circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)), for: .normal)
        return slider
    }()
    
    private let lblCurrentTime: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.monospacedDigitSystemFont(ofSize: 11, weight: .regular)
        lbl.textColor = .secondaryLabel
        lbl.text = "00:00"
        return lbl
    }()
    
    private let lblDuration: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.monospacedDigitSystemFont(ofSize: 11, weight: .regular)
        lbl.textColor = .secondaryLabel
        lbl.text = "00:30"
        lbl.textAlignment = .right
        return lbl
    }()
    
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        registerActions()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        registerActions()
    }
    
    // MARK: - Layout Setup
    private func setupViews() {
        backgroundColor = .clear
        
        addSubview(containerCard)
        containerCard.addSubview(ivArtwork)
        
        let textStack = UIStackView(arrangedSubviews: [lblTitle, lblArtist])
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.axis = .vertical
        textStack.spacing = 2
        containerCard.addSubview(textStack)
        
        let controlsStack = UIStackView(arrangedSubviews: [btnPrevious, btnPlayPause, btnNext])
        controlsStack.translatesAutoresizingMaskIntoConstraints = false
        controlsStack.axis = .horizontal
        controlsStack.spacing = 16
        controlsStack.alignment = .center
        containerCard.addSubview(controlsStack)
        
        let timeStack = UIStackView(arrangedSubviews: [lblCurrentTime, slider, lblDuration])
        timeStack.translatesAutoresizingMaskIntoConstraints = false
        timeStack.axis = .horizontal
        timeStack.spacing = 8
        timeStack.alignment = .center
        containerCard.addSubview(timeStack)
        
        NSLayoutConstraint.activate([
            containerCard.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            containerCard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            containerCard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            containerCard.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            
            // Artwork
            ivArtwork.leadingAnchor.constraint(equalTo: containerCard.leadingAnchor, constant: 12),
            ivArtwork.topAnchor.constraint(equalTo: containerCard.topAnchor, constant: 12),
            ivArtwork.widthAnchor.constraint(equalToConstant: 46),
            ivArtwork.heightAnchor.constraint(equalToConstant: 46),
            
            // Text Stack
            textStack.leadingAnchor.constraint(equalTo: ivArtwork.trailingAnchor, constant: 10),
            textStack.centerYAnchor.constraint(equalTo: ivArtwork.centerYAnchor),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: controlsStack.leadingAnchor, constant: -8),
            
            // Controls Stack
            controlsStack.trailingAnchor.constraint(equalTo: containerCard.trailingAnchor, constant: -12),
            controlsStack.centerYAnchor.constraint(equalTo: ivArtwork.centerYAnchor),
            
            // Play Button Size
            btnPlayPause.widthAnchor.constraint(equalToConstant: 36),
            btnPlayPause.heightAnchor.constraint(equalToConstant: 36),
            btnPrevious.widthAnchor.constraint(equalToConstant: 28),
            btnPrevious.heightAnchor.constraint(equalToConstant: 28),
            btnNext.widthAnchor.constraint(equalToConstant: 28),
            btnNext.heightAnchor.constraint(equalToConstant: 28),
            
            // Time & Slider Stack
            timeStack.topAnchor.constraint(equalTo: ivArtwork.bottomAnchor, constant: 8),
            timeStack.leadingAnchor.constraint(equalTo: containerCard.leadingAnchor, constant: 12),
            timeStack.trailingAnchor.constraint(equalTo: containerCard.trailingAnchor, constant: -12),
            timeStack.bottomAnchor.constraint(equalTo: containerCard.bottomAnchor, constant: -10),
            
            lblCurrentTime.widthAnchor.constraint(equalToConstant: 36),
            lblDuration.widthAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    // MARK: - Actions
    private func registerActions() {
        btnPlayPause.addTarget(self, action: #selector(actionPlayPause), for: .touchUpInside)
        btnNext.addTarget(self, action: #selector(actionNext), for: .touchUpInside)
        btnPrevious.addTarget(self, action: #selector(actionPrevious), for: .touchUpInside)
        
        slider.addTarget(self, action: #selector(sliderTouchDown), for: .touchDown)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func actionPlayPause() {
        onPlayPauseTapped?()
    }
    
    @objc private func actionNext() {
        onNextTapped?()
    }
    
    @objc private func actionPrevious() {
        onPreviousTapped?()
    }
    
    @objc private func sliderTouchDown() {
        isSeeking = true
    }
    
    @objc private func sliderValueChanged() {
        let currentTime = Double(slider.value) * 30.0 // estimate preview duration
        lblCurrentTime.text = formatTime(currentTime)
    }
    
    @objc private func sliderTouchUp() {
        isSeeking = false
        onSeek?(slider.value)
    }
    
    // MARK: - Public API
    
    public func updateTrack(song: SongModel) {
        lblTitle.text = song.trackName.isEmpty ? "Unknown Title" : song.trackName
        lblArtist.text = song.artistName.isEmpty ? "Unknown Artist" : song.artistName
        
        if let url = URL(string: song.artworkUrl100), !song.artworkUrl100.isEmpty {
            ivArtwork.kf.setImage(with: url, placeholder: UIImage(named: "Plays"))
        } else {
            ivArtwork.image = UIImage(named: "Plays")
        }
    }
    
    public func updatePlayState(isPlaying: Bool) {
        let imageName = isPlaying ? "pause.fill" : "play.fill"
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        btnPlayPause.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
    }
    
    public func updateProgress(currentTime: TimeInterval, duration: TimeInterval) {
        guard !isSeeking else { return }
        
        if duration > 0 {
            slider.value = Float(currentTime / duration)
        }
        lblCurrentTime.text = formatTime(currentTime)
        lblDuration.text = formatTime(duration)
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        guard !seconds.isNaN && !seconds.isInfinite && seconds >= 0 else { return "00:00" }
        let totalSec = Int(seconds)
        let min = totalSec / 60
        let sec = totalSec % 60
        return String(format: "%02d:%02d", min, sec)
    }
}
