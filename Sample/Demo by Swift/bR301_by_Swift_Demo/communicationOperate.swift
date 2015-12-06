//
//  communicationOperate.swift
//  bR301_by_Swift
//
//  Created by 彭珊珊 on 15/11/30.
//  Copyright © 2015年 shanshan. All rights reserved.
//

class communicationOperate: NSObject {

    var gContext :SCARDCONTEXT = 0
    var gCard :SCARDHANDLE = 0
    var iRet :LONG = -1
    
    /**
     SCardEstablishContext
     */
    func createContext()
    {
        let dwScope:UInt32 = UInt32(SCARD_SCOPE_SYSTEM)
        
        SCardEstablishContext(dwScope,nil,nil,&gContext);
        
        return;
    
    }

    /**
     connect card and get card ATR
     
     - parameter error: error information
     
     - returns: ATR
     */
    func connectCard(inout error : String)->String
    {
        var  dwActiveProtocol:DWORD = 0
        var mszReaders = UnsafeMutablePointer<Int8>.alloc(128)
        var dwReaders:DWORD = 128
        let atrData:NSMutableData = NSMutableData()
        
        
        //1.init indicator
        mszReaders.initialize(0)
        iRet = SCardListReaders(gContext,nil ,mszReaders,&dwReaders)
        if(iRet != SCARD_S_SUCCESS)
        {
            error = "SCardListReaders error \(iRet)"
            
        }else{
        
            let dwShareMode:UInt32 = UInt32(SCARD_SHARE_SHARED)
            let dwPreferredProtocols:UInt32 = UInt32(SCARD_PROTOCOL_T0 | SCARD_PROTOCOL_T1)
            
            iRet = SCardConnect(gContext,mszReaders,dwShareMode,dwPreferredProtocols,&gCard,&dwActiveProtocol);
            if (iRet != SCARD_S_SUCCESS) {
                 error =  "SCardConnect error \(iRet)"
            }else{
        
                var patr = UnsafeMutablePointer<UInt8>.alloc(33)
                var atrLen : DWORD = 33
                
                
                patr.initialize(0)
                iRet = SCardGetAttrib(gCard,0, patr, &atrLen)
                if(iRet != SCARD_S_SUCCESS)
                {
                     error = "SCardGetAttrib error \(iRet)"
                }else{
                
                    atrData.appendBytes(patr, length:Int(atrLen))
                    
                    patr.destroy()
                    patr.dealloc(33)
                    patr = nil
                }
            }
        }
        
        mszReaders.destroy()
        mszReaders.dealloc(128)
        mszReaders = nil
        
        return "\(atrData)"
    }

     /**
     send APDU command to reader
     
     - parameter commandString: apdu command string
     - parameter error:         error information
     
     - returns: return data
     */
    func sendData(commandString:String, inout error:String ) ->String
    {
    
        if commandString.isEmpty
        {
            //need handle on this area
            
            return "empty";
        }
        
        let capdulen:UInt32 = UInt32(commandString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        
        var capdu = UnsafeMutablePointer<UInt8>.alloc(512)
        var resp = UnsafeMutablePointer<UInt8>.alloc(512)
        var resplen:UInt32 = 512
    
        var command:String = String()
        command = commandString.stringByAppendingString("\n")

        print("commandString is \(command)")
        
        var src = UnsafeMutablePointer<Int8>.alloc(512)
        src.initialize(0)
        src = UnsafeMutablePointer((command as NSString).UTF8String)
        
        StrToHex(capdu,src, capdulen/2)
        
       
        
        let respData:NSMutableData = NSMutableData()
        var pioSendPci = UnsafeMutablePointer<SCARD_IO_REQUEST>.alloc(1)
        
        iRet=SCardTransmit(gCard,pioSendPci,capdu, capdulen/2,nil,resp, &resplen);
        if (iRet != 0) {
            
            error = " SCardTransmit error \(iRet)"
            
        } else {
            
//            respData.appendBytes(resp, length:Int(resplen - 2))
            //display all return data include status words
            respData.appendBytes(resp, length:Int(resplen));
            
            print("resp:\(respData)") //ok

        }
        
       
        
        pioSendPci.destroy()
        pioSendPci.dealloc(1)
        pioSendPci = nil
        
        capdu.destroy()
        capdu.dealloc(512)
        capdu = nil
        
        resp.destroy()
        resp.dealloc(512)
        resp = nil
        
        return "\(respData)"
    }
    
    /**
     disconnect card
     
     - parameter error: error information
     */
    func disconnectCard(error:String)
    {
       let dwDisposition:UInt32 = UInt32(SCARD_UNPOWER_CARD)
        iRet = SCardDisconnect(gCard,dwDisposition);
        if (iRet != SCARD_S_SUCCESS) {
            print("SCardDisconnect error \(iRet)")
        }

    
    }
    
    /**
     get card status
     
     - parameter error: error information
     
     - returns: card status info
     */
    func getCardStatus(var error:String) -> String
    {
        
        var dwState : DWORD = 0
     
        iRet = SCardStatus(gContext, nil , nil , &dwState, nil , nil ,  nil );
        if (iRet != 0) {
           error = "SCardStatus error \(iRet)"
        }
        var statusString:String = String()
        switch (dwState) {
        case UInt32(SCARD_ABSENT):
            statusString = "The card has absent.";
            break;
        case UInt32(SCARD_PRESENT):
            statusString = "The card has present.";
            break;
        case UInt32(SCARD_SWALLOWED):
            statusString = "The Card not powered.";
            break;
            
        default:
            break;
        }
        
        return  statusString;
    }
    
    /**
     get reader serialNumber
     
     - parameter error: error information
     
     - returns: reader serialNumber
     */
    func getReaderSerial(inout error:String) -> String
    {
        
        let serialBuffer = UnsafeMutablePointer<Int8>.alloc(20)
        var serialLength : DWORD = 20
        let serialData:NSMutableData = NSMutableData()
        
        serialBuffer.initialize(0)
        iRet = FtGetSerialNum(0,&serialLength, serialBuffer);
        
        if(iRet != 0 ){
            error = "Get serial number error \(iRet).";
        }else {

            serialData.appendBytes(serialBuffer, length:Int(serialLength - 2))
            print("resp:\(serialData)") //ok
        }
        
        return "\(serialData)"
    }
    
}
