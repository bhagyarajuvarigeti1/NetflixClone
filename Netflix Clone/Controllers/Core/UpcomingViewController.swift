//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by mac on 24/10/22.
//

import UIKit
import WebKit

class UpcomingViewController: UIViewController {
    
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: "UpcomingViewController")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var titles = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureTableView()
        fetchUpcoming()
    }
    
    func fetchUpcoming() {
        APICaller.shared.fetchUpcomingMovies { [weak self] result in
            
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(_): break
                
            }
        }
    }

    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension UpcomingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingViewController", for: indexPath) as? UpcomingTableViewCell
        cell?.txtLable.text = titles[indexPath.row].originalTitle
        guard let modal = titles[indexPath.row].posterPath else { return UITableViewCell() }
        cell?.configure(with: modal)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = titles[indexPath.row]
        guard let titleName = movie.originalTitle ?? movie.originalName else { return }
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .success(let videoelement):
                DispatchQueue.main.async {
                    let vc = VideoPreviewViewController()
                    vc.configure(with: PreviewViewModal(title: titleName, youtubeView: videoelement, titleOverView: movie.overview ?? ""))
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(_):
                print("error")
            }
        }
    }
    
    
    
}

