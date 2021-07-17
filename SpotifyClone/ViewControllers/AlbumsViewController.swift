//
//  AlbumsViewController.swift
//  SpotifyClone
//
//  Created by Ahmad on 17/07/2021.
//

import UIKit
import Kingfisher
import SafariServices

class AlbumsViewController : UIViewController , UICollectionViewDelegate , UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var albumsResults : AlbumsModal?
    var collectionViewFlowLayout : UICollectionViewFlowLayout!
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Albums"
        setUpCollectionViewCell()
        setupCollectionItemSize()
        ApiManager.shared.getAlbumDataApi(id: id) { Result in
            DispatchQueue.main.async {
                switch Result {
                case.success(let result):
                    self.albumsResults = result
                    self.collectionView.reloadData()
                case .failure(let error):
                    print("Error : \(error.localizedDescription)")
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func setUpCollectionViewCell(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AlbumResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AlbumResultCollectionViewCell")
    }
    
    func setupCollectionItemSize(){
        if collectionViewFlowLayout == nil {
            let width = UIScreen.main.bounds.width * 0.47
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            collectionViewFlowLayout.itemSize = CGSize(width: width , height: 300.0)
            collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionViewFlowLayout.minimumLineSpacing = 10.0
            collectionViewFlowLayout.minimumInteritemSpacing = 0
            collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumsResults?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumResultCollectionViewCell", for: indexPath) as! AlbumResultCollectionViewCell
        cell.albumImage.kf.setImage(with: URL(string: self.albumsResults?.items[indexPath.row].images.first?.url ?? ""))
        cell.albumName.text = self.albumsResults?.items[indexPath.row].name
        var artistsArrayStrings : [String] = []
        for artist in (self.albumsResults?.items[indexPath.row].artists)! {
            artistsArrayStrings.append(artist.name)
        }
        cell.albumArtistLbl.text = artistsArrayStrings.joined(separator: ",")
        cell.albumsTrack.text = "\(self.albumsResults?.items[indexPath.row].total_tracks ?? 0) tracks"
        cell.albumReleaseDateLbl.text = self.albumsResults?.items[indexPath.row].release_date
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.previewOnSpotifyBtnPressed = { _ in
            let safariVC = SFSafariViewController(url: URL(string: (self.albumsResults?.items[indexPath.row].external_urls.spotify)!)!)
            self.present(safariVC, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let safariVC = SFSafariViewController(url: URL(string: (self.albumsResults?.items[indexPath.row].external_urls.spotify)!)!)
        self.present(safariVC, animated: true)
    }
}
