//
//  RSAUtils.h
//  flex-client-sdk-ios
//
//  Created by Rakesh Ramamurthy on 18/04/21.
//

#import <Foundation/Foundation.h>
@interface RSAUtils : NSObject {
}

+ (NSString *)readKeysFromFile:(NSString *)keyName;
+ (SecKeyRef)RSAPublicKeyRefFromBase64String:(NSString *)key withTag:(NSString *)tag;

@end
