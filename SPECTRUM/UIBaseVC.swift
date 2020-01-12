//
//  UIBaseVC.swift
//  SPECTRUM
//
//  Created by Sandeep Malhotra on 1/5/20.
//  Copyright © 2020 Sandeep Malhotra. All rights reserved.
//

import UIKit

class UIBaseVC: UIViewController {

    var favCompIndexes: [String] = []
    var followIndexes: [String] = []
    var favEmpIndexes: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func markAsFavUnFav(itemForIndexpath indexPath: IndexPath, completeDataSource  arrayTableData : inout [CompaniesAndMembersResponse]?, tableView : UITableView, favoriteIndexes favIndexes: inout [String], isForFollowing: Bool? = nil) {
        if let arrData = arrayTableData, let company = arrData[indexPath.row] as? CompaniesAndMembersResponse, let id = company._id {
            if favIndexes.count > 0 {
                if favIndexes.contains(id) {
                    // Remove
                    if let row = arrayTableData?.firstIndex(where: { (company) -> Bool in
                        company._id == id
                    }) {
                        if let forFollow = isForFollowing, forFollow {
                            arrayTableData?[row].isFollowing = false
                        }
                        else {
                            arrayTableData?[row].isFav = false
                        }
                        DispatchQueue.main.async {
                            tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
                        }
                    }
                    favIndexes.removeAll(where: { (idFound) -> Bool in
                        (idFound == id)
                    })
                } else {
                    // Add
                    if let row = arrayTableData?.firstIndex(where: { (company) -> Bool in
                        company._id == id
                    }) {
                        if let forFollow = isForFollowing, forFollow {
                            arrayTableData?[row].isFollowing = true
                        }
                        else {
                            arrayTableData?[row].isFav = true
                        }
                        DispatchQueue.main.async {
                            tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
                        }
                    }
                    favIndexes.append(id)
                }
            } else {
                // Add
                if let row = arrayTableData?.firstIndex(where: { (company) -> Bool in
                    company._id == id
                }) {
                    
                    if let forFollow = isForFollowing, forFollow {
                        arrayTableData?[row].isFollowing = true
                    }
                    else {
                       arrayTableData?[row].isFav = true
                    }
                    DispatchQueue.main.async {
                        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
                    }
                }
                favIndexes.append(id)
            }
        }
    }
    
    func markAsFavUnFavWhileSearching(itemForIndexpath indexPath: IndexPath, searchingDataSource filteredTableData : inout [CompaniesAndMembersResponse], completeDataSource  arrayTableData : inout [CompaniesAndMembersResponse]?, tableView : UITableView, favoriteIndexes favIndexes: inout [String], isForFollowing: Bool? = nil) {
            if filteredTableData.count > 0 {
                let company = filteredTableData[indexPath.row]
                if let id = company._id {
                    if favIndexes.count > 0 {
                        if favIndexes.contains(id) {
                            // Remove
                            if let row = arrayTableData?.firstIndex(where: { (company) -> Bool in
                                company._id == id
                            }) {
                                if let forFollow = isForFollowing, forFollow {
                                    filteredTableData[indexPath.row].isFollowing = false
                                    arrayTableData?[row].isFollowing = false
                                }
                                else {
                                    filteredTableData[indexPath.row].isFav = false
                                    arrayTableData?[row].isFav = false
                                }
                                DispatchQueue.main.async {
                                    tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
                                }
                            }
                            favIndexes.removeAll(where: { (idFound) -> Bool in
                                (idFound == id)
                            })
                        } else {
                            // Add
                            if let row = arrayTableData?.firstIndex(where: { (company) -> Bool in
                                company._id == id
                            }) {
                                if let forFollow = isForFollowing, forFollow {
                                    filteredTableData[indexPath.row].isFollowing = true
                                    arrayTableData?[row].isFollowing = true
                                }
                                else {
                                    filteredTableData[indexPath.row].isFav = true
                                    arrayTableData?[row].isFav = true
                                }
                                DispatchQueue.main.async {
                                    tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
                                }
                            }
                            favIndexes.append(id)
                        }
                    } else {
                        // Add
                        if let row = arrayTableData?.firstIndex(where: { (company) -> Bool in
                            company._id == id
                        }) {
                            if let forFollow = isForFollowing, forFollow {
                                filteredTableData[indexPath.row].isFollowing = true
                                arrayTableData?[row].isFollowing = true
                            }
                            else {
                                filteredTableData[indexPath.row].isFav = true
                                arrayTableData?[row].isFav = true
                            }
                            DispatchQueue.main.async {
                                tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
                            }
                        }
                        favIndexes.append(id)
                    }
                }
            }
    }
    
    func markAsFavUnFav(itemForIndexpath indexPath: IndexPath, completeDataSource  arrayTableData : inout [Members]?, tableView : UITableView, favoriteIndexes favIndexes: inout [String]) {
        if let arrData = arrayTableData, let company = arrData[indexPath.row] as? Members, let id = company._id {
            if favIndexes.count > 0 {
                if favIndexes.contains(id) {
                    // Remove
                    if let row = arrayTableData?.firstIndex(where: { (company) -> Bool in
                        company._id == id
                    }) {
                        arrayTableData?[row].isFav = false
                        DispatchQueue.main.async {
                            tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
                        }
                    }
                    favIndexes.removeAll(where: { (idFound) -> Bool in
                        (idFound == id)
                    })
                } else {
                    // Add
                    if let row = arrayTableData?.firstIndex(where: { (company) -> Bool in
                        company._id == id
                    }) {
                        arrayTableData?[row].isFav = true
                        DispatchQueue.main.async {
                            tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
                        }
                    }
                    favIndexes.append(id)
                }
            } else {
                // Add
                if let row = arrayTableData?.firstIndex(where: { (company) -> Bool in
                    company._id == id
                }) {
                    arrayTableData?[row].isFav = true
                    DispatchQueue.main.async {
                        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
                    }
                }
                favIndexes.append(id)
            }
        }
    }
    
    func markAsFavUnFavWhileSearching(itemForIndexpath indexPath: IndexPath, searchingDataSource filteredTableData : inout [Members], completeDataSource  arrayTableData : inout [Members]?, tableView : UITableView, favoriteIndexes favIndexes: inout [String]) {
        if filteredTableData.count > 0 {
            let company = filteredTableData[indexPath.row]
            if let id = company._id {
                if favIndexes.count > 0 {
                    if favIndexes.contains(id) {
                        // Remove
                        if let row = arrayTableData?.firstIndex(where: { (company) -> Bool in
                            company._id == id
                        }) {
                            filteredTableData[indexPath.row].isFav = false
                            arrayTableData?[row].isFav = false
                            DispatchQueue.main.async {
                                tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
                            }
                        }
                        favIndexes.removeAll(where: { (idFound) -> Bool in
                            (idFound == id)
                        })
                    } else {
                        // Add
                        if let row = arrayTableData?.firstIndex(where: { (company) -> Bool in
                            company._id == id
                        }) {
                            filteredTableData[indexPath.row].isFav = true
                            arrayTableData?[row].isFav = true
                            DispatchQueue.main.async {
                                tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
                            }
                        }
                        favIndexes.append(id)
                    }
                } else {
                    // Add
                    if let row = arrayTableData?.firstIndex(where: { (company) -> Bool in
                        company._id == id
                    }) {
                        filteredTableData[indexPath.row].isFav = true
                        arrayTableData?[row].isFav = true
                        DispatchQueue.main.async {
                            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
                        }
                    }
                    favIndexes.append(id)
                }
            }
        }
    }

}
