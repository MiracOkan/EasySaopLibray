//
//  ViewController.m
//  SaopParseExample
//
//  Created by Mirac Okan on 24.04.2018.
//  Copyright © 2018 Mirac Okan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property NSMutableArray * responseArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/******************************************************************************************************************************/
/******************************************SOAP PROCESSING**********************************************************************/
/******************************************************************************************************************************/

-(void)soapProcessing{ // you can use dynamic parameter  I used void method 
// Dont forget method name have to be same name in ServiceHelper Class
// and you can use example
    ServiceHelper *mServiceHelper = [[ServiceHelper alloc] initWithName:@"TestMethodName"];
    [mServiceHelper AddParameter:@"projectId" ParameterValue:@"3"];
    [mServiceHelper AddParameter:@"dbCode" ParameterValue:@"DB12"];
    [mServiceHelper AddParameter:@"valNo" ParameterValue: @"mValNo"];
    [mServiceHelper Execute];
    mServiceHelper.callback = self;
}


-(void) OnTaskCompleted:(ServiceResult *) serviceResult {
    if ([serviceResult.MethodName isEqualToString:@"TestMethodName"]) {

        if (serviceResult.SRLineCoordinateArray != nil) {
            if (serviceResult.SRLineCoordinateArray > 0) {
                //                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                BOOL IsOk = NO;
                self.responseArray = serviceResult.SRLineCoordinateArray;
                if (self.responseArray != nil) {
                    if (self.responseArray.count > 0) {
                        IsOk = YES;



                    }
                }
//                [self.tableView reloadData];


                if (IsOk == NO) {

                    NSLog(@"Alert");
                }
                //                });
            }
        }
    }
    else{

        NSLog(@"Response not found");
    }
}

/******************************************************************************************************************************
******************************************SOAP PROCESSING**********************************************************************
******************************************************************************************************************************/



@end
