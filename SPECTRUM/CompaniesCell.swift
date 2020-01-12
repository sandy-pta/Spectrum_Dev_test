//
//  CompaniesCell.swift
//  SPECTRUM
//
//  Created by Sandeep Malhotra on 31/12/19.
//  Copyright © 2019 Sandeep Malhotra. All rights reserved.
//

import UIKit

public protocol ActionDelegate {
    func btnFavouriteClicked(withIndexPath indexPath: IndexPath)
    func btnFollowClicked(withIndexPath indexPath: IndexPath)
}

class CompaniesCell: UITableViewCell {

    @IBOutlet weak var imgViewLogo: UIImageView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblCompanyDescription: UILabel!
    @IBOutlet weak var lblCompanyWebSite: UILabel!
    
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var btnFollow: UIButton!

    var actionDelegate: ActionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureDataForCompany(withCompany companyDetails: CompaniesAndMembersResponse?, andIndexPath indexPath: IndexPath) {
        if let company = companyDetails {
            self.lblCompanyName.text = company.company ?? " "
            self.lblCompanyDescription.text = company.about ?? " "
            self.lblCompanyWebSite.text = company.website ?? " "
            
            if let imgUrl = company.logo {
                self.imgViewLogo.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "SpectrumImage.png"), options: .refreshCached, completed: nil)
            }
            
            if company.isFav {
                self.btnFav.setImage(UIImage(named: "fav"), for: .normal)
            } else {
                self.btnFav.setImage(UIImage(named: "unFav"), for: .normal)
            }
            
            if company.isFollowing {
                self.btnFollow.setTitle("Unfollow", for: .normal)
            } else {
                self.btnFollow.setTitle("Follow", for: .normal)
            }
            
            self.btnFav.tag = indexPath.row
            self.btnFav.addTarget(self, action: #selector(markCompanyFav(_:)), for: .touchUpInside)
            self.btnFollow.tag = indexPath.row
            self.btnFollow.addTarget(self, action: #selector(markCompanyFollow(_:)), for: .touchUpInside)
        }
    }
    
    @objc func markCompanyFav(_ sender: Any) {
        if let button = sender as? UIButton, let delegate = self.actionDelegate {
            delegate.btnFavouriteClicked(withIndexPath: IndexPath(row: button.tag, section: 0))
        }
    }
    
    @objc func markCompanyFollow(_ sender: Any) {
        if let button = sender as? UIButton, let delegate = self.actionDelegate {
            delegate.btnFollowClicked(withIndexPath: IndexPath(row: button.tag, section: 0))
        }
    }
}
