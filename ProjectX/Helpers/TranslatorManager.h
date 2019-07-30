//
//  TranslatorManager.h
//  ProjectX
//
//  Created by alexhl09 on 7/26/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TranslatorManager : NSObject

+ (id)sharedManager;
- (void) translateTextInLanguage:(NSString *) sourceLanguage
                                : (NSString *) targetLanguage
                                : (NSString *) text completion
                                :(void(^)(NSString *translated, NSError *error))completion;
- (void) detectLanguage:(NSString *) text completion
                       :(void(^)(NSString *language, NSError *error))completion;
- (void) getLanguages:(NSString *) previousLanguage completion
                     :(void(^)(NSArray *language, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
