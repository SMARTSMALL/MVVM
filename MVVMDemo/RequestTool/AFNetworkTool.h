//
//  AFNetworkTool.h
//  AFNetworkTool
//
//  Created by goldeneye on 2017/3/3.
//  Copyright © 2017年 goldeneye by smart-small. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef void(^CallBack)(id json);

@interface AFNetworkTool : NSObject

//单例，每次只允许一次网络请求
+ (AFNetworkTool *)shareManager;

/**
 *   get 请求
 *
 *  @param httpUrl     请求url
 *  @param parameters   除文件外的后台要求参数
 *  @param successData 成功回调函数
 *  @param failure 失败回调函数
 */
- (void)getJSONWithUrl:(NSString * )httpUrl parame:(id)parameters  successData:(void (^)(id json))successData failure:(void (^)(NSError *error))failure;

/**
 *  post 请求
 *
 *  @param url     请求url
 *  @param parameters   除文件外的后台要求参数
 *  @param successData 成功回调函数
 *  @param failure 失败回调函数
 */
- (void)postJSONWithUrl : (NSString *)url parmas : (id)parameters successData: (void(^)(id json))successData failure:(void (^)(NSError *error))failure;
/**
 *  上传图片/视频（支持多张上传和单张上传）
 *
 *  @param url     上传地址
 *  @param param   除文件外的后台要求参数
 *  @param file    文件数组（文件流or数据流）
 *  @param fileKey 后台要求的文件字段
 *  @param success 成功回调函数
 *  @param failure 失败回调函数
 */
- (void)post:(NSString *)url parameters:(id)param imageFile:(NSArray*)file fileKey:(NSArray *)fileKey success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

- (void)cancelAllOperations;
/**
 *  @param url     上传地址
 *  @param params   除文件外的后台要求参数
 *  @param data    文件data
 *  @param name
 *  @param fileName
 *  @param successData 成功回调函数
 *  @param failure 失败回调函数
 *  @progress 进度
 */
- (void)upLoadToUrlString:(NSString*)url parameters:(id)params fileData:(NSData*)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString*)mimeType  successData: (void(^)(id json))successData failure:(void (^)(NSError *error))failure progerss:(void (^)(NSProgress* progress))progress;



@end
