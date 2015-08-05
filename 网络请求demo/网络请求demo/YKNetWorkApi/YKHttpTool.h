//
//  YKHttpTool.h
//  封装网络库
//
//  Created by pacific on 15/3/13.
//  Copyright (c) 2015年 pacific. All rights reserved.
//  网络请求工具类：负责整个项目的所有http请求

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/* 当request成功后的 responseBlock */
typedef void (^responseBlock)(id responseObj);
/* 请求失败的时候 */
typedef void (^requestFailureBlock)(NSError *error);
/* 请求成功 经过处理的有效block (子类写网络请求的时候用这个block) */
typedef void (^responseHandler)(id dataObj, NSError *error);


@interface YKHttpTool : NSObject
/**
 *  发送一个GET(post...)请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(responseBlock)successHandler failure:(requestFailureBlock)failureHandler;

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(responseBlock)successHandler failure:(requestFailureBlock)failureHandler;

+ (void)put:(NSString *)url params:(NSDictionary *)params success:(responseBlock)successHandler failure:(requestFailureBlock)failureHandler;

+ (void)deleteRequest:(NSString *)url params:(NSDictionary *)params success:(responseBlock)successHandler failure:(requestFailureBlock)failureHandler;

//  post上传图片
+(void)uploadAvatarImgWithUrl:(NSString *)url WithImg:(UIImage *)avatarImg fileName:(NSString *)fileName success:(responseBlock)successHandler failure:(requestFailureBlock)failureHandler;


@end
