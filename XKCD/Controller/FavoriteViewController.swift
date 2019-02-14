//
//  FavoriteViewController.swift
//  XKCD
//
//  Created by Erick Manrique on 2/14/19.
//  Copyright © 2019 homeapps. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellId = String(describing: FeedViewControllerCell.self)
    let cellIdEmpty = String(describing: FavoriteViewControllerEmptyCell.self)
    let viewModel = FavoriteViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationBar()
        setupCollectionView()
        bindViewModel()
        viewModel.getFavoriteComics()
    }
    
    func setupNavigationBar() {
        title = "XKCD"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 22)]
        
        let doneItem = UIBarButtonItem(title: "❤️", style: .done, target: self, action: nil)
        
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 9)
        
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        
        navigationItem.rightBarButtonItems = [barButton,doneItem]
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
        collectionView.register(UINib(nibName: cellIdEmpty, bundle: nil), forCellWithReuseIdentifier: cellIdEmpty)

    }
    
    func bindViewModel() {
        viewModel.finishedRetrievingComics = { [unowned self] in
            let numOfFavoriteComics = self.viewModel.comics.count
            let rightMostButton = self.navigationItem.rightBarButtonItems?[0]
            let button = rightMostButton?.customView as! UIButton
            button.setTitle("\(numOfFavoriteComics)", for: .normal)
            self.collectionView.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.comics.count == 0 {
            return 1
        } else {
            return viewModel.comics.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if viewModel.comics.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdEmpty, for: indexPath) as! FavoriteViewControllerEmptyCell
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedViewControllerCell
            
            let comic = viewModel.comics[indexPath.row]
            cell.viewModel.comic = comic
            cell.viewModel.isFavorited = true
            cell.bindViewModel()
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
}
