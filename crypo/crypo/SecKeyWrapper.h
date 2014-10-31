//
//  SecKeyWrapper.h
//  crypo
//
//  Created by Caland on 14/10/31.
//  Copyright (c) 2014年 Caland. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

/* 
 *  开始全区声明
 */

// Global constants used for symmetric key algorithm choice and
// chosen digest.
//  用于对称加密算法的常量和摘要。

//  对称加密算法键和摘要算法，在这个里面使用到了aes和sha1算法。
//  iPad和iPhone硬件设备会对这些算法进行加速
// The chosen symmetric key and digest algorithm chosen for this sample is AES and SHA1.
// The reasoning behind this was due to the fact that the iPhone and iPod touch have
// hardware accelerators for those particular algorithms and therefore are energy efficient.

#define kChosenCipherBlockSize	kCCBlockSizeAES128
#define kChosenCipherKeySize	kCCKeySizeAES128
#define kChosenDigestLength		CC_SHA1_DIGEST_LENGTH

// Global constants for padding schemes.
// 全局常量，用于赘语纲要
#define	kPKCS1					11
#define kTypeOfWrapPadding		kSecPaddingPKCS1
#define kTypeOfSigPadding		kSecPaddingPKCS1SHA1

// constants used to find public, private, and symmetric keys.
//  用来寻找公钥和私钥，和对称算法的key值。
#define kPublicKeyTag			"com.apple.sample.publickey"
#define kPrivateKeyTag			"com.apple.sample.privatekey"
#define kSymmetricKeyTag		"com.apple.sample.symmetrickey"



@interface SecKeyWrapper : NSObject
{
    NSData * publicTag;//公钥标记
    NSData * privateTag;//私钥标记
    NSData * symmetricTag;//对称算法标记
    
    CCOptions typeOfSymmetricOpts;//对称加密算法的选项
    
    SecKeyRef publicKeyRef;//公钥引用
    SecKeyRef privateKeyRef;//私钥引用
    NSData * symmetricKeyRef;//对称加密引用
}

@property (nonatomic, retain) NSData * publicTag;
@property (nonatomic, retain) NSData * privateTag;
@property (nonatomic, retain) NSData * symmetricTag;
@property (nonatomic, retain) NSData * symmetricKeyRef;


+ (SecKeyWrapper *)sharedWrapper;

/**
 *  @abstract 生成公私鈅对
 */
- (void)generateKeyPair:(NSUInteger)keySize;

/**
 *  @abstract 删除非对称加密的键
 */
- (void)deleteAsymmetricKeys;

/**
 *  @abstract 删除对称加密的键
 */
- (void)deleteSymmetricKey;

/**
 *  @abstract 生成对称加密的键
 */
- (void)generateSymmetricKey;

/**
 *  @abstract 添加公钥（在keychain中）
 */
- (SecKeyRef)addPeerPublicKey:(NSString *)peerName keyBits:(NSData *)publicKey;

/**
 *  @abstract 移除公钥（在keychain中）
 */
- (void)removePeerPublicKey:(NSString *)peerName;

/**
 *  @abstract 得到对称加密的值
 */
- (NSData *)getSymmetricKeyBytes;

/**
 *  @abstract 包装对称加密的值，使用公钥
 */
- (NSData *)wrapSymmetricKey:(NSData *)symmetricKey keyRef:(SecKeyRef)publicKey;

/**
 *  @abstract 解除包装对称加密的值
 */
- (NSData *)unwrapSymmetricKey:(NSData *)wrappedSymmetricKey;

/**
 *  @abstract 对plainText进行加密
 */
- (NSData *)getSignatureBytes:(NSData *)plainText;

/**
 *  @abstract 对plainText进行哈希
 */
- (NSData *)getHashBytes:(NSData *)plainText;

/**
 *  @abstract 使用公钥进行验证
 */
- (BOOL)verifySignature:(NSData *)plainText secKeyRef:(SecKeyRef)publicKey signature:(NSData *)sig;

/**
 *  @abstract 对plainText进行加密
 */
- (NSData *)doCipher:(NSData *)plainText key:(NSData *)symmetricKey context:(CCOperation)encryptOrDecrypt padding:(CCOptions *)pkcs7;

/**
 *  @abstract 得到公钥
 */
- (SecKeyRef)getPublicKeyRef;

/**
 *  @abstract 得到公钥的比特流
 */
- (NSData *)getPublicKeyBits;

/**
 *  @abstract 得到私钥
 */
- (SecKeyRef)getPrivateKeyRef;

/**
 *  @abstract 使用keyRef得到持久化存储的键
 */
- (CFTypeRef)getPersistentKeyRefWithKeyRef:(SecKeyRef)keyRef;

/**
 *  @abstract 根据持久化的键得到keyRef
 */
- (SecKeyRef)getKeyRefWithPersistentKeyRef:(CFTypeRef)persistentRef;


@end
