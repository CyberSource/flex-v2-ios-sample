#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "flex-api-ios-sdk.h"
#import "Base64.h"
#import "RSAUtils.h"
#import "CybsAGAesComponents.h"
#import "CybsAGBitwiseComponents.h"
#import "CybsAGGcmEndianness.h"
#import "CybsAGGcmMathComponents.h"
#import "CybsAGTypes.h"
#import "CybsAesGcm.h"
#import "CybsAGCipheredData.h"
#import "CybsAGError.h"
#import "IAGCipheredData.h"

FOUNDATION_EXPORT double flex_api_ios_sdkVersionNumber;
FOUNDATION_EXPORT const unsigned char flex_api_ios_sdkVersionString[];

