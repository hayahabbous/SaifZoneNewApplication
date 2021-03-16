//
//  aboutUsDetailsViewController.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/30/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import ParallaxHeader


class aboutUsDetailsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var index = 0
    var newsItem: SAIFZONENews!
    var vibArray:[String] = ["WELCOME TO A NEW WAY OF DOING BUSINESS" ,
                                "Chairman’s Message" ,
                                "Director’s Message"]
    
    var titlesArray:[String] = ["At SAIF ZONE" ,
                                "KHALED BIN ABDULLAH BIN SULTAN AL QASIMI, CHAIRMAN" ,
                                "SAUD SALIM AL MAZROUEI,DIRECTOR"]
    var descriptionsArray: [String] = ["""
we offer you the attractive tax-friendly benefits combined with complete ownership in a designated free zone at an unmatched strategic location. With every detail thoughtfully structured and robust service support, we provide plenty of opportunities to connect and collaborate so you can focus solely on growing your business.
""" , """
As the Middle East and Africa becomes an ever more lucrative destination for global businesses, the competition to secure that business becomes equally as fierce. Minimal costs and maximum efficiency play a large role but ultimately it is the delivery of the entire package which will See the strongest businesses thrive. At SAIF ZONE we believe that we not only provide that package for this region, we deliver a product which connects our partners to the rest of the world.

At the heart of our business we aim to provide our clients with the route to operate at their most effective level. We have the facilities and philosophy to cater to individual needs, whether that is for small and medium enterprises or multinational corporations. We have one-stop-shop amenities but not one-size-fits-all beliefs.

SAIF ZONE’s exponential growth from just 55 companies in 1995 to more than 6,500 today is a testament to the Sharjah government’s commitment to free trade. Its outstanding achievements would not have been possible without the wise and dynamic leadership of H.H. Dr. Sheikh Sultan Bin Mohammed Al Qassimi, Member of the UAE Supreme Council and Ruler of Sharjah.

The technicalities, specifics and details of our Free Zone are impressive in their own right but far more than that, we believe our ethics and goals have made us the partner of choice for so many of our loyal customers. We are proud to be supportive, trustworthy, honest, transparent and accountable. We will always put our customers’ needs ahead of our own, safe in the knowledge that mutual respect brings its own rewards. Our partnerships not only work well, our businesses work well.

Welcome to the Freedom of Doing Business Your Way.
""" , """

As we enter the second quarter of 2019, I am proud to inform you that more than 8,000 companies from around 165 countries have currently established their presence at the Sharjah Airport International Free Zone (SAIF ZONE). This is a grand testimony to SAIF ZONE’s growing appeal as a business destination where SMEs and multi-nationals alike can utilise the benefits of our strategic location, modern infrastructure and customer focus-based service to expand and conduct their businesses with confidence.

Our investor base is on a continuous expansion mode as the Free Zone offers impressive advantages in the form of superior infrastructure and facilities, a single window solution for all administrative services, several tax exemptions, repatriation of capital and profits, full business ownership, and easy access to global market.

SAIF ZONE has also kept pace with the growing demand from investors for better and more facilities and services, and we are now in the final phase of a project to develop new and modern warehouses with an area of 600 square metres each, built in accordance with the highest international standards and practices. When completed by the 4th quarter of this year, the new warehouses will offer greater competitive advantages to our investors as these are built such that multiple warehouses can be combined together to be used as larger facilities for both manufacturing and logistic purposes.

We remain committed to further growth to cement SAIF ZONE’s position as a global hub for trade and enterprise and to support the emirate of Sharjah’s industrial development programme. We look forward to the start of the next quarter of 2019 with renewed hope and optimism. Our commitment to excellence and integrity in providing the best business friendly environment for our investors and shareholders will promote efficiency and help businesses operate at competitive costs. By further establishing significant industrial infrastructure and providing incentives for continued investment, SAIF ZONE looks forward to strengthening its position as the preferred regional destination of choice to do business.

Thank you.
"""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        setupView()
        
    }
    
    func setupView() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "director-mob")
        let url = URL(string: "https://devdp.saif-zone.com/download.aspx?FileID=\(newsItem.NewsImage)")
        imageView.kf.setImage(with: url)
        imageView.contentMode = .scaleAspectFill
                
        //setup blur vibrant view
        imageView.blurView.setup(style: UIBlurEffect.Style.dark, alpha: 1).enable()
                
        //headerImageView = imageView
                
        tableView.parallaxHeader.view = imageView
        tableView.parallaxHeader.height = 300
        tableView.parallaxHeader.minimumHeight = 40
        tableView.parallaxHeader.mode = .centerFill
        tableView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in
            //update alpha of blur view on top of image view
            parallaxHeader.view.blurView.alpha = 1 - parallaxHeader.progress
        }
                
        // Label for vibrant text
        let vibrantLabel = UILabel()
        vibrantLabel.text = ""//vibArray[index]
        vibrantLabel.font = UIFont.systemFont(ofSize: 40.0)
        vibrantLabel.sizeToFit()
        vibrantLabel.textAlignment = .center
        vibrantLabel.numberOfLines = 0
        vibrantLabel.lineBreakMode = .byWordWrapping
        imageView.blurView.vibrancyContentView?.addSubview(vibrantLabel)
        //add constraints using SnapKit library
        vibrantLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
extension aboutUsDetailsViewController: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellIdentifier = ""
        
        switch indexPath.row {
        case 0:
            cellIdentifier = "TitleCell"
        case 1:
            cellIdentifier = "Cell"
        default:
            cellIdentifier  = ""
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        
        let label = cell.viewWithTag(1) as! UILabel
        switch indexPath.row {
        case 0:
            label.text = newsItem.News
            
        case 1:
            label.text = newsItem.NewsDetail
        default:
            label.text = ""
        }
        
        
        return cell
    }
}
