//
//  ViewController.swift
//  GoogleBooks
//
//  Created by Taylor Chavez on 2/8/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var CollectionView: UICollectionView!
    
    var Books:[Book] = [] {
        didSet{
            DispatchQueue.main.async {
                self.CollectionView.reloadData()
            }
        }
    }
    var firstLoad = true
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    func setup(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchBar.delegate = self as UISearchBarDelegate
        reloadBooks("Harry Potter")
    }
    
    func reloadBooks(_ search: String){
        httpHandler.shared.searchFor(search) {
            [weak self] result in
            self?.Books = result
            print("found \(result.count) books")
            self?.firstLoad = false
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //link sanitization
        guard let search = searchBar.text else {
            return
        }
        reloadBooks(search)
    }
    
    
}

extension SearchViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(Books.count == 0 && !firstLoad){
            let mapVC = storyboard?.instantiateViewController(withIdentifier: "NoResults") as! NoResults
            navigationController?.view.backgroundColor = .white //remove black flicker on top right
            navigationController?.pushViewController(mapVC, animated: true)
            
        }
        return Books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookSearchCell", for: indexPath) as! BookSearchCell
        let cellBook = Books[indexPath.row]
        cell.CellTitle.text = cellBook.details.title
        //cell.CellTitle.text = "ha"
        if let img = cellBook.details.image{
            httpHandler.shared.getImage(img.thumbnail) { result in
                if let image:UIImage = result{
                    cell.CellImage.image = image
                }
            }
        }
        return cell
    }
    
    
}

extension SearchViewController: UICollectionViewDelegate{
    
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    //handles size of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 300)
    }
    
    //handles touch events
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mapVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        mapVC.curBook = Books[indexPath.row]
        
        navigationController?.view.backgroundColor = .white //remove black flicker on top right
        navigationController?.pushViewController(mapVC, animated: true) //push onto the stack
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
    }
    
}
