//
//  User.m
//  ProjectX
//
//  Created by alexhl09 on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "User.h"

@implementation User


#pragma mark - User Initializer
-(instancetype) init
{
    NSDictionary *defaultDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"firstName",@"",@"lastName",@"",@"username",@"", @"profileImage",@"", @"location",@[], @"preferences" , nil];
    self = [self initWithDictionary:defaultDictionary];
    return self;
}

/**
 initWithDictonary
 
 This is going to get a dictionary and set all the properties of the class
 
 
 -Parameters:
    dictionary (NSDictionary *) This is the dictionary that we receive from the database
 */
-(instancetype) initWithDictionary: (NSDictionary *)  dictionary
{
    self = [super init];
    if(self)
    {
        [self setFirstName:dictionary[@"firstName"]];
        [self setLastName:dictionary[@"firstName"]];
        [self setUsername:dictionary[@"username"]];
        [self setPreferences:@[]];
        [self setLocation:dictionary[@"location"]];
        [self getImageFromString:dictionary[@"profileImage"]];
        
    }
    return self;
}

#pragma mark - Getter and setter
/**
 getImageFromString
 This method is going to get the real image from the string url that we receive from the database
 
 
 -Parameters:
 stringURL (NSString *) This is the string that is the url for the image
 */
-(void) getImageFromString : (NSString *) stringURL
{
    AFImageDownloader * downloader = [[AFImageDownloader alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringURL]];
    [downloader downloadImageForURLRequest:request success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
        
        self.profileImage = responseObject;
    }failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        self.profileImage = nil;
    }];
    
}


@end
