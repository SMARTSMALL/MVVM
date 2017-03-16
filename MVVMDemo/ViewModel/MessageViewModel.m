
//
//  MessageViewModel.m
//  MVVMDemo
//
//  Created by goldeneye on 2017/3/16.
//  Copyright © 2017年 goldeneye by smart-small. All rights reserved.
//

#import "MessageViewModel.h"
#import "Define.h"
#import "AFNetworkTool.h"
#import "MessageModel.h"

#define REQUESTURL @"http://japi.juhe.cn/joke/content/text.from"

@implementation MessageViewModel

/**
 *   网络获取消息数据
 *
 *  @param params        请求参数
 *  @param successData   成功回掉
 */

- (void)getMessageParams:(NSMutableDictionary *)params successData:(void (^)(NSArray * array))successData failure:(void(^)(NSError * error))failure{
    
    [[AFNetworkTool shareManager]postJSONWithUrl:REQUESTURL parmas:params successData:^(id json) {
        if (json) {
            if (successData) {
                successData([self suceessDataWithJson:json]);
            }
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
    
}

- (NSArray *)suceessDataWithJson:(id)json{
    NSDictionary * results = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves error:nil];

    if (results) {
        NSString * reason = results[@"reason"];
        if ([reason isEqualToString:@"Success"]) {
            NSDictionary * resultDict = results[@"result"];
            if (resultDict) {
                NSArray * data = resultDict[@"data"];
                
                if (data.count>0) {
                    NSMutableArray * dataArray = [NSMutableArray array];
                    for (NSDictionary * dic  in data) {
                        MessageModel * model = [[MessageModel alloc] init];
                        model.content = dic[@"content"];
                        [dataArray addObject:model];
                    }
                    return dataArray;
                }else{
                    return @[];
                }
            
            }else{
                return @[];
            }
        }else{
            return @[];
        }
    }else{
        return @[];
    }
}

@end
