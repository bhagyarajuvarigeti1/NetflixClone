//
//  VideoPreviewViewController.swift
//  Netflix Clone
//
//  Created by mac on 28/10/22.
//

import UIKit
import WebKit

class VideoPreviewViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    private let overViewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    private let webView: WKWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overViewLabel)
        view.addSubview(downloadButton)
        
        configure()
    }
    
    func configure() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            webView.leadingAnchor.constraint(equalTo:  view.leadingAnchor, constant: padding),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -padding),
            webView.heightAnchor.constraint(equalToConstant: 250),
            
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            overViewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            overViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overViewLabel.bottomAnchor, constant: padding),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configure(with modal: PreviewViewModal) {
        titleLabel.text = modal.title
        overViewLabel.text = modal.titleOverView
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(modal.youtubeView.id.videoId)") else { return }
        
        webView.load(URLRequest(url: url))
    }
}
