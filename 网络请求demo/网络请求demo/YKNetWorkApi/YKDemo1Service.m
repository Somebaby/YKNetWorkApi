//
//  YKHshConsumerService.m
//  YkLmHsh
//
//  Created by pacific on 15/5/19.
//  Copyright (c) 2015年 曹晓波. All rights reserved.
//

#import "YKDemo1Service.h"
#import "MJExtension.h"

@implementation YKDemo1Service
+(void)getWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass responseBlock:(responseHandler)responseDataBlock
{
    if (![param isKindOfClass:[NSDictionary class]]) {
        param = [param keyValues];
    }
    [super getWithUrl:url param:param resultClass:resultClass responseBlock:responseDataBlock];
}

+ (void)postWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass responseBlock:(responseHandler)responseDataBlock
{
    if (![param isKindOfClass:[NSDictionary class]]) {
        param = [param keyValues];
    }
    [super postWithUrl:url param:param resultClass:resultClass responseBlock:responseDataBlock];
}


@end
