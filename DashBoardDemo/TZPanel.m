//
//  TZPanel.m
//  DashBoardDemo
//
//  Created by Apple on 13-4-26.
//  Copyright (c) 2013年 XLDZ. All rights reserved.
//

#import "TZPanel.h"

@interface TZPanel (private)
- (CGFloat) parseToX:(CGFloat) radius Angle:(CGFloat)angle;
- (CGFloat) parseToY:(CGFloat) radius Angle:(CGFloat)angle;
- (CGFloat) transToRadian:(CGFloat)angel;
- (CGFloat) parseToAngle:(CGFloat) val;
- (CGFloat) parseToValue:(CGFloat) val;
- (void)setTextLabel:(NSInteger)labelNum;
- (void)setLineMark:(NSInteger)labelNum;
- (void) pointToAngle:(CGFloat) angle Duration:(CGFloat) duration;
@end

@implementation TZPanel

@synthesize gaugeView,pointer,context;
@synthesize labelArray;
@synthesize maxAngle,maxNumber,minAngle,minNumber,cellNumber,cellMarkNumber,panelText;
@synthesize labelNumber,decimalDigit,defaultSize;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

float factor = 1;
-(void)initVariables
{
    factor = self.defaultSize/300;
    scoleNum = self.defaultSize/self.frame.size.width;    
    maxNum = self.maxNumber;                         
    minNum = self.minNumber;                         
    minAngle = self.minAngle;                       
    maxAngle = self.maxAngle;                        
    gaugeValue = 0.0f;                               
    gaugeAngle = -self.maxAngle;                     
    angleperValue = (maxAngle - minAngle)/(maxNum - minNum); 
    
    gaugeView= [UIImage imageNamed:@"panelbackground.png"];

    UIImage *_pointer = [UIImage imageNamed:@"pointer.png"];
    pointer = [[UIImageView alloc] initWithImage:_pointer];
    pointer.layer.anchorPoint = CGPointMake(0.5, 0.78);
    
    CGPoint point = [self convertPoint:self.center fromView:[self superview]];
    pointer.center = point;
    
    
    pointer.transform = CGAffineTransformMakeScale(scoleNum*factor, scoleNum*factor);
    [self addSubview:pointer];

    [self setTextLabel:self.cellNumber];

    pointer.layer.transform = CATransform3DMakeRotation([self transToRadian:-self.maxAngle], 0, 0, 1);
    
}

-(void)setTextLabel:(NSInteger)labelNum
{
    labelArray = [NSMutableArray arrayWithCapacity:labelNum];
    CGPoint point = [self convertPoint:self.center fromView:[self superview]];
    
    CGFloat textDis = (maxNum - minNum)/labelNum;
    CGFloat angelDis = (maxAngle - minAngle)/labelNum;
    CGFloat radius = (point.x - 75)*scoleNum/factor;
    CGFloat currentAngle;
    CGFloat currentText = 0.0f;
    CGPoint centerPoint = point;
    
    for(int i=0;i<=labelNum;i++)
    {
        currentAngle = -30 + i * angelDis;
        currentText = minNum + i * textDis;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0 , 30*factor, 50*factor)];
        label.autoresizesSubviews = YES;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];

        if(i<labelNum/2){
            label.textAlignment = NSTextAlignmentLeft;
        }else if (i==labelNum/2){
            label.textAlignment = NSTextAlignmentCenter;
        }else{
            label.textAlignment = NSTextAlignmentRight;
        }
        label.text = [NSString stringWithFormat:@"%d",(int)currentText];
        label.center = CGPointMake(centerPoint.x-[self parseToX:radius Angle:currentAngle],centerPoint.y-[self parseToY:radius Angle:currentAngle]);
        
        [labelArray addObject:label];
        [self addSubview:label];
    }

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0 ,100, 40)];
    label.autoresizesSubviews = YES;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.panelText;
    label.center = CGPointMake(centerPoint.x,centerPoint.y*3/1.8);
    [self addSubview:label];
    [label release];
    
    self.labelNumber = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100*factor, 40*factor)] autorelease];
    labelNumber.textColor = [UIColor whiteColor];
    labelNumber.backgroundColor = [UIColor clearColor];
    labelNumber.textAlignment = NSTextAlignmentCenter;
    labelNumber.center = CGPointMake(centerPoint.x,centerPoint.y*3/2.0);
    labelNumber.text = @"0.0";
    [self addSubview:self.labelNumber];
    
}

