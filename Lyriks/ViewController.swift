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
    lazy var detailView = DetailView(frame: self.view.frame)
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewCoding()

        movieApi.discoverPopular { (moviesArray) in
            self.mainCollection.data =  moviesArray.results
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.fire), name: NSNotification.Name(rawValue: "FetchImage"), object: nil)
        mainCollection.didSelect = {[weak self](model) in
            self?.detailView.updateModel(movie: model)
            self?.detailView.show(animated: true)
           
        }


      
    }

    
    @objc func fire()
    {
        mainCollection.reloadData()
    }
//    func convertToModel(movie:[Movie]) -> [CollectionCellViewModel]{
//        var modelArray:[CollectionCellViewModel] = []
//        movie.forEach { (movie) in
//            modelArray.append(CollectionCellViewModel(movie: movie))
//        }
//        return modelArray
//    }



}
extension ViewController:ViewCoding{
    func buildViewHierarchy() {
      
        self.view.addSubview(mainCollection)
       self.view.addSubview(detailView)
        
    }
    
    func setUpConstraints() {
        mainCollection.fillSuperview()
     

    }
    
    func additionalConfigs() {

      self.view.backgroundColor = Color.gray
    }

    
}



