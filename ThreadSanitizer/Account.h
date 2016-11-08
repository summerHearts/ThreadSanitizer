//
//  Account.h
//  ThreadSanitizer
//
//  Created by Kenvin on 2016/11/8.
//  Copyright © 2016年 Kenvin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AccountBalanceBock)();

@interface Account : NSObject

@property (nonatomic ,assign) NSInteger balance;

@property (copy ,nonatomic) AccountBalanceBock accountBalanceBock;

- (void)withdraw:(NSInteger)amount success:(AccountBalanceBock)success;

- (void)deposit:(NSInteger)amount success:(AccountBalanceBock)success;

@end
