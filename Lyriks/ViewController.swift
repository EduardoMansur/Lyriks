//
//  ViewController.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 28/07/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var mainCollection = MainCollectionView(data: [])
    let movieApi = MovieAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewCoding()
        // Do any additional setup after loading the view.
        movieApi.discoverPopular { (moviesArray) in
            self.mainCollection.data = self.convertToModel(movie: moviesArray.results)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.fire), name: NSNotification.Name(rawValue: "FetchImage"), object: nil)
      
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
       
        
    }
    
    
}


