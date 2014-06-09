//
//  ZYViewController.h
//  POISearchDemo
//
//  Created by XQ on 14-6-4.
//  Copyright (c) 2014年 XQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>


@interface ZYViewController : UIViewController<AMapSearchDelegate,MKMapViewDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) AMapSearchAPI *search;

#pragma mark -------UI----------
@property (nonatomic,weak) IBOutlet MKMapView *mapView_;

@property (nonatomic,weak) IBOutlet UIView *toolView;
@property (nonatomic,weak) IBOutlet UILabel *nameLable;
@property (nonatomic,weak) IBOutlet UIButton *searchAroundButton;

@property (nonatomic,weak) IBOutlet UIActivityIndicatorView *activitySearchView;
@property (nonatomic,weak) IBOutlet UIView *coverView;

@end
