
//
//  AFNetworkTool.m
//  AFNetworkTool
//
//  Created by goldeneye on 2017/3/3.
//  Copyright © 2017年 goldeneye by smart-small. All rights reserved.
//

#import "AFNetworkTool.h"


#ifdef DEBUG
#define LRString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define LRLog(...) printf(" %s 第%d行: %s\n\n",, [LRString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

#else
#define LRLog(...)
#endif

static AFHTTPSessionManager *manager;
static AFNetworkTool * netWorkTool;
@implementation AFNetworkTool


//单例模式

+ (AFNetworkTool *)shareManager{
    /*! 为单例对象创建的静态实例，置为nil，因为对象的唯一性，必须是static类型 */
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        //一次只允许一个请求
        if (netWorkTool==nil) {
            netWorkTool = [[AFNetworkTool alloc]init];
            //一次创建 防止内存泄漏
            manager = [AFHTTPSessionManager manager];
            //manager.requestSerializer = [AFJSONRequestSerializer serializer];
            //设置返回格式
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            // 设置超时时间
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 30.0f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            //允许请求的格式
            [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", nil]];
            
            
        }
    });
    return netWorkTool;
}
/**
 *   get 请求
 *
 *  @param httpUrl     请求url
 *  @param parameters   除文件外的后台要求参数
 *  @param successData 成功回调函数
 *  @param failure 失败回调函数
 */
- (void)getJSONWithUrl:(NSString * )httpUrl parame:(id)parameters  successData:(void (^)(id json))successData failure:(void (^)(NSError *error))failure{
    
    //初始化一个下载请求数组
    NSMutableArray * saferequestArray=[[NSMutableArray alloc]init];
    //每次开始下载任务前做如下判断
    for (NSString * request in saferequestArray) {
        if ([httpUrl isEqualToString:request]) {
            return;
        }
    }
    [saferequestArray addObject:httpUrl];
    
    [manager GET:httpUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject)
        {
            
            
            successData(responseObject);
            [saferequestArray removeObject:httpUrl];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        [saferequestArray removeObject:httpUrl];
    }];
    
}
/**
 *  post 请求
 *
 *  @param url     请求url
 *  @param parameters   除文件外的后台要求参数
 *  @param successData 成功回调函数
 *  @param failure 失败回调函数
 */
- (void)postJSONWithUrl : (NSString *)url parmas : (id)parameters successData: (void(^)(id json))successData failure:(void (^)(NSError *error))failure
{
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//
//      //  NSString * string =@"[{\"ID\":13,\"Mark\":\"254A7AB071E84FD5A95582DBFC0D485F\",\"MarkZT\":0,\"bz\":\"默认未修改\"}]"
//        
//       NSString * string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        
//        NSLog(@"responseObject >>>>>>>>string======%@",string);
//        
//        NSLog(@"changeDict = string >>>>>> %@",[self dictionaryWithJsonString:string]);
//        
//        
//        NSDictionary * results = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        
//        
//        NSLog(@"responseObject === >>>results>>>>>>>>>>>.==%@",results);
        
        if (responseObject)
        {
            
            successData(responseObject);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];
}
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
- (void)post:(NSString *)url parameters:(id)param imageFile:(NSArray*)file fileKey:(NSArray *)fileKey success:(void (^)(id result))success failure:(void (^)(NSError *error))failure
{
    
    
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //添加上传图片
        for(int i=0 ; i<file.count ; i++){
            //加盖时间戳
            NSDate *datenow = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            //图片流
            NSData *imageData = UIImageJPEGRepresentation(file[i], 0.001);
            //压缩图片
            // NSData * imageData = [GetTool resetSizeOfImageData:file[i] maxSize:100];
            //fileKey image1 image2  image3
            [formData appendPartWithFileData:imageData name:fileKey[i] fileName:[NSString stringWithFormat:@"%@.png",timeSp] mimeType:@"image/jpeg"];
            
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            
            failure(error);
            
        }
    }];
    
    
}
//取消请求
- (void)cancelAllOperations
{
    
    [manager.operationQueue cancelAllOperations];
    
}
- (void)upLoadToUrlString:(NSString*)url parameters:(id)params fileData:(NSData*)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString*)mimeType  successData: (void(^)(id json))successData failure:(void (^)(NSError *error))failure progerss:(void (^)(NSProgress* progress))progress
{
    
    if (data==nil)return;
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //添加需要上传的视频
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            
            if (successData) {
                successData(responseObject);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}
//https证书设置
- (AFSecurityPolicy*)customSecurityPolicy {
    // /先导入证书 certificate为证书名称的宏，仅支持cer格式
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];//证书的路径
    
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    if (certData==nil) {
        return nil;
    }
    
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    //  NSSet *set1 = [[NSSet alloc] initWithObjects:certData, nil];
    // 设置证书
    securityPolicy.pinnedCertificates = @[certData];;
    
    
    return securityPolicy;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end
