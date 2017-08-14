//
//  SampleViewController.swift
//  Hemocytometer Cell Counter
//
//  Created by Bryan Zhang on 8/1/16.
//  Copyright © 2016 Bryan Zhang. All rights reserved.
//

import UIKit
import AVFoundation

class SampleViewController: UIViewController, UITextFieldDelegate {

    var viaSegue = ""
    var numberOfSquares = 0
    var count = 0
    var DilutionFactorValue = 0.0
    var totalCells = 0.0
    var NeededCellsValue = 0.0
    var CellVolumeValue = 0.0
    var screenCount = 1
    var DilutionFactorDefault = 0.0
    var NeededCellsDefault = 0.0
    var CameFromFinishScreen = false
    var player = AVAudioPlayer()
    var indexAtEditedItem = 0
    var neededCellsSegue = ""
    var CellVolumeSegue = ""
    var DilutionFactorSegue = ""
    var CounterArraySegue = ""
    var CellCountSegue = ""
    var Date = ""
    var DateSegue = ""
    var x10 = ""
    
    var SampleNames: [NSString] = []
    var CellCounts: [NSString] = []
    var NumberCells: [NSString] = []
    var CellVolumes: [NSString] = []
    var Dates: [NSString] = []
    var NumSquares: [NSString] = []
    var DilutionFactorArray: [NSString] = []
    var CounterArray: [NSString] = []
    
    @IBOutlet weak var NextSampleButton: UIButton!
    @IBOutlet weak var SampleName: UITextField!
    @IBOutlet weak var DilutionFactor: UITextField!
    @IBOutlet weak var CountTextField: UITextField!
    @IBOutlet weak var NeededCells: UITextField!
    @IBOutlet weak var CellTotal: UILabel!
    @IBOutlet weak var CellVolume: UILabel!
    @IBOutlet weak var NumOfSquaresLabel: UILabel!
    
