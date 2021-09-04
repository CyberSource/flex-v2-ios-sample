//
//  NSData+HexString.m
//  flex-api-ios-sdkTests
//
//  Created by Rakesh Ramamurthy on 03/05/21.
//

#import "NSData+HexString.h"

@implementation NSData (HexString)

#pragma mark - Public class methods

+ (NSData *)dataWithHexString:(NSString *)hexString
{
    NSString *replacedHexString = [hexString stringByReplacingOccurrencesOfString:@" "
                                                                       withString:@""];
    if (replacedHexString.length % 2 != 0)
    {
        return [NSData data];
    }

    NSMutableData *data = [NSMutableData data];

    NSRange range = NSMakeRange(0, 2);
    for (range.location = 0; range.location < replacedHexString.length; range.location += range.length)
    {
        u_char byte = [self byteInHexString:[replacedHexString substringWithRange:range]];

        [data appendBytes:&byte length:sizeof(u_char)];
    }

    return data;
}

#pragma mark - Private class methods

+ (u_char)byteInHexString:(NSString *)hexString
{
    NSScanner *scanner = [NSScanner scannerWithString:hexString];

    uint uintValue = 0;
    [scanner scanHexInt:&uintValue];

    return (u_char)uintValue;
}

@end
