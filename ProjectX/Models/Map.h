//
//  Map.h
//  ProjectX
//
//  Created by aadhya on 7/23/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Map : NSObject <MKAnnotation> {
    NSString *title;
    NSString *placeName;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *placeName;
@property (nonatomic, assign)CLLocationCoordinate2D coordinate;

@end

NS_ASSUME_NONNULL_END
