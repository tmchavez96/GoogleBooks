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
    
    var books:[Book] = [] {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setup()
    }
    
    func setup(){
        tableView.tableFooterView = UIView(frame: .zero)
        books = BookManager.shared.load()
    }

}

extension FavoritesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! FavoritesCell
        let cellBook = books[indexPath.row]
        if let img =  cellBook.details.image{
            httpHandler.shared.getImage(img.thumbnail) { result in
                cell.listImage.image = result
            }
        }
        cell.listTitle.text = cellBook.details.title
        return cell
    }
    
    
}

extension FavoritesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellBook = books[indexPath.row]
        
        let mapVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        mapVC.curBook = cellBook
        
        navigationController?.view.backgroundColor = .white //remove black flicker on top right
        navigationController?.pushViewController(mapVC, animated: true) //push onto the stack
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cellBook = books[indexPath.row]
            BookManager.shared.remove(cellBook)
            books.remove(at: indexPath.row)
        }
    }
}
