//
//  CollectionCellViewModel.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 28/07/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit

class CollectionCellViewModel{
    var image:UIImage? = UIImage(named: "image-not-found")
    let id:Int
    let video:Bool
    let title:NSAttributedString
    init(movie:Movie){
        self.title = NSAttributedString(string:  movie.title ?? "", attributes: Typography.title(.black).attributes())
        self.id = movie.id
        self.video = movie.video
        let movieApi = MovieAPI()
        movieApi.getPosterImage(width: 200, path: movie.poster_path ?? "") { (image) in
            self.image = image
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FetchImage"), object: nil)
        }
    }

}
