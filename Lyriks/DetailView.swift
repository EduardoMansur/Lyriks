//
//  DetailViewController.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 01/08/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit

class DetailView: UIView {
    let release:UILabel = {
        let label = UILabel()
        return label
    }()
    let overview:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    let vote:UILabel = {
        let label = UILabel()
        return label
    }()
    let trailerButton:UIButton = {
        let button = UIButton()
        return button
    }()
    let backButton:UIButton = {
        let button = UIButton()
        return button
    }()
    let background:UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    var detailModel = DetailsViewModel(){
        didSet{
            self.vote.attributedText = self.detailModel.voteAverage
            self.overview.attributedText = self.detailModel.overview
            self.release.attributedText = self.detailModel.release
        }
    }
    
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewCoding()
        self.hide(animated: false)
        backButton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
        trailerButton.addTarget(self, action: #selector(self.fireTrailer), for: .touchUpInside)
      
    }
    func updateModel(movie:Movie){
        self.detailModel = DetailsViewModel(movie: movie)
    }
    @objc func fireTrailer(){
        let movieAPI = MovieAPI()
        movieAPI.requestYoutube(id: String(detailModel.id))
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func show(animated:Bool){
        if animated {
            UIView.animate(withDuration: 0.5) {
                self.center = CGPoint(x:self.center.x, y: +self.bounds.height/2)                    
            }
        }else{
            self.center = CGPoint(x:self.center.x, y: +self.bounds.height/2)
        }
        
    }
    @objc func backAction(){
        hide(animated: true)
    }
    
    func hide(animated:Bool){
        if animated {
            UIView.animate(withDuration: 0.5) {
                 self.center = CGPoint(x:self.center.x, y: -self.bounds.height/2)
            }
        }else{
            self.center = CGPoint(x:self.center.x, y: -self.bounds.height/2)
        }
        
    }
    func updateDetail(movie:Movie){
        self.detailModel = DetailsViewModel(movie: movie)
    }

}
extension DetailView:ViewCoding{
    func buildViewHierarchy() {
        self.addSubview(background)
        self.addSubview(release)
        self.addSubview(overview)
        self.addSubview(vote)
        self.addSubview(trailerButton)
        
    }
    func setUpConstraints() {
        background.fillSuperview()
        vote.anchor(top: self.layoutMarginsGuide.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        release.anchor(top: self.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        overview.anchor(top: self.vote.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        trailerButton.anchor(top: overview.bottomAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
    }
    func additionalConfigs() {
//        vote.layer.borderWidth = 1.0
//        vote.layer.borderColor = Color.black.cgColor
//        vote.layer.cornerRadius = 5
//        release.layer.borderWidth = 1.0
//        release.layer.borderColor = Color.black.cgColor
//        release.layer.cornerRadius = 5
//        overview.layer.borderWidth = 1.0
//        overview.layer.borderColor = Color.black.cgColor
//        overview.layer.cornerRadius = 5

        trailerButton.titleLabel?.attributedText = NSAttributedString(string: "Trailer", attributes: Typography.description(Color.black).attributes())
        self.background.image = UIImage(named: "old_paper")
        
    }
}

