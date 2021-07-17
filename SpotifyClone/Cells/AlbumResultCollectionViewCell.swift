//
//  AlbumResultCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Ahmad on 17/07/2021.
//

import UIKit

class AlbumResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumArtistLbl: UILabel!
    @IBOutlet weak var albumsTrack: UILabel!
    @IBOutlet weak var albumReleaseDateLbl: UILabel!
    @IBOutlet weak var albumPreviewOnSpotifyBtn: UIButton!
    
    var previewOnSpotifyBtnPressed : ((Any) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onClickPreviewOnSpotify(_ sender: Any) {
        self.previewOnSpotifyBtnPressed?(sender)
    }
    
}
