//
//  SkinLabHttpClient.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-3-8.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "SkinLabHttpClient.h"


static NSString * const kSkinLabBaseURLString = @"http://223.4.22.12/skinlab/";

@implementation SkinLabHttpClient

+ (SkinLabHttpClient *)sharedClient {
    static SkinLabHttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SkinLabHttpClient alloc] initWithBaseURL:[NSURL URLWithString:kSkinLabBaseURLString]];
    });
    
    return _sharedClient;
}

+ (NSString *)getSubPath:(SkinLabRequertType)type {
    
    switch (type) {
        case SkinLabRequertTypeWeeklyClass:
//            获取周刊分类
            return @"stat/?getContentDisplay";
            break;
            
        case SkinLabRequertTypeWeeklyData:
//            获取周刊数据
            return @"journal/?getJournal&firstLaunch=1";
            break;
            
        case SkinLabRequertTypeWeeklyTestData:
//            获取测试周刊数据
            return @"journal/?getJournalTest";
            break;
            
        case SkinLabRequertTypeWeeklyClicked:
//            上传周刊点击事件到服务器
            return @"journal/index.php?addJournalClicked";
            break;
            
        case SkinLabRequertTypeSearchClass:
//            获取快速搜索分类
            return @"stat/index.php?getSearchDisplay";
            break;
            
        case SkinLabRequertTypeSearchKeyWord:
//            产品搜索接口
            return @"product/index.php?searchProductsWithIngres";
            break;
            
        case SkinLabRequertTypeSearchBrands:
//            品牌搜索接口
            return @"product/index.php?getProductSearchBrands";
            break;
            
        case SkinLabRequertTypeSearchByQRCode:
//            按条码搜索产品接口
            return @"product/?getProduct";
            break;
            
        case SkinLabRequertTypeProductInfo:
//            获取产品信息接口
            return @"product/?getProduct";
            break;
            
        case SkinLabRequertTypeProductSimilar:
//            获取相关产品接口
            return @"product/index.php?getSimilarProNew";
            break;
            
        case SkinLabRequertTypeProductIngredient:
//            获取产品成分信息接口
            return @"product/index.php?getIngredient";
            break;
            
        case SkinLabRequertTypeProductCollect:
//            添加到用户的在用列表
            return @"user/index.php?addCollect";
            break;
            
        case SkinLabRequertTypeProductwish:
//            添加到用户的想用列表
            return @"user/index.php?addWishList";
            break;
            
        case SkinLabRequertTypeProductClicked:
//            上传用户的产品点击事件
            return @"user/index.php?addClick";
            break;
            
        case SkinLabRequertTypeTestData:
//            获取测试题数据接口
            return @"questionnaire/index.php?getNext&first=1";
            break;
            
        case SkinLabRequertTypeTestUpload:
//            上传测试结果接口
            return @"questionnaire/index.php?saveAnsNew";
            break;
            
        case SkinLabRequertTypeTestUploadNew:
            //            上传测试结果接口
            return @"questionnaire/index.php?submitAnswers";
            break;
            
        case SkinLabRequertTypeSystemUploadToken:
//            上传当前用户的推送Token接口
            return @"user/index.php?updateInfo";
            break;
            
        case SkinLabRequertTypeSystemDeleteToken:
//            删除当前用户的推送Token接口
            return @"user/index.php?delToken";
            break;
            
        case SkinLabRequertTypeSystemRegister:
//            删除当前用户的推送Token接口
            return @"ucenterapi/index.php?t=register";
            break;
            
        case SkinLabRequertTypeSystemVersion:
//            获取当前最新版本号接口
            return @"stat/?getNewVersion";
            break;
            
        case SkinLabRequertTypeAdvisor:
//            顾问功能接口
            return @"advisor/index.php?";
            break;

            
        default:
            return @"";
            break;
    }
}


- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    return self;
}

+ (NSURL *)getImageURL:(NSString *)imageURLString{
    NSString *urlString = [NSString stringWithFormat:@"http://223.4.22.12/skinlab/image%@", imageURLString];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

+ (NSData *)gzipData:(NSData *)pUncompressedData
{
    if (!pUncompressedData || [pUncompressedData length] == 0)
    {
        DLog(@"%s: Error: Can't compress an empty or null NSData object.", __func__);
        return nil;
    }
    
    z_stream zlibStreamStruct;
    zlibStreamStruct.zalloc    = Z_NULL; // Set zalloc, zfree, and opaque to Z_NULL so
    zlibStreamStruct.zfree     = Z_NULL; // that when we call deflateInit2 they will be
    zlibStreamStruct.opaque    = Z_NULL; // updated to use default allocation functions.
    zlibStreamStruct.total_out = 0; // Total number of output bytes produced so far
    zlibStreamStruct.next_in   = (Bytef*)[pUncompressedData bytes]; // Pointer to input bytes
    zlibStreamStruct.avail_in  = [pUncompressedData length]; // Number of input bytes left to process
    
    int initError = deflateInit2(&zlibStreamStruct, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);
    if (initError != Z_OK)
    {
        NSString *errorMsg = nil;
        switch (initError)
        {
            case Z_STREAM_ERROR:
                errorMsg = @"Invalid parameter passed in to function.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Insufficient memory.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        DLog(@"%s: deflateInit2() Error: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        return nil;
    }
    
    // Create output memory buffer for compressed data. The zlib documentation states that
    // destination buffer size must be at least 0.1% larger than avail_in plus 12 bytes.
    NSMutableData *compressedData = [NSMutableData dataWithLength:[pUncompressedData length] * 1.01 + 12];
    
    int deflateStatus;
    do
    {
        // Store location where next byte should be put in next_out
        zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;
        
        // Calculate the amount of remaining free space in the output buffer
        // by subtracting the number of bytes that have been written so far
        // from the buffer's total capacity
        zlibStreamStruct.avail_out = [compressedData length] - zlibStreamStruct.total_out;
        deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);
        
    } while ( deflateStatus == Z_OK );
    
    // Check for zlib error and convert code to usable error message if appropriate
    if (deflateStatus != Z_STREAM_END)
    {
        NSString *errorMsg = nil;
        switch (deflateStatus)
        {
            case Z_ERRNO:
                errorMsg = @"Error occured while reading file.";
                break;
            case Z_STREAM_ERROR:
                errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";
                break;
            case Z_DATA_ERROR:
                errorMsg = @"The deflate data was invalid or incomplete.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Memory could not be allocated for processing.";
                break;
            case Z_BUF_ERROR:
                errorMsg = @"Ran out of output buffer for writing compressed bytes.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        DLog(@"%s: zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        
        // Free data structures that were dynamically created for the stream.
        deflateEnd(&zlibStreamStruct);
        
        return nil;
    }
    // Free data structures that were dynamically created for the stream.
    deflateEnd(&zlibStreamStruct);
    [compressedData setLength: zlibStreamStruct.total_out];
    DLog(@"%s: Compressed file from %d KB to %d KB", __func__, [pUncompressedData length]/1024, [compressedData length]/1024);
    
    return compressedData;
}

+ (NSData *)ungzipData:(NSData *)compressedData
{
    if ([compressedData length] == 0)
        return compressedData;
    
    unsigned full_length = [compressedData length];
    unsigned half_length = [compressedData length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = [compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15+32)) != Z_OK)
        return nil;
    
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
    }
    
    if (inflateEnd (&strm) != Z_OK)
        return nil;
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    return nil;
}


@end
