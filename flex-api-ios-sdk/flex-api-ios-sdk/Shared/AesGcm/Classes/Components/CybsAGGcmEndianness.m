//
//  CybsAGGcmEndianness.m
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 21/04/21.
//

#import "CybsAGGcmEndianness.h"

@implementation CybsAGGcmEndianness

+ (IAGUInt32Type)swapUInt32HostToGcm:(IAGUInt32Type)arg
{
    return CFSwapInt32HostToBig(arg);
}

+ (IAGUInt32Type)swapUInt32GcmToHost:(IAGUInt32Type)arg
{
    return CFSwapInt32BigToHost(arg);
}

+ (IAGUInt64Type)swapUInt64HostToGcm:(IAGUInt64Type)arg
{
    return CFSwapInt64HostToBig(arg);
}

@end
