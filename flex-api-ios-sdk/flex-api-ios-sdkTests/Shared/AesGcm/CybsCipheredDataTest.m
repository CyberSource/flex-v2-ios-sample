//
//  CybsCipheredDataTest.m
//  flex-api-ios-sdkTests
//
//  Created by Rakesh Ramamurthy on 03/05/21.
//

#import <XCTest/XCTest.h>
#import "NSData+HexString.h"
#import "CybsAesGcm.h"
#import "CybsAGCipheredData.h"

@interface CybsCipheredDataTest : XCTestCase

@end

@implementation CybsCipheredDataTest

- (void)testAuthenticationTagSmallerThanTheSmallestAcceptableSize_initWithCipheredData_returnNil
{
    // given
    NSData *cipheredData = [NSData data];

    u_char authenticationTagBuffer[AuthTagLength96 - 1];
    NSData *authenticationTag = [NSData dataWithBytes:authenticationTagBuffer
                                               length:sizeof(authenticationTagBuffer)];

    // when
    CybsAGCipheredData *result = [[CybsAGCipheredData alloc] initWithCipheredData:cipheredData
                                                          authenticationTag:authenticationTag];
    
    // then
    XCTAssertNil(result);
}

- (void)testAuthenticationTagBiggerThanTheBiggestAcceptableSize_initWithCipheredData_returnNil
{
    // given
    NSData *cipheredData = [NSData data];

    u_char authenticationTagBuffer[AuthTagLength128 + 1];
    NSData *authenticationTag = [NSData dataWithBytes:authenticationTagBuffer
                                               length:sizeof(authenticationTagBuffer)];

    // when
    CybsAGCipheredData *result = [[CybsAGCipheredData alloc] initWithCipheredData:cipheredData
                                                          authenticationTag:authenticationTag];

    // then
    XCTAssertNil(result);
}

- (void)testAutheticatioTagWithTheSmallestAcceptableSize_initWithCipheredData_doesNotReturNil
{
    // given
    NSData *cipheredData = [NSData data];

    u_char authenticationTagBuffer[AuthTagLength96];
    NSData *authenticationTag = [NSData dataWithBytes:authenticationTagBuffer
                                               length:sizeof(authenticationTagBuffer)];

    // when
    CybsAGCipheredData *result = [[CybsAGCipheredData alloc] initWithCipheredData:cipheredData
                                                          authenticationTag:authenticationTag];

    // then
    XCTAssertNotNil(result);
}

- (void)testAutheticatioTagWithTheBiggestAcceptableSize_initWithCipheredData_doesNotReturNil
{
    // given
    NSData *cipheredData = [NSData data];

    u_char authenticationTagBuffer[AuthTagLength128];
    NSData *authenticationTag = [NSData dataWithBytes:authenticationTagBuffer
                                               length:sizeof(authenticationTagBuffer)];

    // when
    CybsAGCipheredData *result = [[CybsAGCipheredData alloc] initWithCipheredData:cipheredData
                                                          authenticationTag:authenticationTag];

    // then
    XCTAssertNotNil(result);
}

/*
- (void)testAnyArchivedCipheredData_unarchived_isEqualToOriginalCipheredData {
    // given
    NSData *ciphertext = [NSData dataWithHexString:@"0388dace60b6a392f328c2b971b2fe78"];
    NSData *authTag = [NSData dataWithHexString:@"ab6e47d42cec13bdf53a67b21257bddf"];
    CybsAGCipheredData *cipheredData = [[CybsAGCipheredData alloc] initWithCipheredBuffer:ciphertext.bytes
                                                               cipheredBufferLength:ciphertext.length
                                                                  authenticationTag:authTag.bytes
                                                            authenticationTagLength:authTag.length];

    NSData *archivedCipheredData = [NSKeyedArchiver archivedDataWithRootObject:cipheredData requiringSecureCoding:true error:nil];

    // when
    CybsAGCipheredData *unarchivedCipheredData = [NSKeyedUnarchiver unarchivedObjectOfClass:CybsAGCipheredData.self fromData:archivedCipheredData error:nil];

    // then
    XCTAssertEqualObjects(cipheredData, unarchivedCipheredData);
}
*/

@end
