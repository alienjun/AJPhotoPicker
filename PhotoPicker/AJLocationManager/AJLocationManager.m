//
//  AJLocationManager.m
//  locationDemo
//
//  Created by AlienJun on 14-9-21.
//  Copyright (c) 2014年 AlienJun. All rights reserved.
//
#import "AJLocationManager.h"

@interface AJLocationManager ()

@property (nonatomic, copy) LocationBlock locationBlock;
@property (nonatomic, copy) NSStringBlock cityBlock;
@property (nonatomic, copy) NSStringBlock addressBlock;
@property (nonatomic, copy) LocationErrorBlock errorBlock;
@property (strong, nonatomic) CLPlacemark *placeMark;
@end

@implementation AJLocationManager


+(AJLocationManager *)shareLocation
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        _locationManager=[[CLLocationManager alloc] init];
        _locationManager.delegate=self;
//        SEL requestSelector = NSSelectorFromString(@"requestWhenInUseAuthorization");
//        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined &&
//            [self.locationManager respondsToSelector:requestSelector]) {
//            [self.locationManager performSelector:requestSelector withObject:NULL];
//        }
        
    }
    return self;
}

-(void)dealloc{
    _locationManager.delegate=nil;
}


/**
 *  获取坐标
 *
 *  @param locaiontBlock locaiontBlock description
 */
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock
{
    self.locationBlock = locaiontBlock;
    [self startLocation];
}
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock Address:(NSStringBlock)addressBlock error:(LocationErrorBlock) errorBlock
{
    self.locationBlock = locaiontBlock;
    self.addressBlock = addressBlock;
    self.errorBlock = errorBlock;
    [self startLocation];
}
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock error:(LocationErrorBlock) errorBlock{
    self.locationBlock = locaiontBlock;
    self.errorBlock = errorBlock;
    [self startLocation];
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock
{
    self.locationBlock = locaiontBlock;
    self.addressBlock = addressBlock;
    [self startLocation];
}

- (void) getAddress:(NSStringBlock)addressBlock error:(LocationErrorBlock) errorBlock
{
    self.addressBlock = addressBlock;
    self.errorBlock = errorBlock;
    [self startLocation];
}

- (void) getCity:(NSStringBlock)cityBlock
{
    self.cityBlock = cityBlock;
    [self startLocation];
}

- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock
{
    self.cityBlock = cityBlock;
    self.errorBlock = errorBlock;
    [self startLocation];
}


-(void)startLocation
{
    //没开启权限
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
        if (_errorBlock) {
            _errorBlock(nil);
            _errorBlock = nil;
        }
        
        [self stopLocation];
    }else{
        [_locationManager startUpdatingLocation];
    }

}

-(void)stopLocation
{
    [_locationManager stopUpdatingLocation];
}


#pragma mark - CCLocationManagerDelegate
//当用户改变位置的时候，CLLocationManager回调的方法
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.lastCoordinate=newLocation.coordinate;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocationCoordinate2D myCoOrdinate=newLocation.coordinate;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:myCoOrdinate.latitude longitude:myCoOrdinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error)
         {
             NSLog(@"failed with error: %@", error);
             return;
         }
         if(placemarks.count > 0)
         {
             NSString *MyAddress = @"";
             NSString *city = @"";
             CLPlacemark * placemark=placemarks[0];
             if([placemark.addressDictionary objectForKey:@"FormattedAddressLines"] != NULL)
                 MyAddress = [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             else
                 MyAddress = @"Address Not founded";
             
             if([placemark.addressDictionary objectForKey:@"SubAdministrativeArea"] != NULL)
                 city = [placemark.addressDictionary objectForKey:@"SubAdministrativeArea"];
             else if([placemark.addressDictionary objectForKey:@"City"] != NULL)
                 city = [placemark.addressDictionary objectForKey:@"City"];
             else if([placemark.addressDictionary objectForKey:@"Country"] != NULL)
                 city = [placemark.addressDictionary objectForKey:@"Country"];
             else
                 city = @"City Not founded";
             
             self.lastCity = city;
             self.lastAddress=MyAddress;
         }
         
         [self stopLocation];
         
         if (_cityBlock) {
             _cityBlock(_lastCity);
             _cityBlock = nil;
         }
         
         if (_locationBlock) {
             _locationBlock(_lastCoordinate);
             _locationBlock = nil;
         }
         
         if (_addressBlock) {
             _addressBlock(_lastAddress);
             _addressBlock = nil;
         }
         
     }];

    
    
}


//当iPhone无法获得当前位置的信息时，所回调的方法是
-(void)locationManager: (CLLocationManager *)manager didFailLoadWithError:(NSError *)error
{
    if (_errorBlock) {
        _errorBlock(error);
        _errorBlock = nil;
    }
    
    [self stopLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:{
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [_locationManager requestWhenInUseAuthorization];
            }
        }
            break;
        default:{
            
        }
            break;
    }
}

- (void) getReverseGeocode
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocationCoordinate2D myCoOrdinate=self.lastCoordinate;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:myCoOrdinate.latitude longitude:myCoOrdinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error)
         {
             NSLog(@"failed with error: %@", error);
             return;
         }
         if(placemarks.count > 0)
         {
             NSString *MyAddress = @"";
             NSString *city = @"";
             CLPlacemark * placemark=placemarks[0];
             if([placemark.addressDictionary objectForKey:@"FormattedAddressLines"] != NULL)
                 MyAddress = [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             else
                 MyAddress = @"Address Not founded";
             
             if([placemark.addressDictionary objectForKey:@"SubAdministrativeArea"] != NULL)
                 city = [placemark.addressDictionary objectForKey:@"SubAdministrativeArea"];
             else if([placemark.addressDictionary objectForKey:@"City"] != NULL)
                 city = [placemark.addressDictionary objectForKey:@"City"];
             else if([placemark.addressDictionary objectForKey:@"Country"] != NULL)
                 city = [placemark.addressDictionary objectForKey:@"Country"];
             else
                 city = @"City Not founded";
             
             NSLog(@"%@",city);
             NSLog(@"%@", MyAddress);
             self.lastCity = city;
             self.lastAddress=MyAddress;
         }
         
         [self stopLocation];
     }];
    
}



@end
