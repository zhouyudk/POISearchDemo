//
//  ZYCustomAnnotationView.h
//  POISearchDemo
//
//  Created by XQ on 14-6-5.
//  Copyright (c) 2014年 XQ. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ZYCalloutView.h"

@interface ZYCustomAnnotationView : MKAnnotationView


@property(nonatomic,retain) UIView *contentView;


//添加一个UIView
@property(nonatomic,retain) ZYCalloutView *callout;//在创建calloutView Annotation时，把contentView add的 subview赋值给businfoView

@end
