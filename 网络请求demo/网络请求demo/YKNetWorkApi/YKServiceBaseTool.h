//
//  YKServiceBaseTool.h
//  封装网络库
//
//  Created by pacific on 15/3/13.
//  Copyright (c) 2015年 pacific. All rights reserved.
//  该类是网络请求的业务基础类 该类的每个子类对应一个host主机

#import <Foundation/Foundation.h>
#import "YKHttpTool.h"
#import "YKNetWorkUrlDocument.h"

typedef void (^imgBlock)(NSString *field_id);

@interface YKServiceBaseTool : NSObject

+ (void)getWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass responseBlock:(responseHandler)responseDataBlock;

+ (void)postWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass responseBlock:(responseHandler)responseDataBlock;

+ (void)putWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass responseBlock:(responseHandler)responseDataBlock;

+ (void)deleteWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass responseBlock:(responseHandler)responseDataBlock;

// 上传头像 post
+ (void)upLoadAvatarWithUrl:(NSString *)url avatar:(UIImage *)avatarImg fileName:(NSString *)fileName resultClass:(Class)resultClass responseBlock:(responseHandler)responseDataBlock;

// put请求上传图片
+ (void)upLoadImagesWithUrl:(NSString *)url WithFilename:(NSString *)filename data:(NSData *)data parmas:(NSDictionary *)params withHandler:(imgBlock)imgHandler;

@end
