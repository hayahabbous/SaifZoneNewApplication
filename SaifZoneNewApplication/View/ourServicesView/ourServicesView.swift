//
//  ourServicesView.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 6/7/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import EmptyDataSet_Swift


class ourServicesView: UIView {
    
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
        
        collectionView.register(UINib(nibName: "ourServiceCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ourServiceCollectionCell")
        
        //notificationsCollectionView.register(UINib(nibName: "cn1", bundle: nil), forCellWithReuseIdentifier: "notiCell11")
        
        
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical  // .horizontal
        }
        //collectionView.isPagingEnabled = true
        collectionView.reloadData()
        collectionView.setNeedsLayout()
    }
}
extension ourServicesView: UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  ,EmptyDataSetDelegate , EmptyDataSetSource  {
    
    //MARK: - CollectionView
    
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "No Items")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

       
        return 6
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "ourServiceCollectionCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ourServiceCollectionCell
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if cell.reuseIdentifier == "ourServiceCollectionCell" {
            let cell = cell as! ourServiceCollectionCell
            
           
            switch indexPath.row {
            case 0:
                cell.imageView.image = UIImage(named: "service1")
                cell.titleLabel.text = "Client & Investor Services"
              
                
            case 1:
                cell.imageView.image = UIImage(named: "service2")
                cell.titleLabel.text = "Visa Services"
             
                
            case 2:
                cell.imageView.image = UIImage(named: "service3")
                cell.titleLabel.text = "Lease, License & Legal Affairs Department"
                
                
            case 3:
                cell.imageView.image = UIImage(named: "service4")
                cell.titleLabel.text = "Sharjah Customs Department"
                
                
            case 4:
                cell.imageView.image = UIImage(named: "service5")
                cell.titleLabel.text = "Banks & Financial Services"
                
               
            case 5:
                cell.imageView.image = UIImage(named: "service6")
                cell.titleLabel.text = "Immigration & Customs Services"
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
