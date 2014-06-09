//
//  ZYCustomAnnotation.m
//  POISearchDemo
//
//  Created by XQ on 14-6-4.
//  Copyright (c) 2014年 XQ. All rights reserved.
//

#import "ZYCustomAnnotation.h"

@implementation ZYCustomAnnotation

-(id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description
{
    self = [super init];
    if (self != nil)
    {
        annotationCoordinate = location;
        annotationTitle = placeName;
        annotationSubTitle = description;
        
    }
    return self;
}

-(CLLocationCoordinate2D)coordinate;
{
    return annotationCoordinate;
}

-(NSString*) title
{
    return annotationTitle;
}
-(NSString*) subtitle
{
    return annotationSubTitle;
}

@end
