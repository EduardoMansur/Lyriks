//
//  MainCollectionView.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 28/07/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit

class MainCollectionView: UICollectionView {
    var didSelect:((Movie)->Void)?
    var data:[Movie]{ didSet{
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    init(data:[Movie]) {
        self.data = data
        let layout = MainCollectionLayout()//UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: MainMovieCollectionViewCell.cellWidth, height: MainMovieCollectionViewCell.cellHeight)
        layout.scrollDirection = .horizontal
        super.init(frame: CGRect.zero
            , collectionViewLayout:layout )
        self.delegate = self
        self.dataSource = self
        self.register(MainMovieCollectionViewCell.self, forCellWithReuseIdentifier:MainMovieCollectionViewCell.reuseIdentifier )
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
 
    
}


extension MainCollectionView:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: review
        self.didSelect?(data[indexPath.item])
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
        cell.setUpCell(movie: CollectionCellViewModel(movie: data[indexPath.item]))
        
        return cell
    }


  
   
    
    
}

