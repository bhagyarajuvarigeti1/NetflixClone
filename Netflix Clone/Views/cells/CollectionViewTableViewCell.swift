//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by mac on 25/10/22.
//

import UIKit

protocol CollectionViewTableViewCellDelegate {
    func collectionviewTableViewDidTapCell(_ cell: CollectionViewTableViewCell, viewModal: PreviewViewModal)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    private var titles = [Movie]()
    
    var deleget: CollectionViewTableViewCellDelegate?
    
    private var collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCollectionView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCollectionView() {
        contentView.addSubview(collectionView)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    func configure(with titles: [Movie]) {
        self.titles = titles
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func downloadMovie(at indexPath: IndexPath) {
        DataPersistantManager.shared.downloadTitleWith(modal: titles[indexPath.row]) { result in
            switch result {
            case .success():
                print("succuss")
            case .failure(_):
                break
            }
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return titles.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return  UICollectionViewCell() }
        
        guard let modal = titles[indexPath.row].posterPath else { return UICollectionViewCell() }
        
        cell.configure(with: modal)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.originalTitle ?? title.originalName else { return }
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
                
            case .success(let viedeElement):
                let viewModal = PreviewViewModal(title: titleName, youtubeView: viedeElement, titleOverView: title.overview ?? "")
                self.deleget?.collectionviewTableViewDidTapCell(self.self, viewModal: viewModal)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil,
                                                previewProvider: nil) {[weak self] _ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                print("Download Tapped")
                self?.downloadMovie(at: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
}
