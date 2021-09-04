//
//  CybsAGAesComponents.m
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 21/04/21.
//

#import <CommonCrypto/CommonCryptor.h>

#import "CybsAGAesComponents.h"

#import "CybsAGError.h"

@implementation CybsAGAesComponents

#pragma mark - Public class methods

+ (BOOL)getCipheredBlock:(IAGBlockType)cipheredBlock
       byUsingAESOnBlock:(IAGBlockType)block
                 withKey:(NSData *)key
                   error:(NSError **)error
{
    size_t dataOutMoved = 0;
    CCCryptorStatus status = CCCrypt(kCCEncrypt,
                                     kCCAlgorithmAES,
                                     kCCOptionECBMode,
                                     key.bytes,
                                     key.length,
                                     nil,
                                     block,
                                     sizeof(IAGBlockType),
                                     cipheredBlock,
                                     sizeof(IAGBlockType),
                                     &dataOutMoved);
    BOOL success = ((status == kCCSuccess) && (dataOutMoved  == sizeof(IAGBlockType)));

    if (!success && error)
    {
        *error = [IAGErrorFactory errorAESFailed];
    }

    return success;
}

@end
