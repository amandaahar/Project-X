//
//  User.m
//  ProjectX
//
//  Created by alexhl09 on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "User.h"

@implementation User
@dynamic firstName;
@dynamic lastName;
@dynamic username;
@dynamic profileImage;
@dynamic preferences;
@dynamic location;

-(instancetype) init
{
    NSDictionary *defaultDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"firstName",@"",@"lastName",@"",@"username",@"", @"profileImage",@"", @"location",@[], @"preferences" , nil];
    self = [self initWithDictionary:defaultDictionary];
    return self;
}

/**
 initWithDictonary
 
 This is going to get a dictionary and set all the properties of the class
 */
-(instancetype) initWithDictionary: (NSDictionary *)  dictionary
{
    self = [super init];
    if(self)
    {
        self.firstName = dictionary[@"firstName"];
        self.lastName = dictionary[@"lastName"];
        self.username = dictionary[@"username"];
        self.preferences = @[];
        self.location = [[GeoFire alloc] init];
        [self getImageFromString:dictionary[@"profileImage"]];
        
    }
}

-(UIImage *) getImageFromString : (NSString *) stringURL
{
    AFImageDownloader * downloader = [[AFImageDownloader alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringURL]];
    [downloader downloadImageForURLRequest:request success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
        
        NSLog(@"Succes download image");
        self.profileImage = responseObject;
    }failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        NSLog(@"Error download image");
        self.profileImage = nil;
    }];
}


@end
