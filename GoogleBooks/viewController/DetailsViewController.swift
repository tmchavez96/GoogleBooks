//
//  DetailsViewController.swift
//  GoogleBooks
//
//  Created by Taylor Chavez on 2/9/20.
//  Copyright © 2020 Taylor Chavez. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var detailsImage: UIImageView!
    @IBOutlet weak var detailsTitle: UILabel!
    @IBOutlet weak var detailsAuthor: UILabel!
    @IBOutlet weak var detailsPageCount: UILabel!
    @IBOutlet weak var detailsRating: UILabel!
    @IBOutlet weak var detailsDesc: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
     var curBook: Book!
    
    var isFavorite: Bool = false {
        didSet{
            setup()
        }
    }
    
    @IBAction func favoriteToggled(_ sender: Any) {
        if(!isFavorite){
            BookManager.shared.saveBook(curBook)
            favoriteButton.setTitle("Remove from favorites", for: .normal)
        }else{
            BookManager.shared.remove(curBook)
            favoriteButton.setTitle("Add to favorites", for: .normal)
        }
        isFavorite = !isFavorite
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFavorites()
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkFavorites()
        setup()
    }
    
    
    func setup(){
        if let img = curBook.details.image{
            httpHandler.shared.getImage(img.thumbnail) { [weak self] result in
                if let image:UIImage = result{
                    self?.detailsImage.image = image
                }
            }
        }
        detailsTitle.text = curBook.details.title
        detailsAuthor.text = curBook.details.authors[0]
        detailsPageCount.text = String(curBook.details.pageCount ?? 0)
        detailsRating.text = String(curBook.details.rating ?? 0.0)
        detailsDesc.text = curBook.details.desc
        if(isFavorite){
            favoriteButton.setTitle("Remove from favorites", for: .normal)
        }else{
            favoriteButton.setTitle("Add to favorites", for: .normal)
        }
    }
    
    func checkFavorites(){
        if(BookManager.shared.checkForBook(curBook)){
            isFavorite = true
        }else{
            isFavorite = false
        }
    }
    
}
