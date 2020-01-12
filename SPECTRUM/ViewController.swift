//
//  ViewController.swift
//  SPECTRUM
//
//  Created by Sandeep Malhotra on 30/12/19.
//  Copyright © 2019 Sandeep Malhotra. All rights reserved.
//

import UIKit
import SDWebImage

public enum SortType: String {
    case ascending = "Ascending"
    case descending = "Desending"
}

class ViewController: UIBaseVC {
    @IBOutlet weak var btnFav: UIBarButtonItem!
    @IBOutlet weak var btnSort: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    var screenTitle: String?
    var arrayTableData: [CompaniesAndMembersResponse]?
    var arrayOfCompanies: [CompaniesAndMembersResponse]?
    
    var resultSearchController = UISearchController()
    var filteredTableData: [CompaniesAndMembersResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = self.screenTitle ?? "Companies"
        setUpUI()
        APIManager.sharedInstance.conformToSpectrumProtocol(withDelegate: self)
        
        CustomLoader.sharedInstance.addLoader(onView: self.view)
        APIManager.sharedInstance.callGetClubDetailsAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setUpUI() {
        DispatchQueue.main.async {
            self.tableView.estimatedRowHeight = 75.0
            self.tableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    func addSearchInTableView() {
        DispatchQueue.main.async {
            self.resultSearchController = ({
                let controller = UISearchController(searchResultsController: nil)
                controller.searchResultsUpdater = self
                controller.dimsBackgroundDuringPresentation = false
                controller.searchBar.sizeToFit()
                
                self.tableView.tableHeaderView = controller.searchBar
                
                return controller
            })()
            
            // Reload the table
            self.tableView.reloadData()
        }
    }
    
    @IBAction func btnFavClicked(_ sender: Any) {
        
    }
    
    @IBAction func btnSortClicked(_ sender: Any) {
        if let title = self.btnSort.title {
            if title == "Sort" {
                // Sort in Asc
                self.sortArray(inType: .ascending)
                self.btnSort.title = "Sort: Descinding"
            } else if title == "Sort: Ascending" {
                // Sort in Asc
                self.sortArray(inType: .ascending)
                self.btnSort.title = "Sort: Descinding"
            } else if title == "Sort: Descinding" {
                // Sort in Dsc
                self.sortArray(inType: .descending)
                self.btnSort.title = "Sort: Ascending"
            }
        }
    }
    
    func sortArray(inType type: SortType) {
        DispatchQueue.main.async {
            let arrayData = self.arrayTableData?.sorted(by: { (company1, company2) -> Bool in
                let companyName1 = company1.company ?? ""
                let companyName2 = company2.company ?? ""
                return (companyName1.localizedCaseInsensitiveCompare(companyName2) == ((type == .ascending) ? .orderedAscending : .orderedDescending))
            })
            self.arrayTableData = arrayData
            self.tableView.reloadData()
        }
    }
    
    func markCompanyFav(withIndexPath indexPath: IndexPath) {
        if resultSearchController.isActive {
            self.markAsFavUnFavWhileSearching(itemForIndexpath: IndexPath(row: indexPath.row, section: 0), searchingDataSource: &filteredTableData, completeDataSource: &arrayTableData, tableView: tableView, favoriteIndexes: &favCompIndexes)
        }
        else {
            self.markAsFavUnFav(itemForIndexpath: IndexPath(row: indexPath.row, section: 0), completeDataSource: &arrayTableData, tableView: tableView, favoriteIndexes: &favCompIndexes)
        }
    }
    
    func markCompanyFollow(withIndexPath indexPath: IndexPath) {
        if resultSearchController.isActive {
            self.markAsFavUnFavWhileSearching(itemForIndexpath: IndexPath(row: indexPath.row, section: 0), searchingDataSource: &filteredTableData, completeDataSource: &arrayTableData, tableView: tableView, favoriteIndexes: &followIndexes,isForFollowing: true)
        }
        else {
            self.markAsFavUnFav(itemForIndexpath: IndexPath(row: indexPath.row, section: 0), completeDataSource: &arrayTableData, tableView: tableView, favoriteIndexes: &followIndexes, isForFollowing: true)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (self.resultSearchController.isActive) {
            return filteredTableData.count
        } else {
            if let arrData = self.arrayTableData {
                return arrData.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "CompaniesCell", for: indexPath) as? CompaniesCell {
            if (resultSearchController.isActive) {
                if self.filteredTableData.count > 0 {
                    if let company = self.filteredTableData[indexPath.row] as? CompaniesAndMembersResponse {
                        cell.configureDataForCompany(withCompany: company, andIndexPath: indexPath)
                    }
                }
            } else {
                if let arrData = self.arrayTableData, let company = arrData[indexPath.row] as? CompaniesAndMembersResponse {
                    cell.configureDataForCompany(withCompany: company, andIndexPath: indexPath)
                }
            }
            cell.selectionStyle = .none
            cell.actionDelegate = self
            return cell
        }
        return UITableViewCell()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let employeesVC = UIStoryboard(name: .main).instantiateViewController(withIdentifier: "EmployessViewController") as! EmployessViewController
        if let arrData = self.arrayTableData, let company = arrData[indexPath.row] as? CompaniesAndMembersResponse {
            //employeesVC.arrayOfEmployees = company.members ?? []
            employeesVC.arrayTableData = company.members ?? []
            employeesVC.screenTitle = company.company
        }
        self.navigationController?.pushViewController(employeesVC, animated: true)
    }
}

extension ViewController: SpectrumProtocol {
    func companyResponseReceived(withResponse responseArray: [CompaniesAndMembersResponse]?, withError error: Error?) {
        if let arrData = responseArray, arrData.count > 0 {
            DispatchQueue.main.async {
                CustomLoader.sharedInstance.removeLoader()
                self.arrayOfCompanies = arrData
                self.arrayTableData = arrData
                self.addSearchInTableView()
            }
        }
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        
        if let tableData = self.arrayTableData, tableData.count > 0 {
            let arrayData = tableData.filter { (company) -> Bool in
                (company.company ?? "").lowercased().contains((searchController.searchBar.text ?? "").lowercased())
            }
            self.filteredTableData = arrayData
        }
        
        self.tableView.reloadData()
    }
}

extension ViewController: ActionDelegate {
    func btnFavouriteClicked(withIndexPath indexPath: IndexPath) {
        self.markCompanyFav(withIndexPath: indexPath)
    }
    
    func btnFollowClicked(withIndexPath indexPath: IndexPath) {
        self.markCompanyFollow(withIndexPath: indexPath)
    }
}
