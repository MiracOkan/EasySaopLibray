 //
 //  ServiceHelper.swift
 //  SoapParseLibSwift
 //
 //  Created by Asis on 16/10/2017.
 //  Copyright © 2017 Mirac. All rights reserved.
 //
 
 import UIKit
 
 class ServiceHelper: NSObject,XMLParserDelegate {
    
    var methodName                      = ""
    var serviceURL                      = ""
    var namespace                       = ""
    var soapAction                      = ""
    var mResult                         = ""
    var mDescription                    = ""
    var lastDictionaryValue : String    = ""
    var appendNewString : String        = ""
    var dictionaryKey : String          = ""
    var starterElement : NSString       = ""
    weak var callback: ServiceResultListener!
    
    var ExecuteIsCompleted = false
    var WebData: NSMutableData = NSMutableData()
    var WebData2  = NSMutableData()
    //    var mutableData : NSMutableData  = NSMutableData()
    var mResultDictionary = NSMutableDictionary()
    var mSRSmartStationRemaingTimeArray = NSMutableArray()
    
    var parameterArray                = NSMutableArray()
    var mSRLineCoordinateArray        = NSMutableArray()
    var mSRTimeArray                  = NSMutableArray()
    var AuthValueArray                = NSMutableArray()

    
    var mTimer: Timer?
    
    
    init (MethdName: String) {
        super.init()
        self.mSRSmartStationRemaingTimeArray  = NSMutableArray()
        
        self.parameterArray              = NSMutableArray()
        self.mSRLineCoordinateArray      = NSMutableArray()
        self.mSRTimeArray                = NSMutableArray()

        mResult      = ""
        mDescription = ""
        
        self.methodName = MethdName
        self.serviceURL = "http://blablabla.com/A/B/service.svc"
//        self.serviceURL = "http://blablabla.com/A/B/service.wsdl"
        self.namespace  = "http://tempuri.org/"
        self.soapAction = String(format:"http://tempuri.org/IWCFAbys/%@",methodName)
        
        
    }
    
    func addParameter(_ ParameterName: String, parameterValue ParameterValue: String) {
        if parameterArray != nil {
            let mServiceParameter : ServiceParameter = ServiceParameter()
            mServiceParameter.ParameterName = ParameterName
            mServiceParameter.ParameterValue = ParameterValue
            
            parameterArray.add(mServiceParameter)
            
        }
    }
    
    func TimerTick(){
        
        if (ExecuteIsCompleted == false){
            
            let mServiceResult : ServiceResult = ServiceResult()
            
            mServiceResult.MethodName = "Timeout"
            mServiceResult.Result = "-273"
            mServiceResult.Description = "Timeout"
            self.callback.OnTaskCompleted(serviceResult: mServiceResult)
            ExecuteIsCompleted = true
            mTimer?.invalidate()
        }
        
    }
    
    func execute() {
        
        let soapMessage : NSMutableString = ""
        soapMessage.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>")
        soapMessage.append("<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">")
        soapMessage.append("<soap:Body>")
        soapMessage.append(String(format:"<%@ xmlns=\"%@\">",self.methodName,self.namespace))
        
        if self.parameterArray != nil  {
            
            if self.parameterArray.count > 0{
                for mServiceParam in (parameterArray as NSArray as! [ServiceParameter])  {
                    
                    soapMessage.append(String(format:"<%@>%@</%@>",mServiceParam.ParameterName, mServiceParam.ParameterValue,mServiceParam.ParameterName))
                    //                    let mm: String = soapMessage as String!
                    //                    print(mm)
                }
            }
        }
        soapMessage.append(String(format:"</%@>",methodName))
        soapMessage.append("</soap:Body>")
        soapMessage.append("</soap:Envelope>")
        
        let mMessage: String = soapMessage as String!
        print(mMessage)
        
        let sRequestURL = URL(string : String(format: "%@?wsdl",serviceURL))
        let myRequest = NSMutableURLRequest(url: sRequestURL!)
        //        let sMessageLenght = String(format:"%lu",mMessage.characters.count)
        let sMessageLenght = mMessage.characters.count
        
        myRequest.httpBody = mMessage.data(using: String.Encoding.utf8,allowLossyConversion: false) // or false
        myRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        myRequest.addValue("\(soapAction)", forHTTPHeaderField: "SOAPAction")
        myRequest.addValue(String(sMessageLenght), forHTTPHeaderField: "Content-Length")
        myRequest.httpMethod = "POST"
        
        
        
        let connection = NSURLConnection(request: myRequest as URLRequest, delegate: self, startImmediately: true)!
        connection.start()
        if connection as NSURLConnection? != nil {
            //                WebData = [NSMutableData data];
            
            let WebData : Void = NSMutableData.initialize()
            print(WebData)
            
            //            WebData = Data() as? WebData ?? WebData
            //            WebData = NSMutableData()
            //            WebData = Data() as! NSMutableData    // Burası düzenlenecek
            //            WebData : Void  = NSMutableData.initialize()
        }
        else {
            print("Connection Problem")
        }
    }
    
    
    
    
    //    func connection(_ connection: NSURLConnection!, didReceiveResponse response: URLResponse!) {
    //        WebData.length = 0
    //    }
    //    func connection(_ connection: NSURLConnection!, didReceive data: Data!) {
    //        WebData.append(data)
    //    }
    //
    //    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
    //        print("Connection error. Please try again")
    //    }
    func connection(_ connection: NSURLConnection!, didReceiveResponse response: URLResponse!) {
        WebData.length = 0;
    }
    func connection(_ connection: NSURLConnection, didReceive challenge: URLAuthenticationChallenge) {
        print(WebData.length)
    }
    
    
    func connection(_ connection: NSURLConnection!, didReceiveData data: Data!) {
        WebData.append(data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection!) {
        
        print (WebData.length)
        let mXMLResponse = NSString.init(bytes: WebData.bytes, length: WebData.length, encoding:String.Encoding.utf8.rawValue)
        let mData = mXMLResponse?.data(using: String.Encoding.utf8.rawValue)
        self.parseXML(xmlData: mData!)
    }
    
    func parseXML(xmlData: Data) -> NSMutableArray{
        let parser = XMLParser.init(data: xmlData)
        parser.delegate = self
        parser.parse()
        return AuthValueArray
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        starterElement = elementName as NSString
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if(starterElement .isEqual(to: self.dictionaryKey)){
            let ondekiString = self.lastDictionaryValue
            appendNewString = (ondekiString + string) //mutablecopy
            mResultDictionary.setObject(appendNewString, forKey: self.starterElement)
            self.lastDictionaryValue = string;
            
        }
        else {
            mResultDictionary.setObject(string, forKey: self.starterElement)
            self.lastDictionaryValue = string
            self.dictionaryKey = (self.starterElement as NSString) as String;
            
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        starterElement = elementName as NSString
        if ((methodName as NSString) .isEqual(to:"TestSoapMethod"))
        {
            if (starterElement .isEqual(to:"a:LineCoordinate")) {
                mResult = "1"
                mDescription = "Success"
                let mLatitude  : String  = mResultDictionary.object(forKey: "a:Latitude") as! String
                let mLongitude : String  = mResultDictionary.object(forKey: "a:Longitude") as! String
                if (mLatitude != "" && mLongitude != "" ){
                    
                    let mSRLine : LineObject = LineObject()
                    mSRLine.Latitute = mLatitude
                    mSRLine.Longitude = mLongitude
                    mSRLineCoordinateArray.add(mSRLine)
                }
            }
            if (starterElement .isEqual(to:"s:Envelope")){
                let mServiceResult : ServiceResult = ServiceResult()
                mServiceResult.MethodName = "TestSoapMethod"
                mServiceResult.Result = mResult
                mServiceResult.Description = mDescription
                if(mSRLineCoordinateArray.count != 0){
                    if(mSRLineCoordinateArray.count > 0){
                        mServiceResult.SRLineCoordinateArray = mSRLineCoordinateArray
                    }
                }
                self.callback.OnTaskCompleted(serviceResult: mServiceResult)
                
            }
            /**************************************************************************************/
            
        }

        else if (methodName as NSString).isEqual(to: "SoapTestMethod2"){
            /**************************************************************************************/
            /* CreateSessionMobileV2 Result */
            if(starterElement.isEqual(to:"a:SRSession")){
                let mSRSession : SessionClass = SessionClass()
                mSRSession.IsAlive     = (mResultDictionary.object(forKey: "a:isAlive")      as! String ).trimmingCharacters(in: CharacterSet.whitespaces)
                mSRSession.SessionId   = (mResultDictionary.object(forKey: "a:session_id")   as! String ).trimmingCharacters(in: CharacterSet.whitespaces)
                mSRSession.VersionCode = (mResultDictionary.object(forKey: "a:version_code") as! String ).trimmingCharacters(in: CharacterSet.whitespaces)
                
                mSRTimeArray.add(mSRSession)
            }
            if (starterElement .isEqual(to:"s:Envelope")){
                let mServiceResult : ServiceResult = ServiceResult()
                mServiceResult.MethodName = "SoapTestMethod2"
                mServiceResult.Result = mResult
                mServiceResult.Description = mDescription
                if(mSRTimeArray.count != 0){
                    if(mSRTimeArray.count > 0){
                        mServiceResult.SRTimerArray = mSRTimeArray;
                    }
                }
                if ExecuteIsCompleted == false {
                    ExecuteIsCompleted = true
                    mTimer?.invalidate()
                    self.callback.OnTaskCompleted(serviceResult: mServiceResult)
                }
                
            }
            /**************************************************************************************/
        }
        
    }
    
 }
 
