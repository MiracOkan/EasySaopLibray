//
//  ServiceParameter.h
//  SoapParse
//
//  Created by mirac on 27/06/16.
//  Copyright © 2016 asis. All rights reserved.


#import <Foundation/Foundation.h>

@interface ServiceParameter : NSObject {

    NSString *ParameterName;
    NSString *ParameterValue;

}

@property(nonatomic, retain) NSString *ParameterName;
@property(nonatomic, retain) NSString *ParameterValue;

@end
