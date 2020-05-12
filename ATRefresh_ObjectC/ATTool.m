//
//  ATTool.m
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/12.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "ATTool.h"

@implementation ATTool
+ (NSURLSessionDataTask *)getData:(NSString *)urlString
                           params:(NSDictionary *)params
                          success:(void(^)(id object))success
                          failure:(void(^)(NSError *error))failure{
    return [ATTool method:HttpMethodGet serializer:HttpSerializeDefault urlString:urlString params:params timeOut:10 success:^(id  _Nonnull object) {
        if ([object isKindOfClass:NSData.class]) {
            NSError *error = nil;
            id dic = [NSJSONSerialization JSONObjectWithData:object options:NSJSONReadingMutableLeaves error:&error];
            if (!error) {
                !success ?: success(dic[@"books"]);
            }else{
                !failure ?: failure(error);
            }
        }
    } failure:failure];
}
+ (NSURLSessionDataTask *)method:(HttpMethod)method
                      serializer:(HttpSerializer)serializer
                       urlString:(NSString *)urlString
                          params:(NSDictionary *)params
                         timeOut:(NSTimeInterval)timeOut
                         success:(void(^)(id object))success
                         failure:(void(^)(NSError *error))failure
{
    AFHTTPSessionManager *netManager = [AFHTTPSessionManager manager];
    switch (serializer) {
        case HttpSerializeDefault:
            netManager.requestSerializer = [AFHTTPRequestSerializer serializer];
            netManager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        case HttpSerializePropertyList:
            netManager.requestSerializer = [AFPropertyListRequestSerializer serializer];
            netManager.responseSerializer = [AFJSONResponseSerializer serializer];
        default:
            netManager.requestSerializer = [AFJSONRequestSerializer serializer];
            netManager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
    }
    NSDictionary *headers = @{@"chrome":@"User-Agent"};
    netManager.requestSerializer.timeoutInterval = timeOut;
    netManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
   // [netManager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
//    [netManager.requestSerializer setValue:@"chrome" forHTTPHeaderField:@"User-Agent"];
   // [request addValue:@"chrome" forHTTPHeaderField:@"User-Agent"];
    // 2.加上这个函数，https ssl 验证。
    // [netManager setSecurityPolicy:[BaseNetManager securityPolicy]];
    
    switch (method) {
        case HttpMethodGet: {
            //部分接口不需要二次encode
            //urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
            return [netManager GET:urlString parameters:params headers:headers progress:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                !success ?: success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                !failure ?: failure(error);
            }];
        }
        case HttpMethodPut: {
            return [netManager PUT:urlString parameters:params headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                !success ?: success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                !failure ?: failure(error);
            }];
        }
        case HttpMethodDelete: {
            return [netManager DELETE:urlString parameters:params headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                !success ?: success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                !failure ?: failure(error);
            }];
        }
        case HttpMethodPost: {
            return  [netManager POST:urlString parameters:params headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                !success ?: success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                !failure ?: failure(error);
            }];
        }
        default:
            break;
    }
    return nil;
}
@end
