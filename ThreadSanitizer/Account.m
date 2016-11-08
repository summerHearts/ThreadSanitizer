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

@end


@implementation Account

- (Account *)init{
    self = [super init];
    if (self) {
        self.queue = dispatch_queue_create("www.fangchang.com", NULL);
        self.balance = 0;
    }
    return self;
}

- (NSInteger)balance{
    @synchronized (@(_balance)) {
        return _balance;
    };
}

- (void)withdraw:(NSInteger)amount success:(AccountBalanceBock)success{
    dispatch_async(self.queue, ^{
        NSInteger newBalance = self.balance - amount;
        if (newBalance<0) {
            NSLog(@"当前账户余额不足100");
            return ;
        }
        
        sleep(2);
        
        self.balance = newBalance;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success!=nil) {
                success(self.balance);
            }
        });
    });
}

- (void)deposit:(NSInteger)amount success:(AccountBalanceBock)success{
    dispatch_async(self.queue, ^{
        NSInteger newBalance = self.balance + amount;
        self.balance = newBalance;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success!=nil) {
                success(self.balance);
            }
        });
    });
}
@end
