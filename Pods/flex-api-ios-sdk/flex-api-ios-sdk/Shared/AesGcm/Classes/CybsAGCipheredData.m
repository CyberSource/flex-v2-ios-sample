//
//  CybsAGCipheredData.m
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 21/04/21.
//

#import "CybsAGCipheredData.h"

static NSString *const kCoderKeyAuthenticationTagData = @"authenticationTagData";
static NSString *const kCoderKeyCipheredData = @"cipheredData";

@interface CybsAGCipheredData ()

@property (nonatomic) NSData *cipheredData;
@property (nonatomic) NSData *authenticationTagData;

@end

@implementation CybsAGCipheredData

#pragma mark - Synthesize properties

- (const void *)cipheredBuffer
{
    return self.cipheredData.bytes;
}

- (NSUInteger)cipheredBufferLength
{
    return self.cipheredData.length;
}

- (const void *)authenticationTag
{
    return self.authenticationTagData.bytes;
}

- (CybsAGAuthenticationTagLength)authenticationTagLength
{
    return self.authenticationTagData.length;
}

#pragma mark - NSSecureCoding class synthesize properties

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark - NSObject methods

- (NSString *)description
{
    return [NSString stringWithFormat:@"Ciphertext: %@. Auth tag: %@",
            self.cipheredData, self.authenticationTagData];
}

#pragma mark - Init object

- (instancetype)initWithCipheredData:(NSData *)cipheredData
                   authenticationTag:(NSData *)authenticationTag {
    BOOL isAuthenticationTagLengthValid = ((AuthTagLength96 == authenticationTag.length) ||
                                           (AuthTagLength104 == authenticationTag.length) ||
                                           (AuthTagLength112 == authenticationTag.length) ||
                                           (AuthTagLength120 == authenticationTag.length) ||
                                           (AuthTagLength128 == authenticationTag.length));
    if (!isAuthenticationTagLengthValid)
    {
        return nil;
    }

    return [self initWithCipheredBuffer:cipheredData.bytes
                   cipheredBufferLength:cipheredData.length
                      authenticationTag:authenticationTag.bytes
                authenticationTagLength:(CybsAGAuthenticationTagLength)authenticationTag.length];
}

- (instancetype)initWithCipheredBuffer:(const void *)cipheredBuffer
                  cipheredBufferLength:(NSUInteger)cipheredBufferLength
                     authenticationTag:(const void *)authenticationTag
               authenticationTagLength:(CybsAGAuthenticationTagLength)authenticationTagLength
{
    self = [super init];

    if (self)
    {
        _cipheredData = [NSData dataWithBytes:cipheredBuffer length:cipheredBufferLength];
        _authenticationTagData = [NSData dataWithBytes:authenticationTag
                                                length:authenticationTagLength];
    }

    return self;
}

#pragma mark - NSCoding init methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSData *cipheredData = [aDecoder decodeObjectOfClass:[NSData class]
                                                  forKey:kCoderKeyCipheredData];
    NSData *authenticationTag = [aDecoder decodeObjectOfClass:[NSData class]
                                                       forKey:kCoderKeyAuthenticationTagData];
    if (!cipheredData || !authenticationTag)
    {
        return nil;
    }

    return [self initWithCipheredData:cipheredData authenticationTag:authenticationTag];
}

#pragma mark - Equality

- (NSUInteger)hash
{
    return self.cipheredData.hash;
}

- (BOOL)isEqual:(id)object
{
    if ([self class] == [object class])
    {
        return [self isEqualToCipheredData:object];
    }

    return [super isEqual:object];
}

- (BOOL)isEqualToCipheredData:(CybsAGCipheredData *)object
{
    if (self == object)
    {
        return YES;
    }

    return ([self.cipheredData isEqualToData:object.cipheredData] &&
            [self.authenticationTagData isEqualToData:object.authenticationTagData]);
}

#pragma mark - NSCoding methods

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.cipheredData forKey:kCoderKeyCipheredData];
    [aCoder encodeObject:self.authenticationTagData forKey:kCoderKeyAuthenticationTagData];
}

@end
