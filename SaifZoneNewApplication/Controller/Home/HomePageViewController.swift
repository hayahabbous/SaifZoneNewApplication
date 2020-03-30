//
//  HomePageViewController.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/3/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit


class HomePageViewController: UIViewController {
    
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var infoCollectionView: UICollectionView!
    @IBOutlet var circularImageView: UIImageView!
    @IBOutlet var backImageView: UIImageView!
    @IBOutlet var servicesCollectionView: UICollectionView!
    
    @IBOutlet var parentProfileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        circularImageView.layer.cornerRadius = self.circularImageView.frame.height / 2
        
        circularImageView.layer.masksToBounds = true
        backImageView.addCurvedView(imageview: backImageView ,backgroundColor: UIColor(red: 217/255, green: 188/255, blue: 136/255, alpha: 1.0), curveRadius: 30, shadowColor: .lightGray, shadowRadius: 4.0, heightOffset: 0.0)
        
        
        
        //addCurvedNavigationBar(backgroundColor: .brown, curveRadius: 17.0, shadowColor: .lightGray, shadowRadius: 4.0, heightOffset: 0.0)
        //parentProfileImageView.layer.cornerRadius = self.parentProfileImageView.frame.height / 2
        
        //parentProfileImageView.layer.masksToBounds = true
        
        
        //circularImageView.layer.borderColor = UIColor(red: 187/255, green: 156/255, blue: 98/255, alpha: 1.0).cgColor
        
        circularImageView.layer.borderColor = UIColor.white.cgColor
        circularImageView.layer.borderWidth = 8
        
        circularImageView.addCurvedView(imageview: circularImageView ,backgroundColor: UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0), curveRadius: 30, shadowColor: .black, shadowRadius: 4.0, heightOffset: 0.0)
        /*
        circularImageView.layer.borderWidth = 2
        circularImageView.layer.borderColor = UIColor.white.cgColor*/
        
        
        setupCollectionView()
        infoCollectionView.reloadData()
        infoCollectionView.setNeedsLayout()
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    
    func setupCollectionView() {
        infoCollectionView.delegate = self
        infoCollectionView.dataSource = self
        
        infoCollectionView.showsVerticalScrollIndicator = false
        
        infoCollectionView.register(UINib(nibName: "childNotificationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "notiCell")
        
        //notificationsCollectionView.register(UINib(nibName: "cn1", bundle: nil), forCellWithReuseIdentifier: "notiCell11")
        
        
        
        if let layout = infoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal  // .horizontal
        }
        infoCollectionView.isPagingEnabled = true
        infoCollectionView.reloadData()
        infoCollectionView.setNeedsLayout()
        
        
        
        
        servicesCollectionView.delegate = self
        servicesCollectionView.dataSource = self
        
        servicesCollectionView.showsVerticalScrollIndicator = false
        
        servicesCollectionView.register(UINib(nibName: "ServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ServiceCollectionViewCell")
        
        //notificationsCollectionView.register(UINib(nibName: "cn1", bundle: nil), forCellWithReuseIdentifier: "notiCell11")
        
        
        
        if let layout = servicesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal  // .horizontal
        }
        servicesCollectionView.isPagingEnabled = true
        servicesCollectionView.reloadData()
        servicesCollectionView.setNeedsLayout()
    }
    
    func getServices() {
        
    }
    @IBAction func allButtonAction(_ sender: Any) {
    }
}
extension HomePageViewController: UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    //MARK: - CollectionView
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == infoCollectionView {
            return 4
        }
        if collectionView == servicesCollectionView {
            return 15
        }
        return 0

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cellIdentifier = "Cell"
        
        
        
        if collectionView == self.servicesCollectionView  {
                   
            cellIdentifier = "ServiceCollectionViewCell"
                   
                   
            let cell = servicesCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ServiceCollectionViewCell
            
            cell.layoutIfNeeded()
            
            return cell
        }
        if collectionView == self.infoCollectionView  {
            
            cellIdentifier = "notiCell"
            
            
            let cell = infoCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! childNotificationCollectionViewCell
            
           /*
           
            let string = "\(AppConstants.WEB_SERVER_IMAGE_MOCD_URL)\(childItem.child_picture )"
            let url = URL(string: string)
            cell.profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "profile") ?? UIImage())
           
            
            
            switch childItem.status {
            case .NEED_TEST:
                print("")
                cell.backgroundColor = AppConstants.GRAY_COLOR
                cell.titleLabel.text = "\(childItem.firstName)" + " need test".localize
                cell.detailsLabel.text = "Please ensure that your child" + " \(childItem.firstName)" + " helth is fine".localize
                
            case .FINE:
                cell.backgroundColor = AppConstants.GREEN_COLOR
                cell.titleLabel.text = "\(childItem.firstName)" + " is Perfect".localize
                cell.detailsLabel.text = "\(childItem.firstName)" + " helth is perfect".localize
            case .UN_HEALTH:
                cell.backgroundColor = .orange
                cell.titleLabel.text = "\(childItem.firstName)" + " Might Need Attention".localize
                cell.detailsLabel.text = "\(childItem.firstName)" + " child's health Might need attention . Keep checking his health ".localize
            case .DANGER:
                cell.backgroundColor = AppConstants.F_RED_COLOR
                cell.titleLabel.text = "\(childItem.firstName)" + " need attention".localize
                cell.detailsLabel.text = "\(childItem.firstName)" + " child's health need attention .visit your closest medical center to get a check-up ".localize
            
            }*/
            
            /*
            if indexPath.row == 0 {
                
                cell.backgroundColor = .orange
                cell.profileImageView.image = UIImage(named: "c1")
                cell.titleLabel.text = "Naya need more attention"
                cell.detailsLabel.text = "please follow naya objectives in order to check her health status "
            }else if indexPath.row == 1 {
                cell.backgroundColor = AppConstants.GREEN_COLOR
                cell.profileImageView.image = UIImage(named: "c2")
                
                cell.titleLabel.text = "Jad is Fine"
                cell.detailsLabel.text = "please keep jad health status updated by asking all remainig questions"
            }else if indexPath.row == 2 {
                cell.backgroundColor = AppConstants.F_RED_COLOR
                cell.profileImageView.image = UIImage(named: "c3")
                cell.titleLabel.text = "selen need to visit center to check her health"
                cell.detailsLabel.text = "please keep selen health status updated by asking all remainig questions"
            }*/
            
            //scell.backgroundColor = .red
            return cell
        }
        
        
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == self.infoCollectionView  {
            
             return CGSize(width: infoCollectionView.frame.width - 15  , height: 135)
            
        }
        
        if collectionView == self.servicesCollectionView  {
            
            return CGSize(width: collectionView.frame.height / 2 + 20 , height: collectionView.frame.height  - 20)
            
        }
        
        return CGSize(width: 150, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == servicesCollectionView {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == servicesCollectionView {
            return 10
            
        }
        return 10.0
    }
    
    
}


