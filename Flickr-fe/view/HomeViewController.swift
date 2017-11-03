//
//  HomeViewController.swift
//  Flickr-fe
//
//  Created by ryu takahashi on 2017/11/02.
//  Copyright © 2017 ryu. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices

class HomeViewController: UIViewController {
    
    var cv: UICollectionView!
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
        Service.shared.getRecentPhotos { (success, result) in
            if success {
                self.photos = Photo.createFromJsons(dics: result)
                self.cv.reloadData()
            }
        }
    }
}

// MARK: - UISearchBar

extension HomeViewController: UISearchBarDelegate {
    
    func setupSearchBar() {
        let sb = UISearchBar()
        sb.sizeToFit()
        sb.delegate = self
        navigationItem.titleView = sb
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        Service.shared.searchPhotos(searchText) { (success, result) in
            if success {
                self.photos = Photo.createFromJsons(dics: result)
                self.cv.reloadData()
            }
        }
    }
}

// MARK: - UICollectionView

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func setupCollectionView() {
        // Collection View Layout
        let space = 5.0 as CGFloat
        let cvLayout = UICollectionViewFlowLayout()
        cvLayout.scrollDirection = .vertical
        cvLayout.minimumLineSpacing = space
        cvLayout.minimumInteritemSpacing = space / 2
        cvLayout.sectionInset = UIEdgeInsetsMake(space, space, space, space)
        cvLayout.itemSize = CGSize(
            width: (view.frame.size.width - space * 4) / 3,
            height: (view.frame.size.width - space * 4) / 3)
        
        // Collection View
        cv = UICollectionView(frame:CGRect(x: 0, y: 0,
                                           width: view.frame.size.width,
                                           height: view.frame.size.height),
                              collectionViewLayout: cvLayout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.register(FlickerCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(cv)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FlickerCell else { return UICollectionViewCell() }
        cell.setup(photos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sheet = UIAlertController(
            title: "Open with..",
            message: nil,
            preferredStyle: .actionSheet
        )
        sheet.addAction(UIAlertAction(title: "Map", style: .default) {action in
            let mapVc = MapViewController()
            mapVc.photo = self.photos[indexPath.row]
            self.navigationController?.pushViewController(mapVc, animated: true)
        })
        sheet.addAction(UIAlertAction(title: "Web", style: .default) {action in
            if let url = URL(string: self.photos[indexPath.row].url_o) {
                self.navigationController?.present(SFSafariViewController(url: url), animated: true, completion: nil)
            }
        })
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel) {action in})
        present(sheet, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewCell

class FlickerCell: UICollectionViewCell {
    var imageView = UIImageView()
    var overlay = UIView()
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initViews()
    }
    
    private func initViews() {
        backgroundColor = .darkGray
        addSubview(imageView)
        addSubview(overlay)
        addSubview(label)
    }
    
    override func draw(_ rect: CGRect) {
        imageView.frame = rect
        overlay.frame = rect
        label.frame = rect
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
    }
    
    func setup(_ photo: Photo) {
        if let url = URL(string: photo.url_o) {
            imageView.sd_setImage(with: url, completed: nil)
        }
        label.text = photo.title
    }
}
