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
    fileprivate let genresUrl = "https://api.themoviedb.org/3/genre/movie/list?\(apiKey)"


enum DiscoverParameters{
     case genre([Int])
     case releaseYear(Int)
    func toString()->String{
        switch self {
        case .genre(let genres):
            var result = "with_genres="
            genres.forEach { (genre) in
                result.append("\(genre),")
            }
            result.removeLast()
            return result
        case .releaseYear(let year):
            return "primary_release_year=\(year)"
        }
    }
    
}
enum SortParameters {
    case voteAverage
    case popularity
    case revenue
    func toString()->String{
        switch self {
        case .voteAverage:
            return "vote_average"
        case .popularity:
            return "popularity"
        case .revenue:
            return "revenue"
        }
    }
   
}
enum Sort{
    case asc(SortParameters)
    case desc(SortParameters)
    
    func toString()->String{
        switch self {
        case .asc(let parameter):
            return "sort_by=\(parameter).asc"
        case .desc(let parameter):
            return "sort_by=\(parameter).desc"
        }
    }
}
enum Request{
    case search(String)
    case discover
    case find(Int)
    case popular(Int)
    
    func toString()->String{
        switch self {
        case .search(let text):
            let parameter = text.split { (character) -> Bool in
                return character == " "
            }
            var result = "\(baseUrl)/search/movie?\(apiKey)&query="
            parameter.forEach { (string) in
                result.append("\(string)+")
            }
            result.removeLast()
            return result
        case .discover:
            return  "\(baseUrl)/discover/movie?\(apiKey)"
        case .find(let id):
            return  "\(baseUrl)/find/\(id)?\(apiKey)&language=en-US&external_source=imdb_id"
        case .popular(let page):
            return "\(baseUrl)/movie/popular?\(apiKey)&language=en-US&page=\(page)"
        }
    }
}
struct MovieAPI {
     static var genre:[Genre] = []
    
    /**
     Build and validate URL construction
     
     - Parameter path: Path for image gotten from the movie object.
     
     - Throws: `NetworkError.invalidURL(String)`
     */
    static func BuildURL(path:String)throws->URL{
        guard let url = URL(string:path)else{
            throw NetworkError.invalidURL("Cannot build URL with given path")
        }
        return url
    }
    /**
     Generic function for requests
     */
    static private func request(path:String,_ code:@escaping (Data) ->Void){
        do {
            let url = try BuildURL(path: path)
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                //check for data
                guard let data = data else{return}
                code(data)
                }.resume()
        } catch let err {
            print(err)
            return
        }
        
        
    }
     static func fetchGenres(){
        request(path:genresUrl ) { (data) in
            do{
                let result = try JSONDecoder().decode(GenreRequest.self, from: data)
                
                genre = result.genres
            }catch let err{
                print(err)
            }

           
        }
    }
    /**
     Call for a trailer on youtube
     - Parameter id: id from the movie
     
     */
    static func requestYoutube(id:String){
             getYoutubeUrl(id: id) { path,err  in
                if let error = err,let _ = path{
                    print(error)
                    return
                }
                do{
                    let url = try BuildURL(path: path!)
                    //                guard let url = try BuildURL(path: path)else{
                    //                     return
                    //                }
                    DispatchQueue.main.async {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }catch let err{
                    //TODO:Criar alerta de video indisponivel
                    print(err)
                    return
                }
                
            }

        
        
        
    }

    
   
    /**
     Get poster image from the API
     
     - Parameter path: Path for image gotten from the movie object.
     
     */
      static func getPosterImage(width:Int,path:String,onComplete:@escaping(UIImage?)->Void){
        var urlPath = imageURL.replacingOccurrences(of: "@", with: "\(width)")
        urlPath.append(path)
        
        request(path: urlPath) { (data) in
            let image = UIImage(data: data)
            //UI updates need to be done on main queue
            DispatchQueue.main.async {
                onComplete(image ?? UIImage(named: "image_not_found"))
            }
        }
        
        
        }
    /**
     Get results on request for movies on the api
     - Parameter id: id from the movie
     
    */
     static private func getMovieTrailer(id:String,onComplete:@escaping (VideoRequest?,NetworkError?)->Void){
        let adjustedPath = trailerURL.replacingOccurrences(of: "@", with: id)
        request(path: adjustedPath) { (data) in
            do{
                let videos = try JSONDecoder().decode(VideoRequest.self, from: data)
                //API return an empty array for no results :(
                if videos.results.isEmpty{
                    onComplete(nil,NetworkError.invalidVideo("Videos not found"))
                }else{
                      onComplete(videos,nil)
                }
               
            }catch let err{
                print(err)
            }
           
        }
    }
    /**
     Get youtube url for the id given on video requests
     - Parameter id: id from the trailer at youtube
     
     */
    static func getYoutubeUrl(id:String,onComplete:@escaping (String?,NetworkError?)->Void){
        getMovieTrailer(id: id) { (request,err) in
            if let firstResult = request?.results.first{
                    var err:NetworkError? = nil
                    var url = ""
                    if let key = firstResult.key{
                         url = "\(youtubeUrl)\(key)"
                    } else{
                        err = NetworkError.invalidVideo("Video not Found")
                    }
                        onComplete(url, err)
                    
                    
            }else{
                 onComplete(nil, err)
            }
            
            
            }
        
    }
    static func movieRequest(path:String,onComplete:@escaping (MovieRequest)->Void){
        request(path: path) { (data) in
            do{
                let movies = try JSONDecoder().decode(MovieRequest.self, from: data)
                 onComplete(movies)
            }catch let err{
                print(err)
            }
        }
    }
}

