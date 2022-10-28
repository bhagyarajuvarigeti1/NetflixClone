//
//  UpcomingTableViewCell.swift
//  Netflix Clone
//
//  Created by mac on 27/10/22.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {

    static let identifier = "UpcomingTableViewCell"
    
    let posterImageView: UIImageView = {
        let imageView           = UIImageView()
        imageView.contentMode   = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let txtLable: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "red"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
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
    
    private func configureCell() {
        addSubview(posterImageView)
        addSubview(actionButton)
        addSubview(txtLable)
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
//            posterImageView.heightAnchor.constraint(equalToConstant: 100),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            
            
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            actionButton.widthAnchor.constraint(equalToConstant: 50),
            
            txtLable.centerYAnchor.constraint(equalTo: centerYAnchor),
            txtLable.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: padding),
            txtLable.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -padding),
        ])
    }

}
