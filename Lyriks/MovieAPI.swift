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
    fileprivate let trailerURL = "http://api.themoviedb.org/3/movie/@/videos?\(apiKey)"
    fileprivate let youtubeUrl  = "https://www.youtube.com/watch?v="

class MovieAPI {
  
     func discoverPopular(
        onComplete:@escaping (MovieRequest)->Void){

        let adjustedPath = "\(baseUrl)/discover/movie?\(apiKey)&sort_by=popularity.desc"
        request(path: adjustedPath) { (data) in
            do{
                let movies = try JSONDecoder().decode(MovieRequest.self, from: data)
                onComplete(movies)
            }catch{
                throw NetworkError.invalidURL("Error on JSON conversion")
            }
            
            
         
        }
   
    }
     func getPosterImage(width:Int,path:String,onComplete:@escaping(UIImage?)->Void){
        var urlPath = imageURL.replacingOccurrences(of: "@", with: "\(width)")
        urlPath.append(path)
        
        request(path: urlPath) { (data) in
            let image = UIImage(data: data)
            //UI updates need to be done on main queue
            DispatchQueue.main.async {
                onComplete(image ?? UIImage())
            }
        }
        
        
    }
    private func getMovieTrailer(id:String,onComplete:@escaping (VideoRequest)->Void){
        let adjustedPath = trailerURL.replacingOccurrences(of: "@", with: id)
        request(path: adjustedPath) { (data) in
            let movies = try JSONDecoder().decode(VideoRequest.self, from: data)
            onComplete(movies)
        }
    }
    private func getYoutubeUrl(id:String,onComplete:@escaping (String)->Void){
        getMovieTrailer(id: id) { (request) in
            if let firstResult = request.results.first{
                let url = "\(youtubeUrl)\(firstResult.key ?? "")"
                onComplete(url)
            }
        }
        
    }
    public func requestYoutube(id:String){
        getYoutubeUrl(id: id) { (path) in
            guard let url = URL(string:path)else{
                return
            }
            DispatchQueue.main.async {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
                
            
        }
        
    }
    private func request(path:String,_ code:@escaping (Data) throws->Void){
        guard let url = URL(string:path)else{
            
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //check for data
            guard let data = data else{return}
            do{
                try code(data)
                
            }catch let err{
                //TODO:Custom error
                print(err)
            }
            
            
            }.resume()
        
    }
}
