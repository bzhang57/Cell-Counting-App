//
//  ViewController.swift
//  Hemocytometer Cell Counter
//
//  Created by Bryan Zhang on 8/1/16.
//  Copyright © 2016 Bryan Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var numSquares: UITextField!
    
    
    @IBOutlet weak var StartButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        StartButton.enabled = false
        numSquares.delegate = self
        
        self.addDoneButtonOnKeyboard()
        
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(ViewController.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.numSquares.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        print(numSquares.text)
        var number: Int? = 0
        if (numSquares.text != "") {
            number = Int(numSquares.text!)
            
        }
        if (numSquares.text == "" || number == 0) {
            StartButton.enabled = false
        } else {
            StartButton.enabled = true
        }
        self.numSquares.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        StartButton.enabled = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if (numSquares.text != "" && Int(numSquares.text!) != 0) {
            StartButton.enabled = true
        } else {
            StartButton.enabled = false
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "1stTo2nd") {
            let sampleVC = segue.destinationViewController as! SampleViewController
            sampleVC.viaSegue = numSquares.text!
        } else if (segue.identifier == "firstToLast") {
            let finalVC = segue.destinationViewController as! FinishScreenViewController
            let samples : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("CellNames")
            if (samples != nil) {
                finalVC.CellNames = samples as! [NSString]
            }
            let cellCounts : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("CellCount")
            if (cellCounts != nil) {
                finalVC.CellCount = cellCounts as! [NSString]
            }
            let numberCells : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("NumCells")
            if (numberCells != nil) {
                finalVC.NumCells = numberCells as! [NSString]
            }
            let cellVolumes : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("CellVolume")
            if (cellVolumes != nil) {
                finalVC.CellVolume = cellVolumes as! [NSString]
            }
            let dates : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("Dates")
            if (dates != nil) {
                finalVC.Dates = dates as! [NSString]
            }
            let numSquares : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("NumSquares")
            if (numSquares != nil) {
                finalVC.NumSquares = numSquares as! [NSString]
            }
            let dilutionFactor : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("DilutionFactorArray")
            if (dilutionFactor != nil) {
                finalVC.DilutionFactorArray = dilutionFactor as! [NSString]
            }
            let counterArray : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("CounterArray")
            if (counterArray != nil) {
                finalVC.CounterArray = counterArray as! [NSString]
            }
        }
    }
    
    private func ClearAll() {
        var samples : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("CellNames")
        samples = []
        var cellCounts : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("CellCount")
        cellCounts = []
        var numberCells : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("NumCells")
        numberCells = []
        var cellVolumes : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("CellVolume")
        cellVolumes = []
        
        var dates : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("Dates")
        dates = []
        
        var numSquares : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("NumSquares")
        numSquares = []
        var dilutionFactor : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("DilutionFactorArray")
        dilutionFactor = []
        
        var counterArray : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("CounterArray")
        counterArray = []
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(samples, forKey:"CellNames")
        userDefaults.setObject(cellCounts, forKey: "CellCount")
        userDefaults.setObject(numberCells, forKey: "NumCells")
        userDefaults.setObject(cellVolumes, forKey: "CellVolume")
        userDefaults.setObject(dates, forKey: "Dates")
        userDefaults.setObject(numSquares, forKey: "NumSquares")
        userDefaults.setObject(dilutionFactor, forKey: "DilutionFactorArray")
        userDefaults.setObject(counterArray, forKey: "CounterArray")
        userDefaults.synchronize()
    }
    
    @IBAction func ClearSample(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Caution", message: "Clear all previous samples?", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Clear", style: UIAlertActionStyle.Default) {
            UIAlertAction in self.ClearAll()
            
            })
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)

        
    }
    
}

