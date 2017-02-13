//
//  PersonCollectionViewCell.swift
//  PeopleRate
//
//  Created by Javier Loucim on 2/11/17.
//  Copyright © 2017 Javier Loucim. All rights reserved.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell, NibLoadable {
    
    struct Distances {
        static var normal:CGFloat = 0
        static var entering:CGFloat = -126
        static var leaving:CGFloat = 126
    }
    
    enum CellDirection {
        case entering
        case leaving
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var labelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var starsView: CosmosView!
    @IBOutlet weak var imageContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        starsView.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        
    }

    func animateWithPercentage(percentage: CGFloat, direction:CellDirection) {
        
        var duration = 0.3
        
        
        var offset:CGFloat = 0.0
        
        switch direction {
            case .entering:
                offset = Distances.entering * (1 - percentage)
            case .leaving:
                offset = Distances.leaving * (1 - percentage)
        }
        if percentage == 1 {
            duration = 0.6
            offset = Distances.normal
            UIView.animate(withDuration: 0.4, animations: {
                self.starsView.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.starsView.alpha = 0
            })
        }

        
        self.layoutIfNeeded()
        UIView.animate(withDuration: duration, animations: {
            self.profileImageView.alpha = percentage
            self.nameLabel.alpha = percentage
        })
        
        UIView.animate(withDuration: 0.3, animations: {
            self.labelLeadingConstraint.constant = offset
            self.layoutIfNeeded()
        })
    }
}
