//
//  Movie.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 28/07/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit

struct Movie:Codable {
    //parameters needed
    let vote_count:Int?
    let id:Int
    let video:Bool
    let vote_average:Float
    let title:String?
    let popularity:Float?
    let poster_path:String?
    let original_language:String?
    let original_title:String?
    let genre_ids:[Int]?
    let backdrop_path:String?
    let adult:Bool?
    let overview:String?
    let release_date:String?

}
struct MovieRequest:Decodable{
    let results:[Movie]
}
struct GenreRequest:Decodable{
    let genres:[Genre]
}
struct Genre:Codable {
    //parameters needed
    let id:Int
    let name:String
}
