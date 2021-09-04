//
//  CybsAesGcm.m
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 21/04/21.
//

#import "CybsAesGcm.h"

#import "CybsAGAesComponents.h"
#import "CybsAGBitwiseComponents.h"
#import "CybsAGError.h"
#import "CybsAGGcmEndianness.h"
#import "CybsAGGcmMathComponents.h"
#import "CybsAGTypes.h"

static const IAGUInt64Type kInputDataMaxLength = (0x1000000000ULL - 0x20ULL);
static const IAGUInt64Type kAdditionalAuthenticatedDataMaxLength = (0x2000000000000000ULL - 0x1ULL);
static const IAGUInt64Type kInitializationVectorMinLength = 0x1ULL;
static const IAGUInt64Type kInitializationVectorMaxLength = (0x2000000000000000ULL - 0x1ULL);
static const IAGSizeType kInitializationVectorRecommendedSize = 12;

@implementation CybsAesGcm

#pragma mark - Public class methods

+ (CybsAGCipheredData *)encryptPlainData:(NSData *)plainData
                                    withAdditionalAuthenticatedData:(NSData *)aad
                                            authenticationTagLength:(CybsAGAuthenticationTagLength)tagLength
                                               initializationVector:(NSData *)iv
                                                                key:(NSData *)key
                                                              error:(NSError **)error
{
    if ((plainData.length > kInputDataMaxLength) ||
        (aad.length > kAdditionalAuthenticatedDataMaxLength) ||
        (iv.length < kInitializationVectorMinLength) ||
        (iv.length > kInitializationVectorMaxLength))
    {
        if (error)
        {
            *error = [IAGErrorFactory errorInputDataLengthNotSupported];
        }

        return nil;
    }

    // Steps:
    // 1. Let H = CIPH(0^128).
    IAGBlockType h;
    BOOL success = [CybsAesGcm getHashSubkey:h withKey:key error:error];
    if (!success)
    {
        return nil;
    }

    // 2. Define a block, J0, as follows:
    //    If len(IV) = 96, then let J0 = IV || 0^31 || 1.
    //    If len(IV) != 96, then let s = 128 * ⎡len(IV) / 128⎤ - len(IV),
    //      and let J0 = GHASH(IV || 0^s+64|| [len(IV)]64).
    IAGBlockType j;
    [CybsAesGcm getPrecounterBlock:j withInitializationVector:iv hashSubkey:h];

    // 3. Let C = GCTR(inc32(J0), P).
    IAGUCharType c[plainData.length];
    success = [CybsAesGcm getGCounterBuffer:c
                                withBuffer:(IAGUCharType *)plainData.bytes
                                bufferSize:plainData.length
                           precounterBlock:j
                                       key:key
                                     error:error];
    if (!success)
    {
        return nil;
    }

    // 4. Let u = 128 * ⎡len(C) / 128⎤ - len(C) and let v = 128 * ⎡len(A) / 128⎤ - len(A)
    // 5. Define a block, S, as follows:
    //      S = GHASH(A || 0^v || C || 0^u || [len(A)]64 || [len(C)]64).
    IAGBlockType s;
    [CybsAesGcm getGhashBlock:s
               withAadBuffer:(IAGUCharType *)aad.bytes
               aadBufferSize:aad.length
              gCounterBuffer:c
          gCounterBufferSize:plainData.length
                  hashSubkey:h];

    // 6. Let T = MSB(GCTR(J0, S)).
    IAGBlockType entireT;
    success = [CybsAGGcmMathComponents getGCounterBuffer:entireT
                                           withBuffer:s
                                           bufferSize:sizeof(IAGBlockType)
                                  initialCounterBlock:j
                                                  key:key
                                                error:error];
    if (!success)
    {
        return nil;
    }

    IAGUCharType t[tagLength];
    [CybsAGBitwiseComponents getMostSignificantBytes:t
                                         withSize:tagLength
                                         inBuffer:entireT
                                         withSize:sizeof(IAGBlockType)];

    // 7. Return (C, T).
    return [[CybsAGCipheredData alloc] initWithCipheredBuffer:c
                                      cipheredBufferLength:plainData.length
                                         authenticationTag:t
                                   authenticationTagLength:tagLength];
}

#pragma mark - Private class methods

+ (BOOL)getHashSubkey:(IAGBlockType)hashSubkey withKey:(NSData *)key error:(NSError **)error
{
    IAGBlockType zeros;
    memset(zeros, 0x00, sizeof(IAGBlockType));

    return [CybsAGAesComponents getCipheredBlock:hashSubkey
                            byUsingAESOnBlock:zeros
                                      withKey:key
                                        error:error];
}

