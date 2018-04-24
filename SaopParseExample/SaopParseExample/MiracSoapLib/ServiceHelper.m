//
//  ServiceHandler.m
//  SoapParse
//
//  Created by mirac on 27/06/16.
//  Copyright © 2016 asis. All rights reserved.


#import "ModelMaster.h"
#import "ServiceParameter.h"

@implementation ServiceHelper {
    BOOL ExecuteIsCompleted;
    NSMutableData *WebData;
    NSMutableArray *AuthValueArray;
    
    NSString *mStartElement;
    NSString *mDictionaryKey;
    NSString *mDictionaryLastValue;
    
    NSMutableDictionary *mResultDictionary;
    NSMutableString *mStringBuilder;
    
    NSMutableArray *mSRLineCoordinateArray;
    NSMutableArray *mSRTimeArray;

    
    
    NSString *mResult;
    NSString *mDescription;
    
    NSTimer *mTimer;
    
    
}

@synthesize MethodName;
@synthesize ParameterArray;

@synthesize ServiceURL;
@synthesize Namespace;
@synthesize SoapAction;

@synthesize callback;

-(id)initWithName:(NSString *)MethdName
{
    self = [super init];
    
    @try {
        
        
        mSRLineCoordinateArray = nil;
        mSRLineCoordinateArray = [[NSMutableArray alloc] init];
        
        mSRTimeArray = nil;
        mSRTimeArray = [[NSMutableArray alloc] init];
        
        
        ParameterArray = nil;
        ParameterArray = [[NSMutableArray alloc] init];
        

        
        mResult = @"0";
        mDescription = @"";
        
        self.MethodName = MethdName;
        //    NSURL *sRequestURL = [NSURL URLWithString:@"http://blablabla.com/Service.svc?wsdl"];
        self.ServiceURL = @"http://blablabla.com/A/B/C/service.svc";
        self.Namespace = @"http://tempuri.org/";
        self.SoapAction = [NSString stringWithFormat:@"http://tempuri.org/IWCFAbys/%@", MethodName];
    }
    @catch (NSException *exception) {
        
    }
    
    if (self) {
        
        
    }
    return self;
}

-(void)AddParameter:(NSString *)ParameterName ParameterValue:(NSString *)ParameterValue {
    
    @try {
        
        if (ParameterArray != nil) {
            
            ServiceParameter *mServiceParameter = [ServiceParameter new];
            
            mServiceParameter.ParameterName = ParameterName;
            mServiceParameter.ParameterValue = ParameterValue;
            
            [ParameterArray addObject: mServiceParameter];
        }
    }
    @catch (NSException *exception) {
        
    }
}


