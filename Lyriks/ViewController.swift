//
//  ViewController.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 28/07/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var backgroundImage: UIImageView!
    let movieApi = MovieAPI()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        movieApi.discoverPopular { (moviesArray) in
            print(moviesArray.results.count)
            if let firstMovie = moviesArray.results.first{
                self.movieApi.getPosterImage(width: 200, path: firstMovie.poster_path ?? "", onComplete: { (posterImage) in
                    self.backgroundImage.image = posterImage
                })
            }
            
            
        }
    }


}

