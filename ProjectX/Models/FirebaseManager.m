//
//  FirebaseManager.m
//  ProjectX
//
//  Created by alexhl09 on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "FirebaseManager.h"

@implementation FirebaseManager



#pragma mark Singleton Methods

+ (id)sharedManager {
    static FirebaseManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        database = [FIRFirestore firestore];
    }
    return self;
}


- (void)dealloc {
    
}


#pragma mark - Get methods

- (void)getCurrentUser:(void(^)(User *user, NSError *error))completion
{
    
    FIRDocumentReference *docRef =
    [[database collectionWithPath:@"Users"] documentWithPath:@"DAhDAxEMoJNpOcjkaWe1cyevl9v2"];
    // [[database collectionWithPath:@"Users"] documentWithPath:[[[FIRAuth auth] currentUser] uid]];
    [docRef getDocumentWithCompletion:^(FIRDocumentSnapshot *snapshot, NSError *error) {
        if (snapshot.exists) {
            // Document data may be nil if the document exists but has no keys or values.
            User * newUser = [[User alloc] initWithDictionary:snapshot.data];
            completion(newUser, nil);
        } else {
            completion(nil, error);
        }
    }];
}




#pragma mark - Set methods


@end
