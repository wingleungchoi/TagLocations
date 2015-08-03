//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Wing LeungCHOI on 1/8/15.
//  Copyright (c) 2015 WingLeung CHOI. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

private let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    formatter.timeStyle = .ShortStyle
    return formatter
}()

class LocationDetailsViewController: UITableViewController, UITextViewDelegate {
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBAction func categoryPickerDidPickCategory(segue: UIStoryboardSegue) {
        let controller = segue.sourceViewController as! CategoryPickerViewController
        categoryName = controller.selectedCategoryName
        categoryLabel.text = categoryName
    }
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var descriptionText = ""
    var categoryName = "No Category"
    var managedObjectContext: NSManagedObjectContext!
    
    @IBAction func done() {
        let hubView = HudView.hudInView(navigationController!.view, animated: true)
        hubView.text = "Tagged"
        afterDelay(0.6, {
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
    }
    
    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 88
        } else if indexPath.section == 2 && indexPath.row == 2{
            addressLabel.frame.size = CGSize(width: view.bounds.size.width - 115, height: 10000)
            addressLabel.sizeToFit()
            addressLabel.frame.origin.x = view.bounds.size.width - addressLabel.frame.size.width - 15
            return addressLabel.frame.size.height + 20
        } else {
            return 44
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.text = descriptionText
        categoryLabel.text =  categoryName
        
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        
        if let placemark = placemark {
            addressLabel.text = stringFromPlacemark(placemark)
            println(stringFromPlacemark(placemark))
        } else {
            addressLabel.text = "No Address Found"
        }
    
        dateLabel.text = formatDate(NSDate())
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard:"))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    func stringFromPlacemark(placemark: CLPlacemark) -> String{
        return
        "\(placemark.subThoroughfare) \(placemark.thoroughfare), " +
        "\(placemark.locality), " +
        "\(placemark.administrativeArea) \(placemark.postalCode), " +
        "\(placemark.country)"
    }
    
    func formatDate(date: NSDate) -> String {
        return dateFormatter.stringFromDate(date)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickCategory" {
            let controller = segue.destinationViewController as! CategoryPickerViewController
            controller.selectedCategoryName = categoryName
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 0 || indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.section == 1 {
            descriptionTextView.becomeFirstResponder()
        }
    }
    
    func hideKeyboard(gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.locationInView(tableView)
        println(point)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        
        if indexPath != nil && indexPath!.section == 0 && indexPath!.row == 0 {
            return
        }
        descriptionTextView.resignFirstResponder()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        descriptionTextView.frame.size.width = view.frame.size.width - 30
    }

}
extension LocationDetailsViewController: UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        descriptionText = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        return true
    }
    func textViewDidEndEditing(textView: UITextView) {
        descriptionText = textView.text
    }
}
