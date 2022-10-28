//
//  SearchTableViewCell.swift
//  Netflix Clone
//
//  Created by mac on 27/10/22.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    let posterImageView: UIImageView  = {
       let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let txtLabel      = UILabel()
    let actionButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
