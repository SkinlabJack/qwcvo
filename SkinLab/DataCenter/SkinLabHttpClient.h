//
//  SkinLabHttpClient.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-3-8.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h" 
#import "AFJSONRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "zlib.h"

typedef enum {
    SkinLabRequertTypeWeeklyClass,
    SkinLabRequertTypeWeeklyData,
    SkinLabRequertTypeWeeklyTestData,
    SkinLabRequertTypeWeeklyClicked,
    
    SkinLabRequertTypeSearchClass,
    SkinLabRequertTypeSearchKeyWord,
    SkinLabRequertTypeSearchBrands,
    SkinLabRequertTypeSearchByQRCode,
    
    SkinLabRequertTypeProductInfo,
    SkinLabRequertTypeProductSimilar,
    SkinLabRequertTypeProductIngredient,
    SkinLabRequertTypeProductCollect,
    SkinLabRequertTypeProductwish,
    SkinLabRequertTypeProductClicked,
    
    SkinLabRequertTypeTestData,
    SkinLabRequertTypeTestUpload,
    SkinLabRequertTypeTestUploadNew,
    
    SkinLabRequertTypeSystemUploadToken,
    SkinLabRequertTypeSystemDeleteToken,
    SkinLabRequertTypeSystemRegister,
    SkinLabRequertTypeSystemVersion,
    
    SkinLabRequertTypeAdvisor
}SkinLabRequertType;

@interface SkinLabHttpClient : AFHTTPClient

+ (SkinLabHttpClient *)sharedClient;
+ (NSString *)getSubPath:(SkinLabRequertType)type;
+ (NSURL *)getImageURL:(NSString *)imageURLString;

+ (NSData*)gzipData:(NSData*)pUncompressedData;  //压缩
+ (NSData*)ungzipData:(NSData *)compressedData;  //解压缩

@end
