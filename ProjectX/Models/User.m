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
    NSDictionary *defaultDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"firstName",@"",@"lastName",@"",@"username",@"", @"profileImage",@"", @"location",@[], @"preferences", @"", @"events", FIRAuth.auth.currentUser.uid,@"userID",  nil];
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
        [self setLastName:dictionary[@"lastName"]];
        [self setUsername:dictionary[@"username"]];
        [self setPreferences:dictionary[@"preferences"]];
        [self setLocation:dictionary[@"location"]];
        [self setProfileImageURL:dictionary[@"profileImage"]];
        [self setEvents:dictionary[@"events"]];
        [self setUserID:FIRAuth.auth.currentUser.uid];
        
    }
    return self;
}

-(void) composeMessage:(NSString *)text chat: (NSString *)event{
    FIRFirestore *db = [FIRFirestore firestore];
    FIRTimestamp *currentTime = [FIRTimestamp timestamp];
    // FIR
    
    __block FIRDocumentReference *ref = [[[[db collectionWithPath:@"Event"] documentWithPath:event] collectionWithPath:@"Chat"] addDocumentWithData:
  @{
    @"text": text,
    @"timeSent": currentTime,
    @"nameOfSender": self.username,
    @"userID": self.userID
    } completion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error adding document: %@", error);
        } else {
            NSLog(@"Document added with ID: %@", ref.documentID);
        }
        }];
    
}






@end
