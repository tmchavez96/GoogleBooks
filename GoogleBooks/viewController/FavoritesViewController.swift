//
//  FavoritesViewController.swift
//  GoogleBooks
//
//  Created by Taylor Chavez on 2/8/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    var viewModel = BookViewModel(isMock: false)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setup()
    }
    
    func setup() {
        tableView.tableFooterView = UIView(frame: .zero)
        NotificationCenter.default.addObserver(forName: Notification.Name("favoritesUpdated"), object: nil, queue: .main) {
            [weak self] _ in
                   self?.tableView.reloadData()
               }
        viewModel.getFavs()
    }

}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getFavoriteCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! FavoritesCell
        let cellBook = viewModel.getFavBookFromIndex(indexPath.row)
        if let img =  cellBook?.details.image {
            httpHandler.shared.getImage(img.thumbnail) { result in
                cell.listImage.image = result
            }
        }
        cell.listTitle.text = cellBook?.details.title
        return cell
    }
    
    
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cellBook = viewModel.getFavBookFromIndex(indexPath.row) else {return}
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailVC.curBook = cellBook
        detailVC.viewModel = viewModel
        navigationController?.view.backgroundColor = .white //remove black flicker on top right
        navigationController?.pushViewController(detailVC, animated: true) //push onto the stack
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cellBook = viewModel.favBooks[indexPath.row]
            viewModel.delBook(book: cellBook)
        }
    }
}
