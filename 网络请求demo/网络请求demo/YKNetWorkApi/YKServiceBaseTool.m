//
//  YKServiceBaseTool.m
//  封装网络库
//
//  Created by pacific on 15/3/13.
//  Copyright (c) 2015年 pacific. All rights reserved.
//  

#import "YKServiceBaseTool.h"
#import "YKConfigTool.h"
#import "MJExtension.h"

// 错误的字典
/**
 *  desc = 账号或密码错误
 *  error = 20702
 */

#define YKData(str) [str dataUsingEncoding:NSUTF8StringEncoding]
static id dataObj;
static id dataError;

@implementation YKServiceBaseTool
+ (void)getWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass responseBlock:(responseHandler)responseDataBlock
{
    if (![self networkStatusCheck]) {
        !responseDataBlock?:responseDataBlock(nil, nil);
        return;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    url = [self compeletHttpUrlWithSubUrl:url];
    [YKHttpTool get:url params:param success:^(id responseObj) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self dealResponseData:responseObj cl:resultClass];
        !responseDataBlock?:responseDataBlock(dataObj, dataError);
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"请求失败：%@", error);
        !responseDataBlock?:responseDataBlock(nil, error);
    }];
}

+ (void)postWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass responseBlock:(responseHandler)responseDataBlock
{
    if (![self networkStatusCheck]) {
        !responseDataBlock?:responseDataBlock(nil, nil);
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // 拼接host
    url = [self compeletHttpUrlWithSubUrl:url];
    [YKHttpTool post:url params:param success:^(id responseObj) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self dealResponseData:responseObj cl:resultClass];
        !responseDataBlock?:responseDataBlock(dataObj, dataError);
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"请求失败：%@", error);
        !responseDataBlock?:responseDataBlock(nil, error);
    }];
}

+ (void)putWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass responseBlock:(responseHandler)responseDataBlock{}

+ (void)deleteWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass responseBlock:(responseHandler)responseDataBlock
{
    if (![self networkStatusCheck]) {
        !responseDataBlock?:responseDataBlock(nil, nil);
        return;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // 拼接host
    url = [self compeletHttpUrlWithSubUrl:url];
    [YKHttpTool deleteRequest:url params:param success:^(id responseObj) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self dealResponseData:responseObj cl:resultClass];
        !responseDataBlock?:responseDataBlock(dataObj, dataError);
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"请求失败：%@", error);
        !responseDataBlock?:responseDataBlock(nil, error);
    }];
}

+ (void)upLoadAvatarWithUrl:(NSString *)url avatar:(UIImage *)avatarImg fileName:(NSString *)fileName resultClass:(Class)resultClass responseBlock:(responseHandler)responseDataBlock
{
    if (![self networkStatusCheck]) {
        !responseDataBlock?:responseDataBlock(nil, nil);
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    url = [self compeletHttpUrlWithSubUrl:url];
    fileName = fileName?fileName:(fileName = @"avatar.jpg");
    
    [YKHttpTool uploadAvatarImgWithUrl:url WithImg:avatarImg fileName:fileName success:^(id responseObj) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self dealResponseData:responseObj cl:resultClass];
        !responseDataBlock?:responseDataBlock(dataObj, dataError);
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"请求失败：%@", error);
        !responseDataBlock?:responseDataBlock(nil, error);
    }];
}

#pragma mark- 对网络请求到数据进行处理 方便子类使用
+(void)dealResponseData:(id)responseObj cl:(Class)resultClass
{
    // 如果服务器的错误格式比较同一 可以直接转为NSError
    /**
     * 
     {
        decs  = "dddd",
        error = "dddd",
     }
     */
    
    NSString *errorStr = responseObj[@"desc"]?responseObj[@"desc"]:@"未知错误";
    NSString *errorCode = responseObj[@"error"];
    if (errorCode) {
        NSLog(@"请求成功--返回错误信息: %@", responseObj);
        NSError *domainError = [NSError errorWithDomain:errorStr code:[errorCode integerValue] userInfo:nil];
        [self setError:domainError];
    } else {
        if (resultClass && ![resultClass isSubclassOfClass:[NSDictionary class]]) { // 模型
            [self setDataObj:[resultClass objectWithKeyValues:responseObj]];
        } else {
            [self setDataObj:responseObj];
        }
    }
}

+(void)setDataObj:(id)obj
{
    dataObj = nil;
    dataObj = obj;
    dataError = nil;
}

+(void)setError:(id)errorObj
{
    dataError = nil;
    dataError = errorObj;
    dataObj = nil;
}

#pragma mark- 网络监测
+(BOOL)networkStatusCheck
{
    __block BOOL netWorkCanUse = YES;
    AFNetworkReachabilityManager *reachabilityMgr = [AFNetworkReachabilityManager sharedManager];
    [reachabilityMgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown) {
            netWorkCanUse = YES;
        } else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            netWorkCanUse = YES;
        } else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            netWorkCanUse = YES;
        } else if (status == AFNetworkReachabilityStatusNotReachable){
            // 网络异常处理
            netWorkCanUse = NO;
        }
    }];
    [reachabilityMgr startMonitoring];
    return netWorkCanUse;
}

+ (void)upLoadImagesWithUrl:(NSString *)url WithFilename:(NSString *)filename data:(NSData *)data parmas:(NSDictionary *)params withHandler:(imgBlock)imgHandler
{
    // 拼接host
    url = [self compeletHttpUrlWithSubUrl:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"PUT";
    
    // 设置请求体
    NSMutableData *body = [NSMutableData data];
    
    /***************文件参数***************/
    [body appendData:YKData(@"--YKCxb\r\n")];
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", filename];
    [body appendData:YKData(disposition)];
    NSString *type = [NSString stringWithFormat:@"Content-Type: @\"image/png\"\r\n"];
    [body appendData:YKData(type)];
    
    [body appendData:YKData(@"\r\n")];
    [body appendData:data];
    [body appendData:YKData(@"\r\n")];
    
    /***************普通参数***************/
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [body appendData:YKData(@"--YKCxb\r\n")];
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
        [body appendData:YKData(disposition)];
        [body appendData:YKData(@"\r\n")];
        [body appendData:YKData(obj)];
        [body appendData:YKData(@"\r\n")];
    }];
    
    /***************参数结束***************/
    [body appendData:YKData(@"--YKCxb--\r\n")];
    request.HTTPBody = body;
    [request setValue:[NSString stringWithFormat:@"%zd", body.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"multipart/form-data; boundary=YKCxb" forHTTPHeaderField:@"Content-Type"];
    
    // 发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSString *fieldId = dict[@"file_id"];
            !imgHandler?:imgHandler(fieldId);
        } else {
            NSLog(@"上传失败");
        }
    }];
}

#pragma mark- 处理url 拼接host
+(NSString *)compeletHttpUrlWithSubUrl:(NSString *)subUrl
{
    if ([subUrl hasPrefix:@"http://"]) {
        return subUrl;
    }
    NSString *hostName = [YKConfigTool getLocalHostNameWithClassName:[self vilidClassName]];
    return [NSString stringWithFormat:@"http://%@/%@", hostName, subUrl];
}


+(NSString *)vilidClassName
{
    Class cl = [self class];
    while (![NSStringFromClass([cl superclass]) isEqualToString:@"YKServiceBaseTool"]) {
        cl = [cl superclass];
    }
    return NSStringFromClass(cl);
}


@end
