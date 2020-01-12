//
//  EmployessCell.swift
//  SPECTRUM
//
//  Created by Sandeep Malhotra on 31/12/19.
//  Copyright © 2019 Sandeep Malhotra. All rights reserved.
//

import UIKit

class EmployessCell: UITableViewCell {

    @IBOutlet weak var lblEmployeeName: UILabel!
    @IBOutlet weak var lblEmployeeAge: UILabel!
    @IBOutlet weak var lblEmployeePhone: UILabel!
    @IBOutlet weak var lblEmployeeEmail: UILabel!
    @IBOutlet weak var btnFav: UIButton!

//    @IBOutlet weak var btnFav: UIButton!
    var actionDelegate: ActionDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureDataForMember(withMember memberDetails: Members?, andIndexPath indexPath: IndexPath) {
        if let member = memberDetails {
            if let name = member.name {
                self.lblEmployeeName.text = "Name: \(name.first ?? " ") \(name.last ?? " ")"
            }
            self.lblEmployeeAge.text = "Age: \(member.age ?? 0)"
            self.lblEmployeePhone.text = "Phone: \(member.phone ?? " ")"
            self.lblEmployeeEmail.text = "Email: \(member.email ?? " ")"
            
            if member.isFav {
                self.btnFav.setImage(UIImage(named: "fav"), for: .normal)
            } else {
                self.btnFav.setImage(UIImage(named: "unFav"), for: .normal)
            }
            
            self.btnFav.tag = indexPath.row
            self.btnFav.addTarget(self, action: #selector(markMemberFav(_:)), for: .touchUpInside)
        }
    }
    
    @objc func markMemberFav(_ sender: Any) {
        if let button = sender as? UIButton, let delegate = self.actionDelegate {
            delegate.btnFavouriteClicked(withIndexPath: IndexPath(row: button.tag, section: 0))
        }
    }
}
