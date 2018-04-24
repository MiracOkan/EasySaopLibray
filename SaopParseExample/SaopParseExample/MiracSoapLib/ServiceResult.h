//
//  ServiceResult.h
//  SoapParse
//
//  Created by mirac on 27/06/16.
//  Copyright © 2016 asis. All rights reserved.


#import <Foundation/Foundation.h>

@interface ServiceResult : NSObject {

    NSString *MethodName;
    
    NSString *Result;
    NSString *Description;
    
    NSMutableArray *SRLineCoordinateArray;
    NSMutableArray *mSRTimeArray;

}

@property(nonatomic, retain) NSString *MethodName;

@property(nonatomic, retain) NSString *Result;
@property(nonatomic, retain) NSString *Description;

@property(nonatomic, retain) NSMutableArray *SRLineCoordinateArray;
@property(nonatomic, retain) NSMutableArray *mSRTimeArray;

@end
