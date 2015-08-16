//
//  CategoryPickerViewController.swift
//  MyLocations
//
//  Created by Wing LeungCHOI on 2/8/15.
//  Copyright (c) 2015 WingLeung CHOI. All rights reserved.
//

import UIKit

class CategoryPickerViewController: UITableViewController {
    var selectedCategoryName = ""
    let categories = [
        "No Category",
        "Apple Store",
        "Bookstore",
        "Club",
        "Grocery Store",
        "History Building",
        "House",
        "Icecream Vendor",
        "Landmark",
        "Park"
    ]
    var selectedIndexPath = NSIndexPath()
    
    // Mark: - UITableViewDataSource
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.blackColor()
        tableView.separatorColor = UIColor(white: 1.0, alpha: 0.2)
        tableView.indicatorStyle = .White
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.blackColor()
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.textLabel!.highlightedTextColor = cell.textLabel!.textColor
        let selectionView = UIView(frame: CGRect.zeroRect)
        selectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        cell.selectedBackgroundView = selectionView
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("")
        if let a = tableView as UITableView?{
            println(a)
        }
        println(tableView.dequeueReusableCellWithIdentifier("Cell"))
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        let categoryName = categories[indexPath.row]
        cell.textLabel!.text = categoryName
        
        if categoryName == selectedCategoryName {
            cell.accessoryType = .Checkmark
            selectedIndexPath = indexPath
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    // Mark: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != selectedIndexPath.row {
            if let newCell = tableView.cellForRowAtIndexPath(indexPath) {
                newCell.accessoryType = .Checkmark
            }
            
            if let oldCell = tableView.cellForRowAtIndexPath(selectedIndexPath) {
                oldCell.accessoryType = .None
            }
            
            selectedIndexPath = indexPath
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickedCategory" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPathForCell(cell){
                selectedCategoryName = categories[indexPath.row]
            }
        }
    }
}
