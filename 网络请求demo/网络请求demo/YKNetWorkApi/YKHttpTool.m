//
//  YKHttpTool.m
//  封装网络库
//
//  Created by pacific on 15/3/13.
//  Copyright (c) 2015年 pacific. All rights reserved.

#import "YKHttpTool.h"

@implementation YKHttpTool

#pragma mark - get -
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(responseBlock)successHandler failure:(requestFailureBlock)failureHandler
{
    AFHTTPRequestOperationManager *mgr = [self getRequstManager];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [self prettyPrintAboutHttpWithOperation:operation withResponseObj:responseObj withManager:mgr];
        !successHandler?:successHandler(responseObj);
        
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {!failureHandler?:failureHandler(error);}];
}

#pragma mark - post -
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(responseBlock)successHandler failure:(requestFailureBlock)failureHandler
{
    AFHTTPRequestOperationManager *mgr = [self getRequstManager];
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [self prettyPrintAboutHttpWithOperation:operation withResponseObj:responseObj withManager: mgr];
        !successHandler?:successHandler(responseObj);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) { !failureHandler?:failureHandler(error);}];
}

#pragma mark - put -
+ (void)put:(NSString *)url params:(NSDictionary *)params success:(responseBlock)successHandler failure:(requestFailureBlock)failureHandler
{
    AFHTTPRequestOperationManager *mgr = [self getRequstManager];
    [mgr PUT:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [self prettyPrintAboutHttpWithOperation:operation withResponseObj:responseObj withManager: mgr];
        !successHandler?:successHandler(responseObj);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {!failureHandler?:failureHandler(error);}];
}

#pragma mark - delete-
+ (void)deleteRequest:(NSString *)url params:(NSDictionary *)params success:(responseBlock)successHandler failure:(requestFailureBlock)failureHandler;
{
    AFHTTPRequestOperationManager *mgr = [self getRequstManager];
    [mgr DELETE:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [self prettyPrintAboutHttpWithOperation:operation withResponseObj:responseObj withManager:mgr];
        !successHandler?:successHandler(responseObj);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {!failureHandler?:failureHandler(error);}];
}

#pragma mark - post 上传图片-
+(void)uploadAvatarImgWithUrl:(NSString *)url WithImg:(UIImage *)avatarImg fileName:(NSString *)fileName success:(responseBlock)successHandler failure:(requestFailureBlock)failureHandler
{
    AFHTTPRequestOperationManager *mgr = [self getRequstManager];
    NSData *imgData = UIImageJPEGRepresentation(avatarImg, 0.5);
    
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imgData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self prettyPrintAboutHttpWithOperation:operation withResponseObj:responseObject withManager: mgr];
        !successHandler?:successHandler(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {!failureHandler?:failureHandler(error);}];
}

#pragma mark- AFHTTPRequestOperationManager初始化 网络超时设置 请求头
+(AFHTTPRequestOperationManager *)getRequstManager
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 设置token
    // [mgr.requestSerializer setValue:@"" forHTTPHeaderField:@"access_token"];
    
    // 请求超时设定
    // mgr.requestSerializer.timeoutInterval = 20;
    return mgr;
}

#pragma mark- 打印url 和 json数据 httpHeader用于调试
+(void)prettyPrintAboutHttpWithOperation:(AFHTTPRequestOperation *)operation withResponseObj:(id)responseObj withManager:(AFHTTPRequestOperationManager *)mgr
{
#if DEBUG
    // 请求的url
    // NSLog(@"fianlUrl: %@", operation.request.URL.absoluteString);
    
    // 请求的json数据打印
    // NSData *dataJson = [NSJSONSerialization dataWithJSONObject:responseObj options:NSJSONWritingPrettyPrinted error:nil];
    // NSString *jsonStr = [[NSString alloc] initWithData:dataJson encoding:NSUTF8StringEncoding];
    // NSLog(@"dataJson: %@", jsonStr);
    
    // 请求的header信息
    // NSDictionary *dict = mgr.requestSerializer.HTTPRequestHeaders;
    // NSLog(@"请求头httpHeader: %@", dict);
#endif
}

@end
