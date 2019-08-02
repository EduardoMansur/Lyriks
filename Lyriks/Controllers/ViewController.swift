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
    //lazy var detailView = DetailView(frame: self.view.frame)
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewCoding()
        MovieAPI.movieRequest(path: Request.popular(mainCollection.pageCount).toString())  { [weak self](moviesArray) in
            guard let self = self else{
                return
            }
            self.mainCollection.data = self.mainCollection.convertToModel(movie:moviesArray.results)
            
        }
//        movieApi.discoverPopular { [weak self](moviesArray) in
//            guard let self = self else{
//                return
//            }
//            self.mainCollection.data = self.convertToModel(movie:moviesArray.results)
//            
//        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.fire), name: NSNotification.Name(rawValue: "FetchImage"), object: nil)
        mainCollection.didSelect = {[weak self](model) in
            self?.goToDetail(movie: model.getMovie())
           
        }

    }
    func goToDetail(movie:Movie){
        let detail = DetailViewController(movie: movie)
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(detail, animated: false)
    }

    
    @objc func fire()
    {
        mainCollection.reloadData()
    }
    



}
extension ViewController:ViewCoding{
    func buildViewHierarchy() {
      
        self.view.addSubview(mainCollection)
      // self.view.addSubview(detailView)
        
    }
    
    func setUpConstraints() {
        mainCollection.fillSuperview()
     
     

    }
    
    func additionalConfigs() {

      self.view.backgroundColor = Color.gray
    }

    
}



