//
//  ArtistCell.swift
//  TuneSearch
//
//  Created by Valerie Greer on 2/7/17.
//  Copyright © 2017 Shane Empie. All rights reserved.
//

import UIKit

class ArtistCell: NSObject {
    
    var artistName  :String!
    var albumName   :String!
    var songName    :String!
    
    init(artist: String, album: String, song: String) {
        self.artistName = artist
        self.albumName = album
        self.songName = song
    }

}
