//
//  LocationsViewController.swift
//  MyLocations
//
//  Created by Wing LeungCHOI on 8/8/15.
//  Copyright (c) 2015 WingLeung CHOI. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class LocationsViewController: UITableViewController {
    var managedObjectContext: NSManagedObjectContext!
    var locations = [Location]()
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entity
        let sortDesriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDesriptor]
        fetchRequest.fetchBatchSize = 20
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: "Locations"
        )
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    deinit {
        fetchedResultsController.delegate = nil
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell") as! LocationCell
        let location = fetchedResultsController.objectAtIndexPath(indexPath) as! Location
        cell.configureForLocation(location)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performFetch()
    }
    
    func performFetch() {
        var error: NSError?
        if !fetchedResultsController.performFetch(&error) {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.fatalCoreDataError(error)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditLocation" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! LocationDetailsViewController
            controller.managedObjectContext = managedObjectContext
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                let location = fetchedResultsController.objectAtIndexPath(indexPath) as! Location
                controller.locationToEdit = location
            }
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let location = fetchedResultsController.objectAtIndexPath(indexPath) as! Location
            managedObjectContext.deleteObject(location)
            
            var error: NSError?
            if !managedObjectContext.save(&error) {
                appDelegate.fatalCoreDataError(error)
            }
        }
    }
    
}

extension LocationsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        println("*** controllerWillChangeContent")
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
            case .Insert:
                println("*** NSFetchedResultsChangeInsert (object)")
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                 println("*** NSFetchedResultsChangeDelete (object)")
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            case .Update:
                println("*** NSFetchedResultsChangeUpdate (object)")
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as! LocationCell
                let location = controller.objectAtIndexPath(indexPath!) as! Location
                cell.configureForLocation(location)
            case .Move:
                println("*** NSFetchedResultsChangeMove (object)")
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
            case .Insert:
                println("*** NSFetchedResultsChangedInsert (section)")
                tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            case .Delete:
                println("*** NSFetchedResultsChangedDelete (section)")
                tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            case .Update:
                println("*** NSFetchedResultsChangedUpdate (section)")
            case .Move:
                println("*** NSFetchedResultsChangedMove (section)")
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        println("*** controllerDidChangeContent")
        tableView.endUpdates()
    }
}