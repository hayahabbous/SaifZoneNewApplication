//
//  ourFacilitiesView.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 6/7/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import EmptyDataSet_Swift
class ourFacilitiesView: UIView {
    
    
    var viewController: loginPageViewController!
    
    
    @IBOutlet var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(UINib(nibName: "informativeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "informativeCollectionViewCell")
        
        //notificationsCollectionView.register(UINib(nibName: "cn1", bundle: nil), forCellWithReuseIdentifier: "notiCell11")
        
        
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical  // .horizontal
        }
        //collectionView.isPagingEnabled = true
        collectionView.reloadData()
        collectionView.setNeedsLayout()
    }
}
extension ourFacilitiesView: UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  ,EmptyDataSetDelegate , EmptyDataSetSource  {
    
    //MARK: - CollectionView
    
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "No Items")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

       
        return 4
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "informativeCollectionViewCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! informativeCollectionViewCell
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if cell.reuseIdentifier == "informativeCollectionViewCell" {
            let cell = cell as! informativeCollectionViewCell
            
           
            switch indexPath.row {
            case 0:
                cell.imageView.image = UIImage(named: "info1")
                cell.titleLabel.text = "SAIF offices"
                cell.descLabel.text = "SAIF ZONE offers a wide range of offices to cater to the nature of your business and its varying demands."
                
            case 1:
                cell.imageView.image = UIImage(named: "info2")
                cell.titleLabel.text = "Warehouses"
                cell.descLabel.text = "All our warehouses are purposefully built to fuel your business."
                
            case 2:
                cell.imageView.image = UIImage(named: "info3")
                cell.titleLabel.text = "Plot of land"
                cell.descLabel.text = "Choose from variety of available plots varying from 2,500 sqm and above for custom-build warehouses/ factories."
                
                
            case 3:
                cell.imageView.image = UIImage(named: "info4")
                cell.titleLabel.text = "Jewelry park"
                cell.descLabel.text = "A full-fledged and highly specialized jewelry manufacturing unit."
                
            default:
                print("default")
            }
            
            
           
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        return CGSize(width: self.collectionView.frame.width - 100, height: 300)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        
        return 30.0
    }
    
    
}
