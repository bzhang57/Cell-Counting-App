//
//  FinishScreenViewController.swift
//  Hemocytometer Cell Counter
//
//  Created by Bryan Zhang on 8/1/16.
//  Copyright © 2016 Bryan Zhang. All rights reserved.
//

import UIKit
import MessageUI

class FinishScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var Export: UIButton!
    
    @IBOutlet weak var SamplesLabel: UILabel!
    
    @IBOutlet weak var ClearAllButton: UIButton!
    
    @IBOutlet weak var Edit: UIButton!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    var CellNames: [NSString] = []
    var CellCount: [NSString] = []
    var NumCells: [NSString] = []
    var CellVolume: [NSString] = []
    var Dates: [NSString] = []
    var NumSquares: [NSString] = []
    var DilutionFactorArray: [NSString] = []
    var CounterArray: [NSString] = []
    
    var selectedIndexPath = [NSIndexPath]()
    var emailBody = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let font:UIFont? = UIFont(name: "Helvetica", size:10)
        let fontSuper:UIFont? = UIFont(name: "Helvetica", size:8)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: "(x106/mL)" , attributes: [NSFontAttributeName:font!])
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:10], range: NSRange(location:4,length:1))
        let attString2:NSMutableAttributedString = NSMutableAttributedString(string: "(x106)" , attributes: [NSFontAttributeName:font!])
        attString2.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:10], range: NSRange(location:4,length:1))
        label1.attributedText = attString
        label2.attributedText = attString2
        SamplesLabel.text = "Samples(" + String(CellNames.count) + ")"
        self.tableView.allowsMultipleSelection = true
        
        if (selectedIndexPath.count == 0) {
            Export.enabled = false
        }
        if (CellNames.count == 0) {
            ClearAllButton.enabled = false
        } else {
            ClearAllButton.enabled = true
        }
        Edit.enabled = false
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellNames.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            CellNames.removeAtIndex(indexPath.row)
            CellCount.removeAtIndex(indexPath.row)
            NumCells.removeAtIndex(indexPath.row)
            CellVolume.removeAtIndex(indexPath.row)
            Dates.removeAtIndex(indexPath.row)
            NumSquares.removeAtIndex(indexPath.row)
            DilutionFactorArray.removeAtIndex(indexPath.row)
                CounterArray.removeAtIndex(indexPath.row)
            
            SamplesLabel.text = "Samples(" + String(CellNames.count) + ")"
            tableView.reloadData()
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(CellNames, forKey:"CellNames")
            userDefaults.setObject(CellCount, forKey: "CellCount")
            userDefaults.setObject(NumCells, forKey: "NumCells")
            userDefaults.setObject(CellVolume, forKey: "CellVolume")
            userDefaults.setObject(Dates, forKey: "Dates")
            userDefaults.setObject(NumSquares, forKey: "NumSquares")
            userDefaults.setObject(DilutionFactorArray, forKey: "DilutionFactorArray")
            userDefaults.setObject(CounterArray, forKey: "CounterArray")
            userDefaults.synchronize()
            self.tableView.reloadData()
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SampleCell
        cell.CellName.text = CellNames[indexPath.row] as String
        cell.CellCount.text = CellCount[indexPath.row] as String
       
        
        cell.NumCells.text = NumCells[indexPath.row] as String!
        cell.CellVolume.text = CellVolume[indexPath.row] as String!
        cell.Date.text = Dates[indexPath.row] as String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Export.enabled = true
        selectedIndexPath.append(indexPath)
        if (selectedIndexPath.count == 1) {
            Edit.enabled = true
           
        } else {
            Edit.enabled = false
           
        }
       
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let index = selectedIndexPath.indexOf(indexPath) {
            selectedIndexPath.removeAtIndex(index)
        }
        if (selectedIndexPath.count == 0) {
            Export.enabled = false
        }
        if (selectedIndexPath.count == 1) {
            Edit.enabled = true
            
        } else {
            Edit.enabled = false
            
        }
    }
    
    private func WriteEmailBody() {
        
        for NSIndexPath in selectedIndexPath {
            let currentCell = tableView.cellForRowAtIndexPath(NSIndexPath)! as! SampleCell
            emailBody += "Sample Name: " + currentCell.CellName.text! + "\n"
            emailBody += "Concentration (x10^6): " + currentCell.CellCount.text! + "\n"
            
            emailBody += "# of Cells Needed (x10^6): " + currentCell.NumCells.text! + "\n"
            emailBody += "Volume of cells (μL): " + currentCell.CellVolume.text! + "\n"
            emailBody += "Date: " + currentCell.Date.text! + "\n\n"
            emailBody += "-----------------------------------\n"
            
        }
        
    }
    func configureMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["your@email.com"])
        mailComposerVC.setSubject("Hemocytometer Samples")
        WriteEmailBody()
        mailComposerVC.setMessageBody(emailBody, isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send email. Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            emailBody = ""
        case MFMailComposeResultSent.rawValue:
            print("hello")
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func ExportData(sender: AnyObject) {
        let mailComposeViewController = configureMailComposeViewController()
        if (MFMailComposeViewController.canSendMail()) {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    private func Clear()
    {
        CellNames.removeAll()
        NumCells.removeAll()
        Dates.removeAll()
        CellCount.removeAll()
        CellVolume.removeAll()
        NumSquares.removeAll()
        DilutionFactorArray.removeAll()
        CounterArray.removeAll()
        
        SamplesLabel.text = "Samples(" + String(CellNames.count) + ")"
        tableView.reloadData()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(CellNames, forKey:"CellNames")
        userDefaults.setObject(CellCount, forKey: "CellCount")
        userDefaults.setObject(NumCells, forKey: "NumCells")
        userDefaults.setObject(CellVolume, forKey: "CellVolume")
        userDefaults.setObject(Dates, forKey: "Dates")
        userDefaults.setObject(NumSquares, forKey: "NumSquares")
        userDefaults.setObject(DilutionFactorArray, forKey: "DilutionFactorArray")
        userDefaults.setObject(CounterArray, forKey: "CounterArray")
        userDefaults.synchronize()
        ClearAllButton.enabled = false
    }
    
    @IBAction func ClearAll(sender: AnyObject) {
        let alertController = UIAlertController(title: "Caution", message: "Are you sure you want to clear all samples?", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Clear", style: UIAlertActionStyle.Default) {
            UIAlertAction in self.Clear()
            
            })
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "FinishToHome") {
            let HomeScreen = segue.destinationViewController as! ViewController
        } else if (segue.identifier == "FinishToSample") {
            let SampleScreen = segue.destinationViewController as! SampleViewController
            let index = selectedIndexPath[0].item
            SampleScreen.CameFromFinishScreen = true
            SampleScreen.indexAtEditedItem = selectedIndexPath[0].item
            
            SampleScreen.numberOfSquares = Int(NumSquares[index] as String)!
            
            SampleScreen.viaSegue = CellNames[index] as String
            SampleScreen.CellCountSegue = CellCount[index] as String
            SampleScreen.CellVolumeSegue = CellVolume[index] as String
            //print(DilutionFactorArray[1])
            SampleScreen.DilutionFactorSegue = DilutionFactorArray[index] as String!
            SampleScreen.CounterArraySegue = CounterArray[index] as String!
            SampleScreen.neededCellsSegue = NumCells[index] as String!
            SampleScreen.DateSegue = Dates[index] as String!
            //SampleScreen.NumOfSquaresLabel.text = NumSquares[index] as String
            
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