-(void)setLineMark:(NSInteger)labelNum
{
    
    CGPoint point = [self convertPoint:self.center fromView:[self superview]];
    
    CGFloat angelDis = (maxAngle - minAngle)/labelNum;
    CGFloat radius = point.x;
    CGFloat currentAngle;
    
    
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    for(int i=0;i<=labelNum;i++)
    {
        currentAngle = -30 + i * angelDis ;

        CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8] CGColor]);

        if(i%5==0)
        {
            CGContextSetLineCap(context, kCGLineCapSquare);
            CGContextSetLineWidth(context, 3*factor);
            CGContextStrokePath(context);
            CGContextMoveToPoint(context,centerPoint.x-[self parseToX:radius-25*scoleNum*factor Angle:currentAngle], centerPoint.y-[self parseToY:radius-25*scoleNum*factor Angle:currentAngle]);
            CGContextAddLineToPoint(context,centerPoint.x-[self parseToX:radius-50*scoleNum*factor Angle:currentAngle], centerPoint.y-[self parseToY:radius-50*scoleNum*factor Angle:currentAngle]);
        }else{
            CGContextSetLineWidth(context, 2*factor);
            CGContextSetLineCap(context, kCGLineCapSquare);
            CGContextStrokePath(context);
            CGContextMoveToPoint(context,centerPoint.x-[self parseToX:radius-25*scoleNum*factor Angle:currentAngle], centerPoint.y-[self parseToY:radius-25*scoleNum*factor Angle:currentAngle]);
            CGContextAddLineToPoint(context,centerPoint.x-[self parseToX:radius-40*scoleNum*factor Angle:currentAngle], centerPoint.y-[self parseToY:radius-40*scoleNum*factor Angle:currentAngle]);
        }
    }
}

-(void)setGaugeValue:(CGFloat)value animation:(BOOL)isAnim
{
    CGFloat tempAngle = [self parseToAngle:value];
    gaugeValue = value;
    
    [self updateLabelText];

    if(isAnim){
        [self pointToAngle:tempAngle Duration:0.6f];
    }else
    {
        [self pointToAngle:tempAngle Duration:0.0f];
    }
}

-(void)updateLabelText
{
    NSString *formatString = @"%.";
    NSString *formatString1 = [NSString stringWithFormat:@"%d",self.decimalDigit];
    formatString = [formatString stringByAppendingString:formatString1];
    formatString = [formatString stringByAppendingString:@"f"];

    dispatch_async(dispatch_get_main_queue(), ^(void) {
        self.labelNumber.text = [NSString stringWithFormat:formatString,gaugeValue];
    });
}

- (void) pointToAngle:(CGFloat) angle Duration:(CGFloat) duration
{
    CAKeyframeAnimation *anim=[CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values=[NSMutableArray array];
    anim.duration = duration;
    anim.autoreverses = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion= YES;
    
    CGFloat distance = angle/10;

    int i = 1;
    for(;i<=10;i++){
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, [self transToRadian:(gaugeAngle+distance*i)], 0, 0, 1)]];
    }

    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, [self transToRadian:(gaugeAngle+distance*(i))], 0, 0, 1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, [self transToRadian:(gaugeAngle+distance*(i-2))], 0, 0, 1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, [self transToRadian:(gaugeAngle+distance*(i-1))], 0, 0, 1)]];
    
    anim.values=values; ;
    [pointer.layer addAnimation:anim forKey:@"cubeIn"];
    
    gaugeAngle = gaugeAngle+angle;
    
}

-(CGFloat)transToRadian:(CGFloat)angel
{
    return angel*M_PI/180;
}

- (CGFloat) parseToX:(CGFloat) radius Angle:(CGFloat)angle
{
    CGFloat tempRadian = [self transToRadian:angle];
    return radius*cos(tempRadian);
}


- (CGFloat) parseToY:(CGFloat) radius Angle:(CGFloat)angle
{
    CGFloat tempRadian = [self transToRadian:angle];
    return radius*sin(tempRadian);
}

-(CGFloat) parseToAngle:(CGFloat) val
{
	//异常的数据
	if(val<minNum){
		return minNum;
	}else if(val>maxNum){
		return maxNum;
	}
	CGFloat temp =(val-gaugeValue)*angleperValue;
	return temp;
}

-(CGFloat) parseToValue:(CGFloat) val
{
	CGFloat temp=val/angleperValue;
	CGFloat temp2=maxNum/2+temp;
	if(temp2>maxNum){
		return maxNum;
	}else if(temp2<maxNum){
		return maxNum;
	}
	return temp2;
}

- (void)drawRect:(CGRect)rect
{
    [self initVariables];

    context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context,self.backgroundColor.CGColor);
	CGContextFillRect(context, rect);

    [[self gaugeView] drawInRect:self.bounds];

    [self setLineMark:self.cellNumber*self.cellMarkNumber];
    
	CGContextStrokePath(context);
}

-(void)dealloc
{
    [super dealloc];
    [gaugeView release];
    [pointer release];
    [labelArray release];
    [panelText release];
    [labelNumber release];
}

@end
