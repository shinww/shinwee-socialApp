//
//  CircleView.swift
//  socialApp
//
//  Created by shinwee on 2/7/17.
//  Copyright © 2017 shinwee. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    
    override func layoutSubviews() {
           layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
}
