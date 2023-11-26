//
//  ViewController.swift
//  Traker
//
//  Created by Андрей Чупрыненко on 24.11.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var plusTask: UIImageView {
        let image = UIImage(named: "PlusTask")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    var dateLabel: UILabel {
        let label = UILabel()
        label.text = "26.11.23"
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    var headline: UILabel {
        let label = UILabel()
        label.text = "Трекеры"
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
//    var search: UISearchBar {
//        search.searchBar.placeholder = "Поиск"
//    }
    
    var mainImage: UIImageView {
        let image = UIImage(named: "MainImage")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    var mainMassege: UILabel {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Blue")
    }


}

