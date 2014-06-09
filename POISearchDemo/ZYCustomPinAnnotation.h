//
//  ZYCustomPinAnnotation.h
//  POISearchDemo
//
//  Created by XQ on 14-6-7.
//  Copyright (c) 2014年 XQ. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ZYCustomPinAnnotation : NSObject<MKAnnotation>

{
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D annotationCoordinate;

}

@property (nonatomic,strong) NSDictionary *infoDic;

@property (nonatomic,strong) NSString *tag;


-(id)initWithCoordinates:(CLLocationCoordinate2D)location;

@end
