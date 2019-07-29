//
//  MainCollectionView.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 28/07/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit

class MainCollectionView: UICollectionView {
    var didSelect:(()->Void)?
    var data:[CollectionCellViewModel]{ didSet{
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    init(data:[CollectionCellViewModel]) {
        self.data = data
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: CGRect.zero
            , collectionViewLayout:layout )
        self.delegate = self
        self.dataSource = self
        self.register(MainMovieCollectionViewCell.self, forCellWithReuseIdentifier:MainMovieCollectionViewCell.reuseIdentifier )
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
 
    
}

extension MainCollectionView:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: review
        self.didSelect?()
    }
}
extension MainCollectionView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: MainMovieCollectionViewCell.reuseIdentifier, for: indexPath) as? MainMovieCollectionViewCell else{
            return MainMovieCollectionViewCell()
        }
        cell.setUpCell(movie: data[indexPath.item])

        return cell
    }
   
    
    
}
extension MainCollectionView:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)

        let point = CGPoint(x: size.width/2, y:size.height/2 )
        
//       collectionView.indexPathForItem(at: <#T##CGPoint#>)
//        if indexPath == centerIndex{
//            return CGSize(width: size.width*0.8, height: size.height*0.8)
//        }
        return CGSize(width: size.width*0.7, height: size.height*0.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //This takes half os the diference between collection width and item width so the first cell stays on center.
        let offset:CGFloat = (collectionView.bounds.width)*0.15
        return UIEdgeInsets(top: 0, left: offset, bottom: 0, right: 0)
    }
   
   

}

