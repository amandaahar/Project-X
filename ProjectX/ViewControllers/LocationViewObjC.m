//
//  LocationViewObjC.m
//  ProjectX
//
//  Created by aadhya on 8/6/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "LocationViewObjC.h"
@import Firebase;

@interface LocationViewObjC ()
@property (nonatomic, readwrite) FIRFirestore *db;

@end

@implementation LocationViewObjC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.db = [FIRFirestore firestore];
    [self getDocumentNearBy];
}

- (void)getDocumentNearBy {
    
    double latitude = 38.819;
    double longitude= -122.47;
    double distance= 10;
    float lat = 1.0144927536231884;
    float lon = 1.0181818181818182;
    
    float lowerLat = latitude - (lat * distance);
    float lowerLon = longitude - (lon * distance);
    float greaterLat = latitude + (lat * distance);
    float greaterLon = longitude + (lon * distance);
    FIRGeoPoint *lesserGeopoint = [[FIRGeoPoint alloc] initWithLatitude:lowerLat longitude:lowerLon];
    FIRGeoPoint *greaterGeopoint =  [[FIRGeoPoint alloc] initWithLatitude:greaterLat longitude:greaterLon];
    
    [[[[self.db collectionWithPath:@"Event"]
                    queryWhereField:@"location" isLessThan:greaterGeopoint]
                    queryWhereField:@"location" isGreaterThan:lesserGeopoint]
    getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
        if (error != nil) {
            NSLog(@"Error getting documents: %@", error);
        } else {
            for (FIRDocumentSnapshot *document in snapshot.documents) {
            NSLog(@"%@", document.data[@"name"]);
            }
        }
    }];
}

@end
