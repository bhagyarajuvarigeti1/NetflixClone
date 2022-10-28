//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by mac on 24/10/22.
//

import UIKit

enum sections: Int {
    case TrendingMovies = 0
    case TrendingTv     = 1
    case Popular        = 2
    case Upcoming       = 3
    case TopRated       = 4
}

class HomeViewController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .grouped)

    let sectionTitles: [String] = ["Trending Movies", "Trending TV","Popular", "Upcoming Movies", "Top rated"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        configureNavBar()
        
    }
    
    private func configureNavBar() {
        let image = UIImage(named: "Netflix-logo-on-transparent-background-PNG.png")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        configureTableView()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 10, y: 5, width: view.bounds.width - 20, height: view.bounds.height)
        
        tableView.tableHeaderView = HeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height/2))
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
        cell.deleget = self
        switch indexPath.section {
        case sections.TrendingMovies.rawValue:
            APICaller.shared.fetchTrendingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        case sections.TrendingTv.rawValue:
            APICaller.shared.fetchTrendingTvs { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        case sections.Popular.rawValue:
            APICaller.shared.fetchPopular { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
            
        case sections.Upcoming.rawValue:
            APICaller.shared.fetchUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        case sections.TopRated.rawValue:
            APICaller.shared.fetchTopRated { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
            
        default:
            return UITableViewCell()
        }
        cell.backgroundColor = .red
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font      = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame     = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .label
        header.textLabel?.text      = header.textLabel?.text?.captilizedFirstLetter()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionviewTableViewDidTapCell(_ cell: CollectionViewTableViewCell, viewModal: PreviewViewModal) {
        
        DispatchQueue.main.async {[weak self] in
            let vc = VideoPreviewViewController()
            vc.configure(with: viewModal)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
