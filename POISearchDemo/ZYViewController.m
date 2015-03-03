//
//  ZYViewController.m
//  POISearchDemo
//
//  Created by XQ on 14-6-4.
//  Copyright (c) 2014年 XQ. All rights reserved.
//

#import "ZYViewController.h"
#import "ZYCustomAnnotation.h"
#import "ZYCalloutView.h"
#import "ZYCustomAnnotationView.h"
#import "ZYCustomPinAnnotation.h"


#define API_KEY @"1dd7a4fbf7fb1118acb47d79c16218f6"

@interface ZYViewController ()
{
    CLLocationCoordinate2D currentLocationCoordinate;
    //NSString *currentAddress;
    
    CLLocationCoordinate2D searchLocationCoordinate;
    NSMutableDictionary *POIResultDic;
    
    NSDictionary *calloutInfoDic;
    
    ZYCustomAnnotation *customAnnotation;
    
    NSString *currentLoc;
    //NSMutableArray *annotationArray;
    //便于删除subview时使用
    ZYPOIDetailView *detailView;
}

@end

@implementation ZYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:API_KEY Delegate:self];
    POIResultDic = [[NSMutableDictionary alloc] init];
    self.mapView_.showsUserLocation = YES;
    self.mapView_.showsPointsOfInterest =YES;
    
    
    float latitude = 32.061;
    float longitude = 118.79125;
    CLLocation *setLocation= [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [self mapView:_mapView_ didUpdateUserLocation:setLocation];
    //annotationArray = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------------mapview delegate-------------
//定位
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

    
    if (userLocation != nil)
    {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000);
        currentLocationCoordinate = userLocation.coordinate;
        [self.mapView_ setRegion:region animated:YES];
        [self searchReGeocode:userLocation.coordinate];
    }
}

#pragma mark ----------annotation delegate-------------

- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
//    NSLog(@"%@",[view.annotation class]);
    ZYCustomPinAnnotation *customAnno = (ZYCustomPinAnnotation*)view.annotation;
    
    
    if ([view.annotation isKindOfClass:[MKUserLocation class]])
    {
        searchLocationCoordinate = customAnno.coordinate;
        self.nameLable.text = currentLoc;
        //self.toolView.hidden = NO;
    }
    else if([view.annotation isKindOfClass:[ZYCustomPinAnnotation class]])
    {

        if (customAnnotation.coordinate.latitude == customAnno.coordinate.latitude&&
            customAnnotation.coordinate.longitude == customAnno.coordinate.longitude) {
            return;
        }
        //如果当前显示着calloutview，又触发了select方法，删除这个calloutview annotation
        if (customAnnotation) {
            [mapView removeAnnotation:customAnnotation];
            customAnnotation=nil;
            
        }

        NSString *key = customAnno.tag;
        AMapPOI *selectInfo = [POIResultDic valueForKey:key];
        calloutInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:selectInfo.name,@"name",selectInfo.address,@"address",selectInfo.tel,@"tel",selectInfo.type,@"type",nil];
        
        
        customAnnotation = [[ZYCustomAnnotation alloc] initWithCoordinates:customAnno.coordinate placeName:nil description:nil];
        customAnnotation.infoDic = calloutInfoDic;
        
        [self.mapView_ addAnnotation:customAnnotation];
        
        
        //toolview
        self.nameLable.text = [customAnnotation.infoDic valueForKey:@"name"];
        searchLocationCoordinate = customAnno.coordinate;
        //self.toolView.hidden = NO;
    }
    
    [self.mapView_ setCenterCoordinate:customAnno.coordinate animated:YES];

}

- (void) mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (customAnnotation&&![view isKindOfClass:[ZYCustomAnnotationView class]]) {
        
        if (customAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            customAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [mapView removeAnnotation:customAnnotation];
            customAnnotation = nil;
        }
        
        
    }

}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    else if ([annotation isKindOfClass:[ZYCustomPinAnnotation class]])
    {
        NSString *identifier = @"custompin";
        MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        pinAnnotation.canShowCallout = NO;
        pinAnnotation.animatesDrop = YES;
        
        //[annotationArray addObject:pinAnnotation];

        return pinAnnotation;
 
    }
    else if ([annotation isKindOfClass: [ZYCustomAnnotation class]])
    {
        
        static NSString *identifier = @"annotation";
        
        ZYCustomAnnotation *customAnno = (ZYCustomAnnotation*)annotation;
        
        ZYCustomAnnotationView *customAnnotationView = (ZYCustomAnnotationView*)[self.mapView_ dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!customAnnotationView)
        {
            customAnnotationView = [[ZYCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
            ZYCalloutView *calloutCell = [[[NSBundle mainBundle] loadNibNamed:@"ZYCalloutView" owner:self options:nil] objectAtIndex:0];
            
            [customAnnotationView.contentView addSubview:calloutCell];
            
            //customAnnotationView.callout = calloutCell;
        }
        customAnnotationView.callout.image_.image = [UIImage imageNamed:@"flk.jpg"];
        customAnnotationView.callout.titalLabel.text = [customAnno.infoDic objectForKey:@"name"];
        //customAnnotationView.callout.titalLabel.lineBreakMode = UILineBreak;
        
        return customAnnotationView;
    }
        
    return nil;
}

#pragma mark ------------regeocode search----------------
- (void)searchReGeocode:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    // regeoRequest.location = [AMapGeoPoint locationWithLatitude: longtitude:116.481476];
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeoRequest.radius = 1000;
    regeoRequest.requireExtension = YES;
    [self.search AMapReGoecodeSearch: regeoRequest];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    AMapReGeocode *regeocode_= response.regeocode;
    currentLoc = regeocode_.formattedAddress;
    self.nameLable.text =  regeocode_.formattedAddress;
    
    searchLocationCoordinate = currentLocationCoordinate;
}

