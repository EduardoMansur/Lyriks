//
//  ViewController.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 28/07/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit
protocol UIUpdate{
    func fetchUI()
}
class ViewController: UIViewController {
    var mainCollection = MainCollectionView(data: [])
    let movieApi = MovieAPI()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewCoding()
        mainCollection.didSelect = {(model) in
            if model.video {
                self.movieApi.requestYoutube(id: "\(model.id)")
            }
        }
        movieApi.discoverPopular { (moviesArray) in
            self.mainCollection.data = self.convertToModel(movie: moviesArray.results)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.fire), name: NSNotification.Name(rawValue: "FetchImage"), object: nil)
        mainCollection.didSelect = {(model) in
            //self.movieApi.requestYoutube(id: "\(model.id)")
            
        }


      
    }

    
    @objc func fire()
    {
        mainCollection.reloadData()
    }
    func convertToModel(movie:[Movie]) -> [CollectionCellViewModel]{
        var modelArray:[CollectionCellViewModel] = []
        movie.forEach { (movie) in
            modelArray.append(CollectionCellViewModel(movie: movie))
        }
        return modelArray
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        mainCollection.scrollToItem(at: IndexPath(row: 0, section: 0),
//                                    at: .centeredHorizontally,
//                                    animated: true)
    }


}
extension ViewController:ViewCoding{
    func buildViewHierarchy() {
      
        self.view.addSubview(mainCollection)
      
        
    }
    
    func setUpConstraints() {
        mainCollection.fillSuperview()
     

    }
    
    func additionalConfigs() {

      self.view.backgroundColor = Color.gray
    }

    
}



