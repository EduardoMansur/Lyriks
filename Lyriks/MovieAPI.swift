//
//  MovieAPI.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 28/07/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit
    fileprivate let apiKey = "api_key=4d0fcba3ff303036e7acc80cc54f5f24"
    fileprivate let baseUrl = "https://api.themoviedb.org/3"
    fileprivate let imageURL = "http://image.tmdb.org/t/p/w@/"
//discover example api.themoviedb.org/3/discover/movie?api_key=4d0fcba3ff303036e7acc80cc54f5f24&primaryreleasedate.gte=2016-01-01
class MovieAPI {
  
     func discoverPopular(
        onComplete:@escaping (Request)->Void){
        
        guard let url = URL(string: "\(baseUrl)/discover/movie?\(apiKey)&sort_by=popularity.desc")else{
            //throw NetworkError.invalidURL("not a valid url")
            fatalError()
        }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //check for data
            guard let data = data else{return}
            do{
                let movies = try JSONDecoder().decode(Request.self, from: data)
                onComplete(movies)
            }catch let jsonErr{
                //TODO:Custom error
                print(jsonErr)
            }
            
            
        }.resume()
   
    }
    static func getPosterImage(width:Int,path:String,onComplete:@escaping(UIImage?)->Void){
        var urlPath = imageURL.replacingOccurrences(of: "@", with: "\(width)")
        urlPath.append(path)
        guard let url = URL(string: urlPath) else{
            fatalError()
        }

        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //check for data
            guard let data = data else{return}
            let image = UIImage(data: data)
            //UI updates need to be done on main queue
            DispatchQueue.main.async {
                onComplete(image ?? UIImage())
            }
            
            }.resume()
        
    }
}
