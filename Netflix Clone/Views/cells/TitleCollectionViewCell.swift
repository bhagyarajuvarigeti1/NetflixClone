//
//  TitleCollectionViewCell.swift
//  Netflix Clone
//
//  Created by mac on 26/10/22.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView           = UIImageView()
        imageView.contentMode   = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(posterImageView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with modal: String) {
        guard  let url = URL(string: "https://image.tmdb.org/t/p/w500/\(modal)") else {
            return
        }
        posterImageView.sd_setImage(with: url)
    }
}