#pragma mark --------geocode-----search--------
- (void)searchGeocode:(NSString *)address
{
    AMapGeocodeSearchRequest *geoRequest = [[AMapGeocodeSearchRequest alloc] init];
    geoRequest.searchType = AMapSearchType_Geocode;
    geoRequest.address = address;
    
    [self.search AMapGeocodeSearch:geoRequest];
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    AMapGeocode *geocode_ = response.geocodes.firstObject;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = geocode_.location.latitude;
    coordinate.longitude = geocode_.location.longitude;
    
    //    ZYAnnotation *annotation = [[ZYAnnotation alloc] initWithCoordinates:coordinate placeName:geocode_.formattedAddress description:geocode_.building];
    //    [self.mapView_ addAnnotation:annotation];
    
}


#pragma mark ---------places-----search--------
//关键字搜索
- (void)searchPlaceByKey:(NSString*)keywords city:(NSString*)address
{
    self.coverView.hidden = NO;
    [self.activitySearchView startAnimating];
    
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceKeyword;
    poiRequest.keywords = @"俏江南";
    poiRequest.city = @[@"beijing"];
    poiRequest.requireExtension = YES;
    [self.search AMapPlaceSearch: poiRequest];
}
//范围搜索
-(void)searchPlaceByAroundLocation:(CLLocationCoordinate2D)coordinate radius:(NSInteger)radius types:(NSArray*)types
{
    self.coverView.hidden = NO;
    [self.activitySearchView startAnimating];
    
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceAround;
    poiRequest.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    poiRequest.keywords = @"";
    poiRequest.radius = radius;
    poiRequest.types = types;
    [self.search AMapPlaceSearch:poiRequest];
}

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    self.coverView.hidden = YES;
    [self.activitySearchView stopAnimating];
    
    for (AMapPOI *p in response.pois)
    {
        [POIResultDic setObject:p forKey:p.uid];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = p.location.latitude;
        coordinate.longitude = p.location.longitude;
        
        //NSLog(@"%@", p.type);
        ZYCustomPinAnnotation *annotation = [[ZYCustomPinAnnotation alloc] initWithCoordinates:coordinate];
        annotation.tag = p.uid;
        
        
        [self.mapView_ addAnnotation:annotation];
    }
    
}
#pragma mark--------toolview button---------
//search around
- (IBAction)clickSearchButton:(id)sender
{
    UIActionSheet *searchSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Food",@"Hotel",@"Shop",@"BusStion", nil];
    searchSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    searchSheet.tag = 201;
    [searchSheet showInView:self.mapView_];
 
}
//route
- (IBAction)navigationClick:(id)sender
{
    //[POIResultDic removeAllObjects];
    //[self.mapView_ removeAnnotations:self.mapView_.annotations];
    UIActionSheet *routeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Walk",@"Drive",@"Bus", nil];
    routeSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    routeSheet.tag = 202;
    [routeSheet showInView:self.mapView_];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 201)
    {
        NSMutableArray *types;
        //NSLog(@"%i",buttonIndex);
        if (buttonIndex == 4)
        {
            return;
        }
        if (buttonIndex == 0)
        {
            types = [NSMutableArray arrayWithObjects:@"餐饮", nil];
        }
        if (buttonIndex == 1)
        {
            types = [NSMutableArray arrayWithObjects:@"住宿", nil];
        }
        if (buttonIndex == 2)
        {
            types = [NSMutableArray arrayWithObjects:@"购物", nil];
        }
        if (buttonIndex == 3)
        {
            types = [NSMutableArray arrayWithObjects:@"公交车站", nil];
        }
        [POIResultDic removeAllObjects];
        [self.mapView_ removeAnnotations:self.mapView_.annotations];
        
        [self searchPlaceByAroundLocation:searchLocationCoordinate radius:500 types:types];
    }
    if (actionSheet.tag == 202
        &&currentLocationCoordinate.latitude != searchLocationCoordinate.latitude
        &&currentLocationCoordinate.longitude != searchLocationCoordinate.longitude)
    {
        //NSLog(@"%i",buttonIndex);
        if (buttonIndex == 3)
        {
            return;
        }
        if (buttonIndex == 0)
        {
            [self searchNaviFootOrigin:currentLocationCoordinate destination:searchLocationCoordinate];
        }
        if (buttonIndex == 1)
        {
            [self searchNaviDriveOrigin:currentLocationCoordinate destination:searchLocationCoordinate];
        }
        if (buttonIndex == 2)
        {
            [self searchNaviBusOrigin:currentLocationCoordinate destination:searchLocationCoordinate];
        }
        
        //[POIResultDic removeAllObjects];
        [self.mapView_ removeOverlays:self.mapView_.overlays];
    }
}
//detail button
-(IBAction)clickDetailButton:(id)sender
{
    detailView = [[[NSBundle mainBundle] loadNibNamed:@"ZYPOIDetailView" owner:self options:nil] objectAtIndex:0];
    detailView.nameLabel.text = [calloutInfoDic valueForKey:@"name"];
    detailView.addrLabel.text = [calloutInfoDic valueForKey:@"address"];
    detailView.telLabel.text = [calloutInfoDic valueForKey:@"tel"];
    detailView.typeLabel.text = [calloutInfoDic valueForKey:@"type"];
    [detailView.backButton addTarget:self action:@selector(clickdetailBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView_ addSubview:detailView];
    _toolView.hidden = YES;
}
-(IBAction)clickdetailBackButton:(id)sender
{
    [detailView removeFromSuperview];
    _toolView.hidden = NO;
}


//导航
#pragma mark----------Navigation----------

-(void)searchNaviFootOrigin:(CLLocationCoordinate2D)origin destination:(CLLocationCoordinate2D)destination
{
    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
    naviRequest.searchType = AMapSearchType_NaviWalking;
    naviRequest.requireExtension = YES;
    naviRequest.origin = [AMapGeoPoint locationWithLatitude:origin.latitude longitude:origin.longitude];
    naviRequest.destination = [AMapGeoPoint locationWithLatitude:destination.latitude longitude:destination.longitude];
    [self.search AMapNavigationSearch: naviRequest];
    
}

- (void)searchNaviDriveOrigin:(CLLocationCoordinate2D)origin destination:(CLLocationCoordinate2D)destination
{
    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
    naviRequest.searchType = AMapSearchType_NaviDrive;
    naviRequest.requireExtension = YES;
    naviRequest.origin = [AMapGeoPoint locationWithLatitude:origin.latitude longitude:origin.longitude];
    naviRequest.destination = [AMapGeoPoint locationWithLatitude:destination.latitude longitude:destination.longitude];
    [self.search AMapNavigationSearch: naviRequest];
}

-(void)searchNaviBusOrigin:(CLLocationCoordinate2D)origin destination:(CLLocationCoordinate2D)destination
{
    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
    naviRequest.searchType = AMapSearchType_NaviBus;
    naviRequest.requireExtension = YES;
    naviRequest.origin = [AMapGeoPoint locationWithLatitude:origin.latitude longitude:origin.longitude];
    naviRequest.destination = [AMapGeoPoint locationWithLatitude:destination.latitude longitude:destination.longitude];
    [self.search AMapNavigationSearch: naviRequest];
    
}
//导航搜索结果
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response
{
    NSString *coordinateStr =@"";
    //获得第一条导航方案
    AMapPath *path1 = [response.route.paths objectAtIndex:0];
    //提取导航方案1中的路径 坐标点集合
    for (AMapStep *step in path1.steps)
    {
        NSString *str =  step.polyline;
        coordinateStr = [coordinateStr stringByAppendingString:str];
        //NSLog(@"%@",coordinateStr);
    }
    NSArray *coordinateArray = [coordinateStr componentsSeparatedByString:@";"];
    CLLocationCoordinate2D coordinates[coordinateArray.count];
    
    NSInteger i = 0;
    while (i < coordinateArray.count)
    {
        NSString *tmpStr = [coordinateArray objectAtIndex:i];
        NSArray *tmpArray = [tmpStr componentsSeparatedByString:@","];
        coordinates[i] = CLLocationCoordinate2DMake([[tmpArray objectAtIndex:1] floatValue], [[tmpArray objectAtIndex:0] floatValue]);
        NSLog(@"%ld",i);
        NSLog(@"%f,%f",coordinates[i].latitude, coordinates[i].longitude);
        i++;
    }
    MKPolyline *line = [MKPolyline polylineWithCoordinates:coordinates count:coordinateArray.count];
    NSLog(@"%ld",coordinateArray.count);
    
    [self.mapView_ addOverlay:line];
}

//画线的delegate方法
- (MKOverlayRenderer*)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer =[[MKPolylineRenderer alloc] initWithOverlay:overlay];
        //renderer.strokeColor  = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        renderer.strokeColor = [UIColor redColor];
        renderer.lineWidth = 2.0;
        return renderer;
    }
    return nil;
}
@end



















