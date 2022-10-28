//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by mac on 24/10/22.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    var titles = [TitleItem]()
    
    let downloadTableView: UITableView = {
      let tableView = UITableView()
        tableView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(downloadTableView)
        downloadTableView.delegate = self
        downloadTableView.dataSource = self
        
        fetchLocalStoargeData()
    }
    
    override func viewDidLayoutSubviews() {
        downloadTableView.frame = view.bounds
    }
    
    private func fetchLocalStoargeData() {
        DataPersistantManager.shared.fetchingTitlesDataBase { result in
            switch result {
            case .success(let titles):
                DispatchQueue.main.async {
                    self.titles = titles
                    self.downloadTableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UpcomingTableViewCell
        cell?.txtLable.text = titles[indexPath.row].originalTitle
        guard let modal = titles[indexPath.row].postarPath else { return UITableViewCell() }
        cell?.configure(with: modal)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}
