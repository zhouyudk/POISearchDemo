//
//  ZYCustomPinAnnotation.m
//  POISearchDemo
//
//  Created by XQ on 14-6-7.
//  Copyright (c) 2014年 XQ. All rights reserved.
//

#import "ZYCustomPinAnnotation.h"

@implementation ZYCustomPinAnnotation

-(id)initWithCoordinates:(CLLocationCoordinate2D)location
{
    self = [super init];
    if (self != nil)
    {
        annotationCoordinate = location;
        
    }
    return self;
}

-(CLLocationCoordinate2D)coordinate;
{
    return annotationCoordinate;
}

-(NSString*) title
{
    return @"test";
}
-(NSString*) subtitle
{
    return subtitle;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
