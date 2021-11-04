//
//  SearchViewController.swift
//  SpotifyClone
//
//  Created by Ahmad on 13/07/2021.
//

import UIKit
import Kingfisher

class SearchViewController : UIViewController , UISearchBarDelegate , UICollectionViewDelegate , UICollectionViewDataSource   {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var searchResults : SearchResponseModal?
    var collectionViewFlowLayout : UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search for an artist..."
        self.searchBar.searchBarStyle = .minimal
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        let deltaBtwnRefreshAndDateNow = Calendar.current.dateComponents([.second], from: AuthenticationManager.shared.dateTokenRefreshed , to: Date()).second ?? 0
        if deltaBtwnRefreshAndDateNow > AuthenticationManager.shared.tokenExpireDate {
            AuthenticationManager.shared.refreshAccesToken { [weak self] success in
                if success == false {
                    DispatchQueue.main.async {
                        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        self?.navigationController?.pushViewController(loginVC, animated: true)
                    }
                }
            }
        }
        self.navigationItem.hidesSearchBarWhenScrolling = true
        setUpCollectionViewCell()
        setupCollectionItemSize()
        self.hideKeyboard()
    }
    
    func setUpCollectionViewCell(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SearchResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
    }
    
    func setupCollectionItemSize(){
        if collectionViewFlowLayout == nil {
            let width = UIScreen.main.bounds.width * 0.47
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            collectionViewFlowLayout.itemSize = CGSize(width: width , height: 266.0)
            collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionViewFlowLayout.minimumLineSpacing = 10.0
            collectionViewFlowLayout.minimumInteritemSpacing = 0
            collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        }
    }
    
    //MARK: -  Search Btn Clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text , !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        self.searchResults = nil
        ApiManager.shared.searchApi(query: query) { Result in
            DispatchQueue.main.async {
                switch Result {
                case .success(let result):
                    self.searchResults = result
                    self.collectionView.reloadData()
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                }
            }
        }
        view.endEditing(true)
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(SearchViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: -  Search as you type
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchResults = nil
        guard let query = searchBar.text , !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        ApiManager.shared.searchApi(query: query) { Result in
            DispatchQueue.main.async {
                switch Result {
                case .success(let result):
                    self.searchResults = result
                    self.collectionView.reloadData()
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchResults?.artists.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCollectionViewCell", for: indexPath) as! SearchResultCollectionViewCell
        cell.artistImage.kf.setImage(with: URL(string: self.searchResults?.artists.items[indexPath.row].images.first?.url ?? ""))
        cell.artistName.text = self.searchResults?.artists.items[indexPath.row].name
        cell.artistName.numberOfLines = 2
        cell.artistFollowers.text = "\(self.searchResults?.artists.items[indexPath.row].followers.total ?? 0) followers"
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        if self.searchResults?.artists.items[indexPath.row].popularity ?? 0 >= 1 && self.searchResults?.artists.items[indexPath.row].popularity  ?? 0 < 25 {
            cell.star2.image = UIImage(named: "")
            cell.star3.image = UIImage(named: "")
            cell.star4.image = UIImage(named: "")
            cell.star5.image = UIImage(named: "")
        }
        
        if self.searchResults?.artists.items[indexPath.row].popularity ?? 0 >= 25 && self.searchResults?.artists.items[indexPath.row].popularity  ?? 0 < 50 {
            cell.star3.image = UIImage(named: "")
            cell.star4.image = UIImage(named: "")
            cell.star5.image = UIImage(named: "")
        }
        
        if self.searchResults?.artists.items[indexPath.row].popularity ?? 0 >= 50 && self.searchResults?.artists.items[indexPath.row].popularity  ?? 0 < 75 {
            cell.star4.image = UIImage(named: "")
            cell.star5.image = UIImage(named: "")
        }
        
        if self.searchResults?.artists.items[indexPath.row].popularity ?? 0 >= 75 && self.searchResults?.artists.items[indexPath.row].popularity  ?? 0 <= 100 {
            cell.star5.image = UIImage(named: "")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlbumsViewController") as! AlbumsViewController
        albumsViewController.id = self.searchResults?.artists.items[indexPath.row].id ?? ""
        self.navigationController?.pushViewController(albumsViewController, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        view.endEditing(true)
    }
}
