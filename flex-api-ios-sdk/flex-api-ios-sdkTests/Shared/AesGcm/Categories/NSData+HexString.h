//
//  NSData+HexString.h
//  flex-client-sdk-ios
//
//  Created by Rakesh Ramamurthy on 03/05/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (HexString)

+ (NSData *)dataWithHexString:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
