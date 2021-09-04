//
//  CybsAGAesComponents.h
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 21/04/21.
//

#import <Foundation/Foundation.h>

#import "CybsAGTypes.h"

/**
 [As mentioned in the documentation](http://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-38d.pdf): "The operations of GCM depend on the choice of an underlying symmetric key block cipher ...". In this case, the chosen algorithm is AES and here you can find the "forward cipher function" used in this implementation of GCM.
 */

NS_ASSUME_NONNULL_BEGIN

@interface CybsAGAesComponents : NSObject

/**
 "Forward cipher function" required by GCM and based on AES.

 @param cipheredBlock Output parameter with the resulting ciphered data
 @param block Input parameter with the data to cipher
 @param key Key used to cipher the data with length: kCCKeySizeAES128 (16), kCCKeySizeAES192 (24) or kCCKeySizeAES256 (32) bytes
 @param error Set to a value if the operation fails
 
 @return YES if the operation is successful, NO in other case
 
 @see IAGErrorFactory
 */
+ (BOOL)getCipheredBlock:(nonnull IAGBlockType)cipheredBlock
       byUsingAESOnBlock:(nonnull IAGBlockType)block
                 withKey:(NSData *)key
                   error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
