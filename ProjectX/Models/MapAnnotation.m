//
//  MapAnnotation.m
//  ProjectX
//
//  Created by alexhl09 on 7/25/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "MapAnnotation.h"
@import Contacts;

@implementation MapAnnotation

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTitle:@""];
        [self setLocationName:@""];
        [self setDiscipline:@""];
        [self setCoordinate:CLLocationCoordinate2DMake(37.77, -122.41)];
        
        
    }
    return self;
}

-(instancetype) initWithInfo : (NSString *) title : (NSString *) locatioName : ( NSString *) discipline : (CLLocationCoordinate2D) coordinates
{
    self = [super init];
    if (self)
    {
        [self setTitle: title];
        [self setLocationName:locatioName];
        [self setDiscipline:discipline];
        [self setCoordinate:coordinates];
    }
    return self;
}


-(MKMapItem *) mapItem{
   
    CNMutablePostalAddress * postalAddress = [[CNMutablePostalAddress alloc] init];
    postalAddress.street = [NSString stringWithFormat: @"%@", self.locationName];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate postalAddress: postalAddress];
    MKMapItem * mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:self.title];
    return mapItem;
}


@end
