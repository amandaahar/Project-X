//
//  MapAnnotation.h
//  ProjectX
//
//  Created by alexhl09 on 7/25/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;
NS_ASSUME_NONNULL_BEGIN

@interface MapAnnotation : NSObject <MKAnnotation>
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString * locationName;
@property (strong, nonatomic) NSString *discipline;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

-(instancetype) initWithInfo : (NSString *) title : (NSString *) locatioName : ( NSString *) discipline : (CLLocationCoordinate2D) coordinates;
-(MKMapItem *) mapItem;
@end

NS_ASSUME_NONNULL_END
