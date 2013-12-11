//
//  TZViewController.h
//  DashBoardDemo
//
//  Created by Apple on 13-4-22.
//  Copyright (c) 2013年 XLDZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TZPanel;

@interface TZViewController : UIViewController
{
    NSTimer *timer;
}
@property (nonatomic,retain) TZPanel *panel1;
@property (nonatomic,retain) TZPanel *panel2;
@property (nonatomic,retain) TZPanel *panel3;
@property (nonatomic,retain) TZPanel *panel4;
@property (nonatomic,retain) TZPanel *panel5;
@property (retain, nonatomic) IBOutlet UILabel *aPressure;
@property (retain, nonatomic) IBOutlet UILabel *aElectric;
@property (retain, nonatomic) IBOutlet UILabel *aPower;
@property (retain, nonatomic) IBOutlet UILabel *aTemperature;
@end
