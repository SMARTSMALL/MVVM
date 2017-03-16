//
//  MessageViewModel.h
//  MVVMDemo
//
//  Created by goldeneye on 2017/3/16.
//  Copyright © 2017年 goldeneye by smart-small. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MessageModel;

@interface MessageViewModel : NSObject

- (void)getMessageParams:(NSMutableDictionary *)params successData:(void (^)(NSArray * array))successData failure:(void(^)(NSError * error))failure;



@end