- (IBAction)TimerTick:(id)sender {
    
    @try {
        
        if (ExecuteIsCompleted == NO) {
            
            // Servis çağrısı henüz cevaplanmamış. Zaman aşımı nedeniyle işlem sonlandırılıyor.
            
            ServiceResult *mServiceResult = [ServiceResult new];
            
            mServiceResult.MethodName = @"Timeout";
            
            mServiceResult.Result = @"-273";
            mServiceResult.Description = @"Timeout.";
            
            [self.callback OnTaskCompleted:mServiceResult];
            
            ExecuteIsCompleted = YES;
            
            [mTimer invalidate];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    
}




-(void)Execute {
    
    @try {
        
        NSMutableString *mSoapMessage = [[NSMutableString alloc] init];
        
        [mSoapMessage appendString: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
        [mSoapMessage appendString: @"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"];
        [mSoapMessage appendString: @"<soap:Body>"];
        [mSoapMessage appendString: [NSString stringWithFormat:@"<%@ xmlns=\"%@\">", self.MethodName, self.Namespace]];
        
        if (self.ParameterArray != nil) {
            
            if (self.ParameterArray.count > 0) {
                
                for (ServiceParameter *mServiceParameter in self.ParameterArray) {
                    
                    [mSoapMessage appendString: [NSString stringWithFormat:@"<%@>%@</%@>", mServiceParameter.ParameterName, mServiceParameter.ParameterValue, mServiceParameter.ParameterName]];
                }
            }
        }
        
        [mSoapMessage appendString: [NSString stringWithFormat: @"</%@>", self.MethodName]];
        [mSoapMessage appendString: @"</soap:Body>"];
        [mSoapMessage appendString: @"</soap:Envelope>"];
        
        NSString *mMessage = [NSString stringWithString:mSoapMessage];
        
        NSURL *sRequestURL = [NSURL URLWithString:[NSString stringWithFormat: @"%@?wsdl", self.ServiceURL]];
        NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
        NSString *sMessageLength = [NSString stringWithFormat:@"%lu", (unsigned long)[mMessage length]];
        
        [myRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [myRequest addValue: [NSString stringWithFormat: @"%@", self.SoapAction] forHTTPHeaderField:@"SOAPAction"];
        [myRequest addValue: sMessageLength forHTTPHeaderField:@"Content-Length"];
        [myRequest setHTTPMethod:@"POST"];
        [myRequest setHTTPBody: [mMessage dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:myRequest delegate:self];
        
        if( theConnection ) {
            WebData = [NSMutableData data];
        }else {
            NSLog(@"Some error occurred in Connection");
            
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [WebData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [WebData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"Connection error. Please try again");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"Received Bytes from Server: %lu", (unsigned long)[WebData length]);
    
    NSString *mXMLResponse = [[NSString alloc] initWithBytes:[WebData bytes] length:[WebData length] encoding:NSUTF8StringEncoding];
    NSData *mData = [mXMLResponse dataUsingEncoding:NSUTF8StringEncoding];
    [self parseXML:mData];
}

-(NSMutableArray *) parseXML:(NSData *)xmlData
{
    AuthValueArray = [NSMutableArray array];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    parser.delegate = self;
    [parser parse];
    
    return AuthValueArray;
}

-(void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
   attributes:(NSDictionary *)attributeDict {
    
    mStartElement = elementName;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([mStartElement isEqualToString: mDictionaryKey]) {
        
        NSString *mPreviousValue = mDictionaryLastValue;
        mStringBuilder = [[mPreviousValue stringByAppendingString:string] mutableCopy];
        [mResultDictionary setObject:mStringBuilder forKey:mStartElement];
        mDictionaryLastValue= string;
        
    } else {
        
        [mResultDictionary setObject:string forKey:mStartElement];
        mDictionaryLastValue = string;
        mDictionaryKey = mStartElement;
    }
}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    @try {

        
        if([self.MethodName isEqualToString: @"getREsponseTreeName"]){
            /**************************************************************************************/
            //Bayi Koordinatlari Listesi Result
            
//            Soap Metohod Name
            if([elementName isEqualToString:@"TestNethodName"]){
                
//                 like a tree in Response
            
                    TestObjectClass *mTestClass = [[TestObjectClass alloc] init];
                    
                    mTestClass.testString   = [mResultDictionary objectForKey:@"a:testObj"];
                    mTestClass.testString1  = [mResultDictionary objectForKey:@"a:testObj1"];
                    mTestClass.testString2  = [mResultDictionary objectForKey:@"a:testObj2"];
                    mTestClass.testString3  = [mResultDictionary objectForKey:@"a:testObj3"];
                    
                    [mSRTimeArray addObject:mTestClass];
                    
            }
            if([elementName isEqualToString:@"s:Envelope"]){
                
                ServiceResult *mServiceResult = [ServiceResult new];
                
                mServiceResult.MethodName = @"TestMethodName";
                
                mServiceResult.Description = @"items added in array.";
                mServiceResult.Result = @"Success";
                
                if (mSRTimeArray != nil) {
                    
                    if (mSRTimeArray.count > 0) {
                        
                        mServiceResult.mSRTimeArray = mSRTimeArray;
                    }
                }
                
                [self.callback OnTaskCompleted:mServiceResult];
            }
        }
        /**************************************************************************************/
        else if([self.MethodName isEqualToString: @"getCoordinatesMethodSoap"]){
            /**************************************************************************************/
            //getCoordinatesMethodSoap  Result
            
            if([elementName isEqualToString:@"Table1"]){
                TestObjectClass *mAnotherObject = [[TestObjectClass alloc] init];
                
                mAnotherObject.testString = [mResultDictionary objectForKey:@"responseName"]; //like a adress
                mAnotherObject.testString = [mResultDictionary objectForKey:@"responseName1"]; //like age "a:age or response name as "age ""
                mAnotherObject.testString = [mResultDictionary objectForKey:@"responseName2"];
                mAnotherObject.testString = [mResultDictionary objectForKey:@"responseName3"];

                
                
                [mSRLineCoordinateArray addObject:mAnotherObject];
                
            }
            if([elementName isEqualToString:@"s:Envelope"]){
                
                ServiceResult *mServiceResult = [ServiceResult new];
                
                mServiceResult.MethodName = @"getCoordinatesMethodSoap";
                
                mServiceResult.Description = @"items added in array.";
                mServiceResult.Result = @"Success";
                
                if (mSRLineCoordinateArray != nil) {
                    
                    if (mSRLineCoordinateArray.count > 0) {
                        
                        mServiceResult.SRLineCoordinateArray = mSRLineCoordinateArray;
                    }
                }
                
                [self.callback OnTaskCompleted:mServiceResult];
            }
        
        }
    }
    @catch (NSException *exception) {
        
    }
    
    
}
- (NSString *)StringValue:(NSString *)value StringSize:(NSInteger)count; {
    
    NSString *mResult = @"";
    
    if (value != nil) {
        
        if ([value length] < count) {
            
            for (int i = (int)[value length]; i < count; i++) {
                
                value = [NSString stringWithFormat:@"%@%@", value, @" "];
            }
        }
    }
    
    mResult = value;
    
    return  mResult;
}

@end
