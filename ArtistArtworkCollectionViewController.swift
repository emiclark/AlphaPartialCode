//
//  ArtistArtworkCollectionViewController.swift
//  AlphaANativeApp
//
//  Created by Emiko Clark on 7/6/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import SDWebImage

class ArtistArtworkCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!

    var detailedUser: Artist?
    var isArtist: Bool?
    var collector: Collector?
    var searchManager = SearchManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchManager.artworkDelegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //register nib file
        collectionView.register( UINib(nibName: "ArtCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    // MARK: Collection View Delegates
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isArtist == true {
            // is an artist - show artwork
            if let detailedUser = detailedUser {
                return detailedUser.artistArtworksArray.count
            }
        } else {
            // is collector - show favorites
            if let collector = collector {
                print("numberOfItemsInSection:collector",collector)
                return collector.favoritesArray!.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelect:",(detailedUser?.artistArtworksArray[indexPath.row].id)!)
        print("collectionViewHeight:", self.collectionView.frame.size.height)
        
        let imageDetailVC = ImageDetailViewController()
        imageDetailVC.didComeFromCollectionView = true
        if detailedUser?.profile == "artist" {
            // is an artist
            imageDetailVC.artworkID = detailedUser?.artistArtworksArray[indexPath.row].id
        } else {
            // is a collector
            imageDetailVC.artworkID = collector?.favoritesArray?[indexPath.row].id

        }
       
        self.navigationController?.pushViewController(imageDetailVC, animated: true)
        
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ArtCollectionViewCell
        if isArtist == true {
            // is artist
            let artworkURL = URL(string: Alphaa.baseImageURL + (detailedUser!.artistArtworksArray[indexPath.row].img))
            cell.imageView.contentMode = .scaleToFill
            
            cell.imageView.sd_setImage(with: artworkURL, placeholderImage: #imageLiteral(resourceName: "artworkPlaceholder"))
            cell.textLabel.text = detailedUser!.artistArtworksArray[indexPath.row].title
        } else {
            // is collector
            let artworkURL = URL(string: Alphaa.baseImageURL + (collector?.favoritesArray?[indexPath.row].img)!)
            cell.imageView.contentMode = .scaleToFill
            
            cell.imageView.sd_setImage(with: artworkURL, placeholderImage: #imageLiteral(resourceName: "artworkPlaceholder"))
            // cell.textLabel.text =  "No title"
        }
        return cell
    }

}

// MARK: Extensions

extension ArtistArtworkCollectionViewController: reloadWithArtworkDataDelegate {
    
    func updateUI(withArtworkData artwork: Artwork) {
        // artwork download complete, assign to imageDetailVC.currentArtwork, and push VC
        let imageDetailVC = ImageDetailViewController()
        imageDetailVC.currentArtwork = artwork
        self.navigationController?.pushViewController(imageDetailVC, animated: true)
    }

}
