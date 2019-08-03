//
//  DetailViewController.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 01/08/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
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
    let favoriteButton:UIButton = {
        let button = UIButton()
        return button
    }()
    let background:UIImageView = {
        let view = UIImageView()
        return view
    }()
    var image:UIImage?
    
    var detailModel:DetailsViewModel
    override func viewDidLoad() {
        initViewCoding()
        //self.hide(animated: false)
        backButton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
        trailerButton.addTarget(self, action: #selector(self.fireTrailer), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(self.favoriteMovie), for: .touchUpInside)
      
    
    }
    

    init(movie:Movie) {
        self.detailModel = DetailsViewModel(movie: movie)
        super.init(nibName: nil, bundle: nil)
        updateUI()
        MovieAPI.getYoutubeUrl(id: String(movie.id)){
                result,err  in
                
                if err != nil{
                    DispatchQueue.main.async {
                         self.trailerButton.isHidden = true
                    }
                }
        }
        
    }

    func updateUI(){
        self.vote.attributedText = self.detailModel.voteAverage
        self.overview.attributedText = self.detailModel.overview
        self.release.attributedText = self.detailModel.release
        self.favoriteButton.isSelected = CoreDataAPI.isFavorite(id: String(detailModel.id))
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func fireTrailer(){
        MovieAPI.requestYoutube(id: String(detailModel.id))
        
    }
    @objc func favoriteMovie(){
        self.favoriteButton.isSelected = !self.favoriteButton.isSelected
        if(!self.favoriteButton.isSelected){
            CoreDataAPI.delete(id: self.detailModel.id)
        }else{
            let model = detailModel.getModel()
            
            CoreDataAPI.save(movie:model)
        }
        
    }


    @objc func backAction(){
      
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: false)
    }

    func updateDetail(movie:Movie){
        self.detailModel = DetailsViewModel(movie: movie)
    }

}
extension DetailViewController:ViewCoding{
    func buildViewHierarchy() {
        self.view.addSubview(background)
        self.view.addSubview(release)
        self.view.addSubview(overview)
        self.view.addSubview(vote)
        self.view.addSubview(trailerButton)
        self.view.addSubview(backButton)
        self.view.addSubview(favoriteButton)
        
    }
    func setUpConstraints() {
        background.fillSuperview()
        vote.anchor(top: self.view.layoutMarginsGuide.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        release.anchor(top: self.view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        overview.anchor(top: self.vote.bottomAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0))
        trailerButton.anchor(top: overview.bottomAnchor, leading: nil, bottom: nil, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0),size: CGSize(width: 50, height: 20))
         backButton.anchor(top: nil, leading: nil, bottom: self.view.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0),size: CGSize(width: 50, height: 20))
        backButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        favoriteButton.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0),size:CGSize(width: 80, height: 80))

        favoriteButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.bounds.height/5).isActive = true
        favoriteButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    func additionalConfigs() {
        background.image = UIImage(named: "old_paper")
        trailerButton.setAttributedTitle(NSAttributedString(string: "Trailer", attributes: Typography.description(Color.scarlet).attributes()), for: .normal)
        backButton.setAttributedTitle(NSAttributedString(string: "Back", attributes: Typography.description(Color.scarlet).attributes()), for: .normal)
        
        favoriteButton.setImage(UIImage(named: "heart_selected")?.withRenderingMode(.alwaysTemplate), for: .selected)
        favoriteButton.setImage(UIImage(named: "heart_unselected")?.withRenderingMode(.alwaysTemplate), for: .normal)
        favoriteButton.tintColor = Color.scarlet
        
    }
}

