//
//  User.m
//  ProjectX
//
//  Created by alexhl09 on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "User.h"
#import "../Helpers/TranslatorManager.h"
@implementation User


#pragma mark - User Initializer
-(instancetype) init
{
    NSDictionary *defaultDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"firstName",@"",@"lastName",@"",@"username",@"", @"profileImage",@"", @"location",@[], @"preferences", @"", @"events", FIRAuth.auth.currentUser.uid,@"userID",@"", @"bio",@"en",@"lan",  nil];
    self = [self initWithDictionary:defaultDictionary];
    return self;
}

-(instancetype) initWithDictionary: (NSDictionary *)  dictionary
{
    self = [super init];
    if(self)
    {
        
        [self setFirstName:dictionary[@"firstName"]];
        [self setLastName:dictionary[@"lastName"]];
        [self setUsername:dictionary[@"username"]];
        [self setPreferences:dictionary[@"preferences"]];
        [self setProfileImageURL:dictionary[@"profileImage"]];
        [self setEvents:dictionary[@"events"]];
        [self setUserID:FIRAuth.auth.currentUser.uid];
        [self setBio:dictionary[@"bio"]];
        [self setLanguage:dictionary[@"lan"]];
        [self setFcm:dictionary[@"fcm"]];
    }
    return self;
}



-(void) composeMessage:(NSString *)text chat
                      : (NSString *)event
{
    if(![text isEqualToString:@""])
    {
        FIRFirestore *db = [FIRFirestore firestore];
        FIRTimestamp *currentTime = [FIRTimestamp timestamp];
        [[TranslatorManager sharedManager] detectLanguage:text completion:^(NSString * _Nonnull language, NSError * _Nonnull error) {
            if(error == nil)
            {
                __block FIRDocumentReference *ref = [[[[db collectionWithPath:@"Event"] documentWithPath:event] collectionWithPath:@"Chat"] addDocumentWithData:
                                                     @{
                                                       @"text": text,
                                                       @"timeSent": currentTime,
                                                       @"nameOfSender": self.username,
                                                       @"userID": self.userID,
                                                       @"likes" : @[],
                                                       @"lan" : language
                                                       } completion:^(NSError * _Nullable error) {
                                                           if (error != nil) {
                                                               NSLog(@"Error adding document: %@", error);
                                                           } else {
                                                               NSLog(@"Document added with ID: %@", ref.documentID);
                                                               [[FirebaseManager sharedManager] sendNotificationUsers:event withText:text nameUser:self.username];
                                                           }
                                                       }];
            }
        }];
    }
    
    
 
}

@end