+ (void)getPrecounterBlock:(IAGBlockType)precounterBlock
  withInitializationVector:(NSData *)iv
                hashSubkey:(IAGBlockType)hashSubkey;
{
    // Define a block, J0, as follows:
    // If len(IV) = 96, then let J0 = IV || 0^31 || 1.
    if (iv.length == kInitializationVectorRecommendedSize)
    {
        memset(precounterBlock, 0x00, sizeof(IAGBlockType));
        memcpy(precounterBlock, iv.bytes, iv.length);
        memset(precounterBlock + sizeof(IAGBlockType) - 1, 0x01, 1);

        return;
    }

    // If len(IV) != 96, then let s = 128 * ⎡len(IV) / 128⎤ - len(IV),
    //   and let J0 = GHASH(IV || 0^s+64|| [len(IV)]64).
    IAGSizeType s = (iv.length % sizeof(IAGBlockType) == 0 ?
                     0 :
                     sizeof(IAGBlockType) - (iv.length % sizeof(IAGBlockType)));

    IAGSizeType bufferSize = (iv.length + s + 2 * sizeof(IAGUInt64Type));
    IAGUCharType buffer[bufferSize];

    memset(buffer, 0x00, bufferSize);

    memcpy(buffer, iv.bytes, iv.length);

    IAGUInt64Type len = [CybsAGGcmEndianness swapUInt64HostToGcm:(IAGBitsInUChar * iv.length)];
    memcpy(buffer + bufferSize - sizeof(IAGUInt64Type), &len, sizeof(IAGUInt64Type));

    [CybsAGGcmMathComponents getGhashBlock:precounterBlock
                             withBuffer:buffer
                             bufferSize:bufferSize
                             hashSubkey:hashSubkey];
}

+ (BOOL)getGCounterBuffer:(IAGUCharType *)gcounterBuffer
               withBuffer:(IAGUCharType *)buffer
               bufferSize:(IAGSizeType)bufferSize
          precounterBlock:(IAGBlockType)precounterBlock
                      key:(NSData *)key
                    error:(NSError **)error
{
    IAGBlockType inc32;
    [CybsAGGcmMathComponents get32BitIncrementedBuffer:inc32
                                         withBuffer:precounterBlock
                                               size:sizeof(IAGBlockType)];

    return [CybsAGGcmMathComponents getGCounterBuffer:gcounterBuffer
                                        withBuffer:buffer
                                        bufferSize:bufferSize
                               initialCounterBlock:inc32
                                               key:key
                                             error:error];
}

+ (void)getGhashBlock:(IAGBlockType)ghashBlock
        withAadBuffer:(IAGUCharType *)aadBuffer
        aadBufferSize:(IAGSizeType)aadBufferSize
       gCounterBuffer:(IAGUCharType *)gcounterBuffer
   gCounterBufferSize:(IAGSizeType)gCounterBufferSize
           hashSubkey:(IAGBlockType)hashSubkey
{
    // Steps:
    // 1. Let u = 128 * ⎡len(C) / 128⎤ - len(C) and let v = 128 * ⎡len(A) / 128⎤ - len(A)
    // 2. Define a block, S, as follows:
    //      S = GHASH(A || 0^v || C || 0^u || [len(A)]64 || [len(C)]64).

    IAGSizeType u = (gCounterBufferSize % sizeof(IAGBlockType) == 0 ?
                     0 :
                     sizeof(IAGBlockType) - (gCounterBufferSize % sizeof(IAGBlockType)));
    IAGSizeType v = (aadBufferSize % sizeof(IAGBlockType) == 0 ?
                     0 :
                     sizeof(IAGBlockType) - (aadBufferSize % sizeof(IAGBlockType)));

    IAGSizeType bufferSize = (aadBufferSize + v +
                              gCounterBufferSize + u +
                              2 * sizeof(IAGUInt64Type));
    IAGUCharType buffer[bufferSize];

    memset(buffer, 0x00, bufferSize);

    IAGSizeType pos = 0;
    memcpy(buffer + pos, aadBuffer, aadBufferSize);

    pos += (aadBufferSize + v);
    memcpy(buffer + pos, gcounterBuffer, gCounterBufferSize);

    pos += (gCounterBufferSize + u);
    IAGUInt64Type len = [CybsAGGcmEndianness swapUInt64HostToGcm:(IAGBitsInUChar * aadBufferSize)];
    memcpy(buffer + pos, &len, sizeof(IAGUInt64Type));

    pos += sizeof(IAGUInt64Type);
    len = [CybsAGGcmEndianness swapUInt64HostToGcm:(IAGBitsInUChar * gCounterBufferSize)];
    memcpy(buffer + pos, &len, sizeof(IAGUInt64Type));

    [CybsAGGcmMathComponents getGhashBlock:ghashBlock
                             withBuffer:buffer
                             bufferSize:bufferSize
                             hashSubkey:hashSubkey];
}

@end
