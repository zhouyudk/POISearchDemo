//
//  ZYCustomAnnotation.h
//  POISearchDemo
//
//  Created by XQ on 14-6-4.
//  Copyright (c) 2014年 XQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ZYCustomAnnotation : NSObject<MKAnnotation>

{
    NSString *annotationTitle;
    NSString *annotationSubTitle;
    CLLocationCoordinate2D annotationCoordinate;
}

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description;

//@property (nonatomic,strong) NSString *tag;

@property (nonatomic,strong) NSDictionary *infoDic;

@end
