//
//  DetailsViewModel.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 01/08/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit

class DetailsViewModel {
    let id:Int
    let overview:NSAttributedString
    let release:NSAttributedString
    let voteAverage:NSAttributedString
    var favorite:Bool = false
    init(movie:Movie){
        id  = movie.id
        overview = NSAttributedString(string: "    \(movie.overview ?? "")\n" , attributes: Typography.description(.black).attributes())
        if let date = movie.release_date{
            var fixDate = date.split(separator: "-")
            fixDate.reverse()
            let releaseString = NSMutableAttributedString(string: "releases in ", attributes: Typography.description(Color.black).attributes())
            releaseString.append(NSAttributedString(string: "\(fixDate.joined(separator: "-"))", attributes: Typography.description(Color.scarlet).attributes()))
            release
             = releaseString
        }else{
            release = NSAttributedString(string: "Not available", attributes: Typography.description(.black).attributes())
        }
        let voteString =  NSMutableAttributedString(string: "Review:", attributes: Typography.description(Color.black).attributes())
        voteString.append(NSAttributedString(string:String(movie.vote_average),attributes:Typography.description(Color.scarlet).attributes()))
        voteAverage = voteString
        
    }
    init(){
        id = 0
        voteAverage = NSAttributedString(string: "7", attributes: Typography.description(Color.black).attributes())
        release = NSAttributedString(string: "11/11/1111", attributes: Typography.description(Color.black).attributes())
        overview = NSAttributedString(string: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur a lobortis metus. Curabitur laoreet volutpat orci et vestibulum. Nulla ullamcorper imperdiet ipsum, ac cursus nulla consectetur vel. Integer efficitur sodales elit, non convallis elit malesuada vel. Ut eget hendrerit velit. Nam id tellus eros. Etiam pellentesque ligula sapien, at faucibus enim posuere sit amet. Ut commodo tellus orci, eu rhoncus sapien semper convallis.", attributes: Typography.description(Color.black).attributes())
    }
}
