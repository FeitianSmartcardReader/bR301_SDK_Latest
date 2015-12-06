//
//  ViewController.swift
//  bR301_by_Swift
//
//  Created by 彭珊珊 on 15/11/30.
//  Copyright © 2015年 shanshan. All rights reserved.
//

import UIKit


class ViewController: UIViewController ,ReaderInterfaceDelegate ,UITextFieldDelegate {

    @IBOutlet var commandTextfield:UITextField?
    @IBOutlet var atrTextView:UITextView?
    @IBOutlet var logTextView:UITextView?
    
    @IBOutlet var connectButton:UIButton?
    @IBOutlet var disconnectButton:UIButton?
    @IBOutlet var sendDataButton:UIButton?
    
    var error:String = String()
    let communicateObject:communicationOperate = communicationOperate()
    let reader = ReaderInterface()
//    var commandListArray:[String] = ["0084000004","0084000008"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.init UI
        self.iTemInit()
        
        //2.set delegate for readerInterface
        reader.setDelegate(self)
        
        //3.create context
        communicateObject.createContext()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /**
     init UI Item
     */
    func iTemInit() {
        
        commandTextfield?.returnKeyType = UIReturnKeyType.Done
        commandTextfield?.delegate = self
        
        logTextView?.text = "reader did disconnected" + "\n"
        
        sendDataButton?.userInteractionEnabled = false
        commandTextfield?.userInteractionEnabled = false
        disconnectButton?.userInteractionEnabled = false
    }
    
    /**
     card Connect incident
     
     - parameter sender: UIButton
     */
    @IBAction func cardConnectTapped(sender:UIButton){
        
        var ATR:String = String()
        
        error = ""
        ATR =  communicateObject.connectCard(&error)
        
        print("error \(error) \(error.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))")
        
        if (error.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0)
        {
           atrTextView?.text = error
        }else{
            atrTextView?.text = "ATR:" + ATR
            sendDataButton?.userInteractionEnabled = true
            commandTextfield?.userInteractionEnabled  = true
            disconnectButton?.userInteractionEnabled = true
        }

    }
    
    /**
     card Disconnect incident
     
     - parameter sender: UIButton
     */
    @IBAction func cardDisconnectTapped(sender:UIButton){
        
        communicateObject.disconnectCard(error)
        atrTextView?.text = "Card Disconnected"
        logTextView?.text = ""
        
        commandTextfield?.userInteractionEnabled = false
        sendDataButton?.userInteractionEnabled = false
        disconnectButton?.userInteractionEnabled = false
    
    }
    
    /**
     get card Status incident
     
     - parameter sender: UIButton
     */
    @IBAction func getCardStatusTapped(sender:UIButton){
        
        var status:String = String()
        error = ""
        status = communicateObject.getCardStatus(error)
        if (error.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0){
            
            logTextView?.text = error + "\n"
            
        }else{
            
            logTextView?.text = status + "\n"
        }

    
    }
    
    /**
     get Reader Serial incident
     
     - parameter sender: UIButton
     */
    @IBAction func getReaderSerialTapped(sender:UIButton){
    
        var readerSerial:String = String()
        error = ""
        readerSerial = communicateObject.getReaderSerial(&error)
        if (error.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0){
            
            logTextView?.text = error + "\n"
            
        }else{
            
            logTextView?.text = readerSerial + "\n"
        }
    }
    
    /**
     send command
     
     - parameter sender: UIButton
     */
    @IBAction func sendCommandDataToReader(sender:UIButton){
    
        //1.judge the length of command data
        if ((commandTextfield?.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)) == 0){
            self.messageIndicate("Input Apdu first")
            return;
        }
        
        
        var command:String = String()
        command = (commandTextfield?.text)!
        var resultInfo:String = String()
        
        logTextView?.text = (logTextView?.text)! + "send:" + (commandTextfield?.text)! + "\n"
        
        //2.send command data
        error = ""
        resultInfo = communicateObject.sendData(command, error: &error)
        
        if (error.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0){
            
            logTextView?.text = (logTextView?.text)! + error + "\n"
            
        }else{
            
            logTextView?.text = (logTextView?.text)! + "rev:" + resultInfo + "\n"
        }
        
    }
    
    /**
      reader is Attach or DisAttach
     
     - parameter attached: void
     */
    func readerInterfaceDidChange(attached: Bool) {
        if attached
        {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.logTextView?.text = (self.logTextView?.text)! + "reader did  connected" + "\n"
            })
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.logTextView?.text = (self.logTextView?.text)! + "reader did  disconnected" + "\n"
            })
           
        }
        
    }
    
    
    /**
     card Attach or DisAttach
     
     - parameter attached: void
     */
    func cardInterfaceDidDetach(attached: Bool) {
        if attached
        {
        
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.logTextView?.text = (self.logTextView?.text)! + "card did  attached" + "\n"
                
            })
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.logTextView?.text = (self.logTextView?.text)! + "card did  disattached" + "\n"
                self.sendDataButton?.userInteractionEnabled = false
                self.commandTextfield?.userInteractionEnabled = false
            })
            
        }
        
    }
    
    /**
     info Indicate
     
     - parameter message: info
     */
    func messageIndicate(message:String)
    {
        let alertView = UIAlertView()
        alertView.title = ""
        alertView.message = message
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    /**
     UITextfield Delegate
     
     - parameter textField:
     
     - returns:
     */
    func textFieldShouldReturn(textField:UITextField) -> Bool
    {
        //hide keyboard
        commandTextfield?.resignFirstResponder()
        return true;
    }
}

