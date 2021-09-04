//
//  CybsAesGcm.h
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 21/04/21.
//

#import <Foundation/Foundation.h>

#import "CybsAGCipheredData.h"

/**
 This class provides the methods that implement the GCM algorithm with AES.
 */

NS_ASSUME_NONNULL_BEGIN

@interface CybsAesGcm : NSObject

/**
 Given an initialization vector,a key, a plaintext and an additional authenticated data,
 this method returns the corresponding ciphertext and authentication tag.

 @param plainData Data to cipher: byte length(plainData) <= 2^36 - 32
 @param aad Additional Authenticated Data: byte length(aad) <= 2^61 - 1
 @param tagLength Supported authentication tag length, used to build the returned ciphered data
 @param iv Initialization Vector: 1 <= byte length(iv) <= 2^61 - 1
 @param key Key used to cipher the data with length: kCCKeySizeAES128 (16), kCCKeySizeAES192 (24) or kCCKeySizeAES256 (32) bytes
 @param error Set to a value if the operation fails
 
 @return Ciphered data or nil, if there is an error
 
 @see IAGAuthenticationTagLength
 @see IAGCipheredData
 @see IAGErrorFactory
 */
+ (nullable CybsAGCipheredData *)encryptPlainData:(NSData *)plainData
                                             withAdditionalAuthenticatedData:(NSData *)aad
                                                     authenticationTagLength:(CybsAGAuthenticationTagLength)tagLength
                                                        initializationVector:(NSData *)iv
                                                                         key:(NSData *)key
                                                                       error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
