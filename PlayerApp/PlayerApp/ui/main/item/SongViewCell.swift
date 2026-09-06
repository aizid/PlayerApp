//
//  SongViewCell.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import UIKit

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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    var interface: SongViewCellInterface? {
        didSet {
            if let interface = interface {
                lblTitle.text = interface.trackName
                lblArtist.text = interface.artistName
                lblAlbum.text = interface.collectionName
            }
        }
    }
}
