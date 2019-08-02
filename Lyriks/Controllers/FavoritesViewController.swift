//
//  FavoritesViewController.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 01/08/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
 var favoritesCollection = MainCollectionView(data: [])
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewCoding()
        
        CoreDataAPI.fetch()
        favoritesCollection.data = favoritesCollection.convertToModel(movie: CoreDataAPI.favorites)
        favoritesCollection.didSelect = {[weak self](model) in
            guard let movie = model.getMovie() else{
                return
            }
            self?.goToDetail(movie:movie, image: model.image )
            
        }

        // Do any additional setup after loading the view.
    }
    func goToDetail(movie:Movie,image:UIImage?){
        let detail = DetailViewController(movie: movie,image: image)
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(detail, animated: false)
    }
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FavoritesViewController:ViewCoding{
    func buildViewHierarchy() {
        self.view.addSubview(favoritesCollection)
    }
    
    func setUpConstraints() {
        favoritesCollection.fillSuperview()
    }
    
    func additionalConfigs() {
        self.view.backgroundColor = Color.gray
    }
    
    
}
