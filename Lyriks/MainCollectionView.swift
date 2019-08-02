//
//  MainCollectionView.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 28/07/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit

class MainCollectionView: UICollectionView {
    var didSelect:((CollectionCellViewModel)->Void)?
    var data:[CollectionCellViewModel]{ didSet{
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    private let customLayout:MainCollectionLayout
    var pageCount = 1
    private var canRefresh = true
    init(data:[CollectionCellViewModel]) {
        self.data = data
        let layout = MainCollectionLayout()//UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: MainMovieCollectionViewCell.cellWidth, height: MainMovieCollectionViewCell.cellHeight)
        layout.scrollDirection = .horizontal
        self.customLayout = layout
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
    func newPage(){
        pageCount+=1
        MovieAPI.movieRequest(mode:Request.popular(pageCount),sort:Sort.desc(.voteAverage)){
            [weak self](request) in
            guard let self = self else{
                return
            }
            for movie in request.results{
                self.data.append(CollectionCellViewModel(movie: movie))
            }
            DispatchQueue.main.async {
                self.reloadData()
                self.canRefresh = true
            }
            
            
        }
//
//        MovieAPI.movieRequest(path: Request.popular(pageCount).toString()) { [weak self](request) in
//            guard let self = self else{
//                return
//            }
//            for movie in request.results{
//                self.data.append(CollectionCellViewModel(movie: movie))
//            }
//            DispatchQueue.main.async {
//                 self.reloadData()
//                self.canRefresh = true
//            }
//
//
//        }
        
        
    }
    func convertToModel(movie:[Movie]) -> [CollectionCellViewModel]{
        var modelArray:[CollectionCellViewModel] = []
        movie.forEach { (movie) in
            modelArray.append(CollectionCellViewModel(movie: movie))
        }
        return modelArray
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView.contentOffset.x >= (scrollView.contentSize.width - (MainMovieCollectionViewCell.cellWidth + customLayout.minimumInteritemSpacing)*5) && self.canRefresh){
            self.newPage()
            canRefresh = false
            
        }
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
        cell.setUpCell(movie: data[indexPath.item])
        
        return cell
    }
    
}

