//
//  aboutUsView.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 6/7/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import EmptyDataSet_Swift

class aboutUsView: UIView {
    
    var viewController: loginPageViewController!
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(UINib(nibName: "aboutUsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "aboutUsCollectionCell")
        
        //notificationsCollectionView.register(UINib(nibName: "cn1", bundle: nil), forCellWithReuseIdentifier: "notiCell11")
        
        
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical  // .horizontal
        }
        //collectionView.isPagingEnabled = true
        collectionView.reloadData()
        collectionView.setNeedsLayout()
    }
    
    
    
}
extension aboutUsView: UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  ,EmptyDataSetDelegate , EmptyDataSetSource  {
    
    //MARK: - CollectionView
    
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "No Items")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

       
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "aboutUsCollectionCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! aboutUsCollectionCell
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if cell.reuseIdentifier == "aboutUsCollectionCell" {
            let cell = cell as! aboutUsCollectionCell
            
           
            switch indexPath.row {
            case 0:
                cell.imageView.image = UIImage(named: "1hour")
                cell.titleLabel.text = "Quick and Easy Business Set-Up"
                cell.descLabel.text = "Get your business up and running in 1 hour."
                
            case 1:
                cell.imageView.image = UIImage(named: "statergiclocation")
                cell.titleLabel.text = "Unmatched Strategic Location"
                cell.descLabel.text = "Benefit from excellent sea, land and air transport links."
                
            case 2:
                cell.imageView.image = UIImage(named: "callusicon")
                cell.titleLabel.text = "Unparalleled Customer Service"
                cell.descLabel.text = "Get support for all your queries, requests and emergencies instantly. +971 65 5711 11"
                
            default:
                print("")
            }
            
            
           
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        return CGSize(width: self.collectionView.frame.width - 40, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        
        return 30.0
    }
    
    
}
