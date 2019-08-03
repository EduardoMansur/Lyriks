//
//  FilterView.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 03/08/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit

class FilterView:UIView{
    let nameView:UITextField = {
        let view = UITextField()
        view.font = UIFont(name: "Silentina Film", size: 15)
        view.textColor = Color.scarlet
        view.textAlignment = .center
        view.attributedPlaceholder = NSAttributedString(string: "Movie name", attributes: Typography.description(Color.scarlet.withAlphaComponent(0.5)).attributes())
        return view
    }()
    let nameLabel:UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "Name:", attributes: Typography.description(Color.black).attributes())
        return view
    }()
    let genrePicker:SimplePicker = {
        let picker = SimplePicker(data: MovieAPI.retrieveGenreNames())
        picker.tintColor = Color.scarlet
        return picker
    }()
    let genreLabel:UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "Genre:", attributes: Typography.description(Color.black).attributes())
        return view
    }()
    let yearPicker:SimplePicker = {
        let df = DateFormatter()
        let currentyear = Calendar.current.component(.year, from: Date())
        let picker = SimplePicker(data: df.years(1896...currentyear))
        picker.tintColor = Color.scarlet
        return picker
    }()
    let yearLabel:UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "Released:", attributes: Typography.description(Color.black).attributes())
        return view
    }()
    
    let searchButton:UIButton = {
        let button = UIButton()
        button.setAttributedTitle( NSAttributedString(string: "Find", attributes: Typography.description(Color.scarlet).attributes()), for: .normal)
        button.setAttributedTitle( NSAttributedString(string: "Search", attributes: Typography.description(Color.scarlet).attributes()), for: .selected)
        return button
    }()
   
    let background:UIImageView = {
        let view = UIImageView()
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewCoding()
    }
    convenience init(){
        self.init(frame:CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func hide(){
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            guard let self = self else{
                return
            }
            let offSet:CGFloat = 20
            self.transform = CGAffineTransform(translationX: 0, y: -self.bounds.size.height + self.searchButton.bounds.height + offSet + self.safeAreaInsets.top)
        }, completion: { (sucess) in
            if(sucess){
                self.searchButton.isSelected = !self.searchButton.isSelected
            }
            
        })
    }
    func show(){
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            guard let self = self else{
                return
            }
            self.transform = CGAffineTransform.identity
            }, completion: { (sucess) in
                if(sucess){
                    self.searchButton.isSelected = !self.searchButton.isSelected
                }
                
        })
    }
    
    
    
}

extension FilterView:ViewCoding{
    func buildViewHierarchy() {
        self.addSubview(background)
        self.addSubview(nameLabel)
        self.addSubview(nameView)
        self.addSubview(yearPicker)
        self.addSubview(yearLabel)
        self.addSubview(genrePicker)
        self.addSubview(genreLabel)
        self.addSubview(searchButton)
        
    }
    
    func setUpConstraints() {
        background.fillSuperview()
        
        nameView.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: nameLabel.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        nameLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        nameLabel.centerYAnchor.constraint(equalTo: nameView.centerYAnchor).isActive = true
        
        yearPicker.anchor(top: nameLabel.bottomAnchor, leading: yearLabel.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, size: CGSize(width: 0, height: 80))
        yearLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        yearLabel.centerYAnchor.constraint(equalTo: yearPicker.centerYAnchor).isActive = true
        
        genrePicker.anchor(top: yearPicker.bottomAnchor, leading: genreLabel.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, size: CGSize(width: 0, height: 80))
        genreLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        genreLabel.centerYAnchor.constraint(equalTo: genrePicker.centerYAnchor).isActive = true
        
       
        searchButton.anchor(top: nil, leading: nil, bottom: self.bottomAnchor, trailing: nil,padding: UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0))
         searchButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
    
    func additionalConfigs() {
        background.image = UIImage(named: "old_paper")
    }
    
    
}