    @IBOutlet weak var x10E6: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SampleName.delegate = self
        DilutionFactor.delegate = self
        CountTextField.delegate = self
        NeededCells.delegate = self
        
        
        let font:UIFont? = UIFont(name: "Helvetica", size:13)
        let fontSuper:UIFont? = UIFont(name: "Helvetica", size:10)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: "  x 106" , attributes: [NSFontAttributeName:font!])
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:10], range: NSRange(location:6,length:1))
        x10E6.attributedText = attString 
        if (CameFromFinishScreen) {
            NumOfSquaresLabel.hidden = false
            NumOfSquaresLabel.text = "Number of Squares: " + String(numberOfSquares)
            SampleName.text = viaSegue
            DilutionFactor.text = DilutionFactorSegue
            CountTextField.text = CounterArraySegue
            NeededCells.text = neededCellsSegue
            if (DilutionFactorSegue != "") {
                
            DilutionFactorValue = Double(DilutionFactorSegue)!
            }
            if (CounterArraySegue != "") {
                count = Int(CounterArraySegue)!
            }
            if (neededCellsSegue != "") {
            NeededCellsValue = Double(neededCellsSegue)!
            }
            if (CellVolumeSegue != "") {
            CellVolumeValue = Double(CellVolumeSegue)!
            }
            if (CellCountSegue != "") {
                totalCells = Double(CellCountSegue)!
            }
            let font:UIFont? = UIFont(name: "Helvetica", size:13)
            let fontSuper:UIFont? = UIFont(name: "Helvetica", size:10)
            let Length: Int = String(format: "%.3f", totalCells).characters.count
            let attString:NSMutableAttributedString = NSMutableAttributedString(string: "Cell Concentration:      " + CellCountSegue + " x106 Cells/mL" , attributes: [NSFontAttributeName:font!])
            attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:10], range: NSRange(location:29 + Length,length:1))
            CellTotal.attributedText = attString

            //CellTotal.text = "Cell Concentration: " + CellCountSegue + " Cells/mL"
            CellVolume.text = "Volume of cells you needed:      " + CellVolumeSegue + " μL"
            NextSampleButton.hidden = true
            //CameFromFinishScreen = false
        } else {
            NumOfSquaresLabel.hidden = true
            NextSampleButton.hidden = false
        SampleName.text = String(screenCount)
        if (Int(SampleName.text!) > 1) {
            DilutionFactor.text = String(DilutionFactorDefault)
            DilutionFactorValue = DilutionFactorDefault
            NeededCells.text = String(NeededCellsDefault)
            NeededCellsValue = NeededCellsDefault
        }
            if (viaSegue == "") {
                viaSegue = "1"
            }
        numberOfSquares = Int(viaSegue)!
        
        
        }
        self.addDoneButtonOnKeyboard()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func music()
    {
        
        let url:NSURL = NSBundle.mainBundle().URLForResource("button-16", withExtension: "wav")!
        
        do
        {
            player = try AVAudioPlayer(contentsOfURL: url, fileTypeHint: nil)
        }
        catch let error as NSError { print(error.description) }
        player.volume = 0.1
        player.numberOfLoops = 1
        player.prepareToPlay()
        player.play()
        
    }
    
    func music1()
    {
        
        let url:NSURL = NSBundle.mainBundle().URLForResource("beep-08b", withExtension: "wav")!
        
        do
        {
            player = try AVAudioPlayer(contentsOfURL: url, fileTypeHint: nil)
        }
        catch let error as NSError { print(error.description) }
        player.volume = 0.1
        player.numberOfLoops = 1
        player.prepareToPlay()
        player.play()
        
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(SampleViewController.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.DilutionFactor.inputAccessoryView = doneToolbar
        self.NeededCells.inputAccessoryView = doneToolbar
        self.CountTextField.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        self.DilutionFactor.resignFirstResponder()
        self.NeededCells.resignFirstResponder()
        self.CountTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField == NeededCells && textField.text != "") {
            NeededCellsValue = Double(NeededCells.text!)!
            ComputeCellVolume()
        } else if (textField == DilutionFactor && textField.text != "") {
            DilutionFactorValue = Double(DilutionFactor.text!)!
            ComputeTotalCells()
            ComputeCellVolume()
        } else if (textField == CountTextField && textField.text != "") {
            count = Int(CountTextField.text!)!
            ComputeTotalCells()
        }
    }
    
    private func ComputeCellVolume() {
        CellVolumeValue = (NeededCellsValue * 1000) / (totalCells)
        CellVolume.text = "Volume of cells you needed:      " + String(format: "%.1f", CellVolumeValue) + " μL"
    }
    private func ComputeTotalCells() {
        totalCells = 10000 * Double(count) * DilutionFactorValue / (Double(numberOfSquares) * 1000000)
        let font:UIFont? = UIFont(name: "Helvetica", size:13)
        let fontSuper:UIFont? = UIFont(name: "Helvetica", size:10)
        let Length: Int = String(format: "%.3f", totalCells).characters.count
        
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: "Cell Concentration:      " + String(format: "%.3f", totalCells) + " x106 Cells/mL" , attributes: [NSFontAttributeName:font!])
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:10], range: NSRange(location:29 + Length,length:1))
        CellTotal.attributedText = attString
        
        //CellTotal.text = "Total Cells: " + String(format: "%.3f", totalCells) + " Cells x10E6/mL"
    }
    
    @IBAction func AddButton(sender: AnyObject) {
        music()
        count = count + 1
        CountTextField.text = String(count)
        ComputeTotalCells()
        ComputeCellVolume()
    }
    
    @IBAction func MinusButton(sender: AnyObject) {
        music1()
        if (count > 0) {
            count = count - 1
            CountTextField.text = String(count)
            ComputeTotalCells()
            ComputeCellVolume()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let dateString: String = dateFormatter.stringFromDate(date)
        
        let samples : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("CellNames")
        if (samples != nil) {
            SampleNames = samples as! [NSString]
        }
        let cellCounts : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("CellCount")
        if (cellCounts != nil) {
            CellCounts = cellCounts as! [NSString]
        }
        let numberCells : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("NumCells")
        if (numberCells != nil) {
            NumberCells = numberCells as! [NSString]
        }
        let cellVolumes : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("CellVolume")
        if (cellVolumes != nil) {
            CellVolumes = cellVolumes as! [NSString]
        }
        let dates : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("Dates")
        if (dates != nil) {
            Dates = dates as! [NSString]
        }
        let numSquares: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("NumSquares")
        if (numSquares != nil) {
            NumSquares = numSquares as! [NSString]
        }
        
        let dilutionFactorArray: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("DilutionFactorArray")
        if (dilutionFactorArray != nil) {
            DilutionFactorArray = dilutionFactorArray as! [NSString]
        }
        
        let counterArray: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("CounterArray")
        if (counterArray != nil) {
            CounterArray = numSquares as! [NSString]
        }
        
        
        if (CameFromFinishScreen) {
            let FinishScreen = segue.destinationViewController as! FinishScreenViewController
            SampleNames.removeAtIndex(indexAtEditedItem)
            SampleNames.insert(SampleName.text!, atIndex: indexAtEditedItem)
            CellCounts.removeAtIndex(indexAtEditedItem)
            CellCounts.insert(String(format: "%.3f", totalCells), atIndex: indexAtEditedItem)
            NumberCells.removeAtIndex(indexAtEditedItem)
            NumberCells.insert(NeededCells.text!, atIndex: indexAtEditedItem)
            Dates.removeAtIndex(indexAtEditedItem)
            Dates.insert(dateString, atIndex: indexAtEditedItem)
            CellVolumes.removeAtIndex(indexAtEditedItem)
            CellVolumes.insert(String(format: "%.1f", CellVolumeValue), atIndex: indexAtEditedItem)
            NumSquares.removeAtIndex(indexAtEditedItem)
            NumSquares.insert(String(numberOfSquares), atIndex: indexAtEditedItem)
            DilutionFactorArray.removeAtIndex(indexAtEditedItem)
            DilutionFactorArray.insert(DilutionFactor.text!, atIndex: indexAtEditedItem)
            CounterArray.removeAtIndex(indexAtEditedItem)
            CounterArray.insert(CountTextField.text!, atIndex: indexAtEditedItem)
            FinishScreen.CellNames = SampleNames
            FinishScreen.CellCount = CellCounts
            FinishScreen.NumCells = NumberCells
            FinishScreen.CellVolume = CellVolumes
            FinishScreen.Dates = Dates
            FinishScreen.NumSquares = NumSquares
            FinishScreen.DilutionFactorArray = DilutionFactorArray
            FinishScreen.CounterArray = CounterArray
            CameFromFinishScreen = false
        } else {
        
        if (segue.identifier == "NextSample") {
            let sampleVC = segue.destinationViewController as! SampleViewController
            sampleVC.viaSegue = viaSegue
            sampleVC.screenCount = screenCount + 1
            sampleVC.DilutionFactorDefault = DilutionFactorValue
            sampleVC.NeededCellsDefault = NeededCellsValue
            SampleNames.append(SampleName.text!)
            CellCounts.append("" + String(format: "%.3f", totalCells))
            NumberCells.append(NeededCells.text!)
            
            CellVolumes.append("" + String(format: "%.1f", CellVolumeValue))
            Dates.append(dateString)
            NumSquares.append(String(numberOfSquares))
            DilutionFactorArray.append(DilutionFactor.text!)
            CounterArray.append(CountTextField.text!)
            sampleVC.SampleNames = SampleNames
            sampleVC.CellCounts = CellCounts
            sampleVC.NumberCells = NumberCells
            sampleVC.CellVolumes = CellVolumes
            sampleVC.Dates = Dates
            sampleVC.NumSquares = NumSquares
            sampleVC.DilutionFactorArray = DilutionFactorArray
            sampleVC.CounterArray = CounterArray
            
        } else if (segue.identifier == "FinishScreen") {
            let finishScreen = segue.destinationViewController as! FinishScreenViewController
            
            
            
            SampleNames.append(SampleName.text!)
            CellCounts.append(String(format: "%.3f", totalCells))
            NumberCells.append(NeededCells.text!)
            CellVolumes.append(String(format: "%.1f", CellVolumeValue))
            Dates.append(dateString)
            NumSquares.append(String(numberOfSquares))
            DilutionFactorArray.append(DilutionFactor.text!)
            CounterArray.append(CountTextField.text!)
            finishScreen.CellNames = SampleNames
            finishScreen.CellCount = CellCounts
            finishScreen.NumCells = NumberCells
            finishScreen.CellVolume = CellVolumes
            finishScreen.Dates = Dates
            finishScreen.NumSquares = NumSquares
            finishScreen.DilutionFactorArray = DilutionFactorArray
            finishScreen.CounterArray = CounterArray
            
        }
        }
        /*SampleNames = []
        CellCounts = []
        NumberCells = []
        CellVolumes = []
        Dates = []*/
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(SampleNames, forKey:"CellNames")
        userDefaults.setObject(CellCounts, forKey: "CellCount")
        userDefaults.setObject(NumberCells, forKey: "NumCells")
        userDefaults.setObject(CellVolumes, forKey: "CellVolume")
        userDefaults.setObject(Dates, forKey: "Dates")
        userDefaults.setObject(NumSquares, forKey: "NumSquares")
        userDefaults.setObject(DilutionFactorArray, forKey: "DilutionFactorArray")
        userDefaults.setObject(CounterArray, forKey: "CounterArray")
        userDefaults.synchronize()
        
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
