//
//  SongViewCell.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import UIKit
import Kingfisher

protocol SongViewCellInterface {
    var id: Int {get}
    var trackName: String {get}
    var artistName: String {get}
    var collectionName: String {get}
    var previewUrl: String {get}
    var artworkUrl100: String {get}
    var trackTimeMillis: Int {get}
}

class SongViewCell: UITableViewCell {
    
    @IBOutlet weak var ivArtWork: UIImageView!
    @IBOutlet weak var ivIconPlay: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblArtist: UILabel!
    @IBOutlet weak var lblAlbum: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        ivArtWork.layer.cornerRadius = 8
        ivArtWork.clipsToBounds = true
        ivArtWork.backgroundColor = .systemGray6
        ivIconPlay.tintColor = .systemBlue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var interface: SongViewCellInterface? {
        didSet {
            if let interface = interface {
                lblTitle.text = interface.trackName
                lblArtist.text = interface.artistName
                lblAlbum.text = interface.collectionName
                
                if let url = URL(string: interface.artworkUrl100), !interface.artworkUrl100.isEmpty {
                    ivArtWork.kf.setImage(with: url, placeholder: UIImage(named: "Plays"))
                } else {
                    ivArtWork.image = UIImage(named: "Plays")
                }
            }
        }
    }
    
    func setPlayingState(isCurrent: Bool, isPlaying: Bool) {
        if isCurrent {
            ivIconPlay.isHidden = false
            let iconName = isPlaying ? "waveform.circle.fill" : "pause.circle.fill"
            ivIconPlay.image = UIImage(systemName: iconName)
            contentView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.06)
        } else {
            ivIconPlay.isHidden = true
            contentView.backgroundColor = .clear
        }
    }
}
