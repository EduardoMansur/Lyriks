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
        refreshData()

        NotificationCenter.default.addObserver(self, selector: #selector(self.updateImage), name: NSNotification.Name(rawValue: "FetchImage"), object: nil)
        mainCollection.didSelect = {[weak self](model) in
            self?.goToDetail(movie:model.getMovie())
           
        }
        mainCollection.paging = {[weak self] in
            
            self?.newPage()
        }

    }
    func newPage(){
        mainCollection.pageCount+=1
        MovieAPI.movieRequest(mode:Request.popular(mainCollection.pageCount),sort:Sort.desc(.voteAverage)){
            [weak self](request) in
            guard let self = self else{
                return
            }
            for movie in request{
                self.mainCollection.data.append(CollectionCellViewModel(movie: movie))
            }
            DispatchQueue.main.async {
                self.mainCollection.reloadData()
                
            }
            self.mainCollection.canRefresh = true
            
            
        }
        
    }
    func refreshData(){
        MovieAPI.movieRequest(mode:Request.popular(mainCollection.pageCount),sort:Sort.desc(.voteAverage)){
            [weak self](movies) in
            guard let self = self else{
                return
            }
            self.mainCollection.data = self.mainCollection.convertToModel(movie:movies)
            
        }
    }
    func goToDetail(movie:Movie){
        let detail = DetailViewController(movie: movie)
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        if let navController = self.navigationController {
            navController.view.layer.add(transition, forKey: kCATransition)
            navController.pushViewController(detail, animated: false)
        }
    }

    
    @objc func updateImage()
    {
        mainCollection.refreshImages()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
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



