//
//  MainMovieCollectionViewCell.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 28/07/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit
@IBDesignable

class MainMovieCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MainCollectionCell"
    //@IBOutlet weak var posterImage: UIImageView!
    let posterImage: UIImageView = {
        let view = UIImageView(image: nil)
        view.contentMode = UIView.ContentMode.scaleAspectFit
        return view
    }()
        
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewCoding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpCell(movie:CollectionCellViewModel){
        //TODO: Validate
        self.posterImage.image = movie.image
    }

    

}
extension MainMovieCollectionViewCell:ViewCoding{
    func buildViewHierarchy() {
        self.contentView.addSubview(posterImage)
    }

    func setUpConstraints() {
       posterImage.fillSuperview()
    }

    func additionalConfigs() {
        //self.posterImage.backgroundColor = UIColor.red
    }
    


}
