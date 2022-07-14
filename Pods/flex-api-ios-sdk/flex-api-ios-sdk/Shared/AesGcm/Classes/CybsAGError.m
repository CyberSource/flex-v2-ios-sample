//
//  CybsAGError.m
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 21/04/21.
//

#import "CybsAGError.h"

NSString * const IAGErrorDomain = @"IAGErrorDomain";

@implementation IAGErrorFactory

#pragma mark - Public class methods

+ (NSError *)errorAESFailed
{
    return [NSError errorWithDomain:IAGErrorDomain
                               code:IAGErrorCodeAESFailed
                           userInfo:nil];
}

+ (NSError *)errorInputDataLengthNotSupported
{
    return [NSError errorWithDomain:IAGErrorDomain
                               code:IAGErrorCodeInputDataLengthNotSupported
                           userInfo:nil];
}

+ (NSError *)errorAuthenticationTagsNotIdentical
{
    return [NSError errorWithDomain:IAGErrorDomain
                               code:IAGErrorCodeAuthenticationTagsNotIdentical
                           userInfo:nil];
}

@end
