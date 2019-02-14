//
//  FeedViewController.swift
//  XKCD
//
//  Created by Erick Manrique on 2/9/19.
//  Copyright © 2019 homeapps. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellId = String(describing: FeedViewControllerCell.self)
    let viewModel = FeedViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupCollectionView()
        setupNavigationBar()
        bindViewModel()
        viewModel.requestData()
    }
    
    deinit {
        print("de alloc \(String(describing: FeedViewControllerCell.self))")
    }
    
    func setupNavigationBar() {
        title = "XKCD"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 22)]
        
        let doneItem = UIBarButtonItem(title: "❤️", style: .done, target: self, action: nil)
        
        navigationController?.navigationBar.barTintColor = .black
        
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 9)
        
        button.addTarget(self, action:#selector(self.done(sender:)), for: UIControl.Event.touchDragInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        
        navigationItem.rightBarButtonItems = [barButton,doneItem]
    }
    
    func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        collectionView.register(UINib(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
        
    }
    
    func bindViewModel() {
        viewModel.finishedRetrievingComic = { [unowned self] in
            let numOfFavoriteComics = self.viewModel.favoriteComicIds.count
            let rightMostButton = self.navigationItem.rightBarButtonItems?[0]
            let button = rightMostButton?.customView as! UIButton
            button.setTitle("\(numOfFavoriteComics)", for: .normal)
            self.collectionView.reloadData()
        }
    }
    
    @objc func done(sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: FavoriteViewController.self)) as? FavoriteViewController
        self.navigationController?.pushViewController(vc!, animated: true)
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

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.comics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedViewControllerCell
        let comic = viewModel.comics[indexPath.row]
        cell.viewModel.comic = comic
        if let comicId = comic.num {
            cell.viewModel.isFavorited = viewModel.favoriteComicIds.contains("\(comicId)")
        }
        cell.delegate = self
        
        cell.bindViewModel()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let count = viewModel.comics.count - 1

        if count == indexPath.row {
            let comicCount = viewModel.comics.count
            viewModel.getComic(for: comicCount)
        }

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension FeedViewController: FeedViewControllerCellDelegate {
    func favoriteComic(isFavorite: Bool, cell: FeedViewControllerCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        viewModel.changeFavoriteComicStatus(to: isFavorite, at: indexPath.row)
    }
}
