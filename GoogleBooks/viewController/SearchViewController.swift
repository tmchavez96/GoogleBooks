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
    var viewModel = BookViewModel(isMock: false)
   
    var firstLoad = true
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchBar.delegate = self as UISearchBarDelegate
        //reloadBooks("Harry Potter")
        viewModel.searchBooks("oprah")
    }
    
//    func reloadBooks(_ search: String){
//        httpHandler.shared.searchFor(search) {
//            [weak self] result in
//            self?.Books = result
//            print("found \(result.count) books")
//            //move firstLoad to protocol extension
//            self?.firstLoad = false
//        }
//    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //link sanitization
        guard let search = searchBar.text else {
            return
        }
        //reloadBooks(search)
        viewModel.searchBooks(search)
    }
    
    
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(viewModel.getSearchCount() == 0 && !firstLoad) {
            let noresVC = storyboard?.instantiateViewController(withIdentifier: "NoResults") as! NoResults
            navigationController?.view.backgroundColor = .white //remove black flicker on top right
            navigationController?.pushViewController(noresVC, animated: true)
        }
        firstLoad = false
        return viewModel.getSearchCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookSearchCell", for: indexPath) as! BookSearchCell
        let cellBook = viewModel.getSearchBookFromIndex(indexPath.row)
        cell.CellTitle.text = cellBook?.details.title
        if let img = cellBook?.details.image {
            httpHandler.shared.getImage(img.thumbnail) { result in
                if let image: UIImage = result {
                    cell.CellImage.image = image
                }
            }
        }
        cell.layer.cornerRadius = 20.0
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor =  CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        return cell
    }
    
    
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    //handles size of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 300)
    }
    
    //handles touch events
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        guard let currentBook = viewModel.getSearchBookFromIndex(indexPath.row) else { return }
        detailVC.curBook = currentBook
        detailVC.viewModel = viewModel
        navigationController?.view.backgroundColor = .white //remove black flicker on top right
        navigationController?.pushViewController(detailVC, animated: true) //push onto the stack
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }

    
}


extension SearchViewController: bookSearcher {
    func updateView() {
        DispatchQueue.main.async {
            self.CollectionView.reloadData()
        }
    }
}
