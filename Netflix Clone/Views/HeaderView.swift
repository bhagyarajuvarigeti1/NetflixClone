//
//  HeaderView.swift
//  Netflix Clone
//
//  Created by mac on 25/10/22.
//

import UIKit
import SDWebImage

class HeaderView: UIView {
    
    private let playButton : UIButton = createButton(title: "Play")
    private let downloadButton : UIButton = createButton(title: "Download")
    
    private var headerImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
//        imageView.image = UIImage(named: "NetfilxHeader1")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubview(headerImageView)
        headerImageView.frame = bounds
        addGradient()
        configureButtons()
        configureHeadPoster()
    }
    
    public func cofigure(with modal: String) {
        print(modal)
        guard  let url = URL(string: "https://image.tmdb.org/t/p/w500/\(modal)") else {
            return
        }
        print(modal)
        headerImageView.sd_setImage(with: url)
    }
    
    private func configureHeadPoster() {
        APICaller.shared.fetchTrendingMovies { result in
            switch result {
            case .success(let titles):
                guard let movie = titles.randomElement() else { return }
                self.cofigure(with: movie.posterPath ?? "")
            case .failure(_):
                print("error")
            }
        }
    }
    
    private func configureButtons() {
        addSubview(playButton)
        addSubview(downloadButton)
        
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 100),
            
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    private func addGradient() {
        let gradient    = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
    
    private static func createButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius   = 10
        button.layer.borderColor    = UIColor.white.cgColor
        button.layer.borderWidth    = 1
        button.translatesAutoresizingMaskIntoConstraints  = false
        return button
    }
}
