//
//  EmployessViewController.swift
//  SPECTRUM
//
//  Created by Sandeep Malhotra on 31/12/19.
//  Copyright © 2019 Sandeep Malhotra. All rights reserved.
//

import UIKit

public enum SortBy: String {
    case name = "Name"
    case age = "Age"
}

class EmployessViewController: UIBaseVC {
    
    var screenTitle: String?
    
    @IBOutlet weak var txtFieldSort: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var arrayTableData: [Members]?
    //var arrayOfEmployees: [Members]?
    
    var favIndexes: [String] = []
    
    var resultSearchController = UISearchController()
    var filteredTableData: [Members] = []
    
    var sortPicker: UIPickerView!
    var arraySortBy: [SortBy] = [
        SortBy.name,
        SortBy.age
    ]
    var arraySortType: [SortType] = [
        SortType.ascending,
        SortType.descending
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpUI()
        setUpSortPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = self.screenTitle ?? "SPECTRUM"
    }
    
    func setUpUI() {
        DispatchQueue.main.async {
            self.tableView.estimatedRowHeight = 70.0
            self.tableView.rowHeight = UITableView.automaticDimension
            
            self.addSearchInTableView()
        }
    }
    
    func setUpSortPicker() {
        self.sortPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 300))
        self.sortPicker.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.txtFieldSort.inputView = sortPicker
        self.txtFieldSort.inputAccessoryView = toolBar
    }
    
    @objc func donePicker() {
        self.txtFieldSort.resignFirstResponder()
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
    
    func sortArray(byLabel by: SortBy, byType type: SortType) {
        DispatchQueue.main.async {
            
            let arrayData = self.arrayTableData?.sorted(by: { (member1, member2) -> Bool in
                let memberName1 = "\(member1.name?.first ?? "")\(member1.name?.last ?? "")"
                let memberName2 = "\(member2.name?.first ?? "")\(member2.name?.last ?? "")"
                
                let memberAge1 = "\(member1.age ?? 0)"
                let memberAge2 = "\(member2.age ?? 0)"
                
                if by == .name {
                    return (memberName1.localizedCaseInsensitiveCompare(memberName2) == ((type == .ascending) ? .orderedAscending : .orderedDescending))
                } else {
                    return (memberAge1.localizedCaseInsensitiveCompare(memberAge2) == ((type == .ascending) ? .orderedAscending : .orderedDescending))
                }
            })
            self.arrayTableData = arrayData
            self.tableView.reloadData()
        }
    }
    
    func markEmpFav(withIndexPath indexPath: IndexPath) {
        if resultSearchController.isActive {
            self.markAsFavUnFavWhileSearching(itemForIndexpath: IndexPath(row: indexPath.row, section: 0), searchingDataSource: &filteredTableData, completeDataSource: &arrayTableData, tableView: tableView, favoriteIndexes: &favEmpIndexes)
        }
        else {
            self.markAsFavUnFav(itemForIndexpath: IndexPath(row: indexPath.row, section: 0), completeDataSource: &arrayTableData, tableView: tableView, favoriteIndexes: &favEmpIndexes)
        }
    }
}

extension EmployessViewController: UITableViewDataSource {
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
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "EmployessCell", for: indexPath) as? EmployessCell {
            if (resultSearchController.isActive) {
                if self.filteredTableData.count > 0 {
                    if let member = self.filteredTableData[indexPath.row] as? Members {
                        cell.configureDataForMember(withMember: member, andIndexPath: indexPath)
                    }
                }
            } else {
                if let arrData = self.arrayTableData, let member = arrData[indexPath.row] as? Members {
                    cell.configureDataForMember(withMember: member, andIndexPath: indexPath)
                }
            }
            cell.actionDelegate = self
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}

extension EmployessViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EmployessViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        
        if let tableData = self.arrayTableData, tableData.count > 0 {
            let arrayData = tableData.filter { (member) -> Bool in
                (("\(member.name?.first ?? "") \(member.name?.last ?? "")")).lowercased().contains((searchController.searchBar.text ?? "").lowercased())
            }
            self.filteredTableData = arrayData
        }
        
        self.tableView.reloadData()
    }
}

extension EmployessViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return self.arraySortBy[row].rawValue
        } else if component == 1 {
            return self.arraySortType[row].rawValue
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var sortBy: SortBy = .name
        var sortType: SortType = .ascending
        
        if component == 0 {
            if row == 0 {
                sortBy = .name
            } else if row == 1 {
                sortBy = .age
            }
            if pickerView.selectedRow(inComponent: 1) == 0 {
                sortType = .ascending
            }
            else {
                sortType = .descending
            }
        } else if component == 1 {
            if pickerView.selectedRow(inComponent: 0) == 0 {
                sortBy = .name
            }
            else {
              sortBy = .age
            }
            if row == 0 {
                sortType = .ascending
            } else if row == 1 {
                sortType = .descending
            }
        }
        
        self.sortArray(byLabel: sortBy, byType: sortType)
    }
}

extension EmployessViewController: ActionDelegate {
    func btnFollowClicked(withIndexPath indexPath: IndexPath) {
    }
    
    func btnFavouriteClicked(withIndexPath indexPath: IndexPath) {
        self.markEmpFav(withIndexPath: indexPath)
    }
}
