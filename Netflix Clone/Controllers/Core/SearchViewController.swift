//
//  TopSearchViewController.swift
//  Netflix Clone
//
//  Created by mac on 24/10/22.
//

import UIKit
import SDWebImage



class SearchViewController: UIViewController, UITableViewDelegate {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    var discoverTitles = [Movie]()
    
    let searchContorller : UISearchController = {
        let controller = UISearchController(searchResultsController: SearchresultViewController())
        controller.searchBar.placeholder    = "Search..."
        controller.searchBar.searchBarStyle = .prominent
        controller.searchBar.tintColor      = .label
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Search"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        searchContorller.searchResultsUpdater = self
        navigationItem.searchController = searchContorller
        
        
        configureTableView()
        fetchDiscoverData()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate   = self
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func fetchDiscoverData() {
        
        APICaller.shared.getDiscoverMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let titles):
                self.discoverTitles = titles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
        
    }
    
    
}

extension SearchViewController: UITableViewDataSource, UITabBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoverTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UpcomingTableViewCell
        cell?.txtLable.text  = discoverTitles[indexPath.row].originalTitle
        guard let modal = discoverTitles[indexPath.row].posterPath else { return UITableViewCell() }
        
        cell?.configure(with: modal)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !(query.trimmingCharacters(in: .whitespaces).isEmpty),
              query.count >= 3,
        let resultController = searchController.searchResultsController as? SearchresultViewController else { return }
        resultController.delegate = self
        APICaller.shared.search(with: query) { result in
            
            switch result {
                
            case .success(let titles):
                resultController.titles = titles
                DispatchQueue.main.async {
                    resultController.searchCollectionView.reloadData()
                }
                
            case .failure(_):
                break
            }
        }
                
                
    }
}

extension SearchViewController: SearchResulViewControllerDelegate {
    func searchResulViewControllerDidTapItem(modal: PreviewViewModal) {
        DispatchQueue.main.async {
            let vc = VideoPreviewViewController()
            vc.configure(with: modal)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
