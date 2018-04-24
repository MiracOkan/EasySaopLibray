//
//  ServiceHandler.h
//  SoapParse
//
//  Created by mirac on 27/06/16.
//  Copyright © 2016 asis. All rights reserved.




#import <Foundation/Foundation.h>
#import "ModelMaster.h"
#import "ServiceParameter.h"
#import "ServiceResultListener.h"

@interface ServiceHelper : NSObject <NSXMLParserDelegate> {

    NSString *MethodName;
    NSMutableArray *ParameterArray;
    
    NSString *ServiceURL;
    NSString *Namespace;
    NSString *SoapAction;
}

@property(nonatomic, retain) NSString *MethodName;
@property(nonatomic, retain) NSMutableArray *ParameterArray;

@property(nonatomic, retain) NSString *ServiceURL;
@property(nonatomic, retain) NSString *Namespace;
@property(nonatomic, retain) NSString *SoapAction;

@property(nonatomic, retain) IBOutlet id<ServiceResultListener> callback;

-(id)initWithName:(NSString *)MethdName;

-(void)AddParameter:(NSString *)ParameterName ParameterValue:(NSString *)ParameterValue;

-(void)Execute;






@end
