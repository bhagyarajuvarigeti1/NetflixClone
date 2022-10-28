//
//  SearchresultViewController.swift
//  Netflix Clone
//
//  Created by mac on 27/10/22.
//

import UIKit

protocol SearchResulViewControllerDelegate {
    func searchResulViewControllerDidTapItem( modal: PreviewViewModal)
}

class SearchresultViewController: UIViewController {
    
    var titles = [Movie]()
    var delegate : SearchResulViewControllerDelegate?
    
    let searchCollectionView : UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        let collecitonView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collecitonView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collecitonView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configure()
    }
    
    func configure() {
        view.addSubview(searchCollectionView)
        searchCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchCollectionView.frame = view.bounds
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        
    }
}

extension SearchresultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        let title = titles[indexPath.row]
        
        cell.configure(with: title.posterPath ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let movie = titles[indexPath.row]
        guard let titleName = movie.originalTitle ?? movie.originalName else { return }
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .success(let videoelement):
                self.delegate?.searchResulViewControllerDidTapItem(modal: PreviewViewModal(title: titleName, youtubeView: videoelement, titleOverView: movie.overview ?? "NA"))
                
            case .failure(_):
                print("error")
            }
        }
    }
    
    
}
