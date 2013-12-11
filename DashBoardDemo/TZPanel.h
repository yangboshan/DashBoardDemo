//
//  TZPanel.h
//  DashBoardDemo
//
//  Created by Apple on 13-4-26.
//  Copyright (c) 2013年 XLDZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface TZPanel : UIView
{
    UIImage *gaugeView;
    UIImageView *pointer;
    
    CGFloat maxNum;
    CGFloat minNum;
    
    CGFloat maxAngle;
    CGFloat minAngle;
    
    CGFloat gaugeValue;
    CGFloat gaugeAngle;
    
    CGFloat angleperValue;
    CGFloat scoleNum;
    
    NSMutableArray *labelArray;
    CGContextRef context;
}

@property (nonatomic,assign) float maxAngle;
@property (nonatomic,assign) float minAngle;
@property (nonatomic,assign) float maxNumber;
@property (nonatomic,assign) float minNumber;
@property (nonatomic,retain) NSString *panelText;
@property (nonatomic,assign) float defaultSize;
@property (nonatomic,assign) NSInteger cellNumber;
@property (nonatomic,assign) NSInteger cellMarkNumber;


@property (nonatomic,retain) UILabel *labelNumber;
@property (nonatomic,assign) NSInteger decimalDigit;

@property (nonatomic,retain) UIImage *gaugeView;
@property (nonatomic,retain) UIImageView *pointer;
@property (nonatomic,retain) NSMutableArray *labelArray;
@property (nonatomic) CGContextRef context;
-(void)setGaugeValue:(CGFloat)value animation:(BOOL)isAnim;

@end
