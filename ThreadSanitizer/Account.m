//
//  Account.m
//  ThreadSanitizer
//
//  Created by Kenvin on 2016/11/8.
//  Copyright © 2016年 Kenvin. All rights reserved.
//

#import "Account.h"

@interface Account ()

@property (nonatomic ,strong) dispatch_queue_t queue;

@property (nonatomic ,assign) NSInteger privateBalance;

@end


@implementation Account

- (Account *)init{
    self = [super init];
    if (self) {
        self.queue = dispatch_queue_create("www.fangchang.com", NULL);
        self.privateBalance = 0;
    }
    return self;
}

- (NSInteger)balance{
    
    dispatch_sync(self.queue, ^{
        _balance = self.privateBalance;
    });
    
    return _balance;
    
}

- (void)withdraw:(NSInteger)amount success:(AccountBalanceBock)success{
    
    NSInteger newBalance = self.privateBalance - amount;
    if (newBalance<0) {
        NSLog(@"当前账户余额不足100");
        return ;
    }
    
    sleep(1);
    
    self.privateBalance = newBalance;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (success!=nil) {
            success();
        }
    });
}

- (void)deposit:(NSInteger)amount success:(AccountBalanceBock)success{
    
    NSInteger newBalance = self.privateBalance + amount;
    self.privateBalance = newBalance;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (success!=nil) {
            success();
        }
    });
}

- (void)setPrivateBalance:(NSInteger)privateBalance{
    dispatch_barrier_async(self.queue, ^{
        _privateBalance = privateBalance;
    });
}
@end
