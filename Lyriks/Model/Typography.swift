//
//  Typography.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 31/07/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit

enum Typography {
    case title(UIColor)

    
    func attributes() ->[NSAttributedString.Key : Any]{
        switch self {
        case .title(let color):
            return [NSAttributedString.Key.font:UIFont(name:"Silentina Movie", size: 15) ?? UIFont.preferredFont(forTextStyle: .title1),NSAttributedString.Key.foregroundColor:color]
     
        }
        
    }
}
