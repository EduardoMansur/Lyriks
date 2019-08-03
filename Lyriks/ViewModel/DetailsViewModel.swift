//
//  DetailsViewModel.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 01/08/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit

class DetailsViewModel {
    let id:String
    let overview:NSAttributedString
    let release:NSAttributedString
    let voteAverage:NSAttributedString
    var favorite:Bool = false
    private let model:Movie
    init(movie:Movie){
        self.model = movie
        id  = movie.id
        overview = NSAttributedString(string: "    \(movie.overview )\n" , attributes: Typography.description(.black).attributes())
        let date = movie.release_date
        var fixDate = date.split(separator: "-")
        fixDate.reverse()
        let releaseString = NSMutableAttributedString(string: "releases in ", attributes: Typography.description(Color.black).attributes())
        releaseString.append(NSAttributedString(string: "\(fixDate.joined(separator: "-"))", attributes: Typography.description(Color.scarlet).attributes()))
        release
         = releaseString
        
        let voteString =  NSMutableAttributedString(string: "Review:", attributes: Typography.description(Color.black).attributes())
        voteString.append(NSAttributedString(string:String(movie.vote_average),attributes:Typography.description(Color.scarlet).attributes()))
        voteAverage = voteString
        
    }
    func getModel()->Movie{
        return self.model
    }

}
