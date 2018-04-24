//
//  ServiceResultListener.h
//  SoapParse
//
//  Created by mirac on 27/06/16.
//  Copyright © 2016 asis. All rights reserved.


#import <Foundation/Foundation.h>
#import "ServiceResult.h"

@protocol ServiceResultListener <NSObject>

- (void) OnTaskCompleted:(ServiceResult *) serviceResult;

@end
