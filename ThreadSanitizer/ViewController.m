//
//  ViewController.m
//  ThreadSanitizer
//
//  Created by Kenvin on 2016/11/8.
//  Copyright © 2016年 Kenvin. All rights reserved.
//

#import "ViewController.h"
#import "Account.h"
@interface ViewController ()

@property (strong ,nonatomic) Account *account;


@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;


- (IBAction)withdraw:(id)sender;

- (IBAction)deposit:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.account = [[Account alloc]init];
    [self updateBalanceLabel];
}

- (IBAction)withdraw:(id)sender {
    static int a = 0;
    NSLog(@">>>>>>  减了一百%d",a++);
    __weak __typeof(self)weakSelf = self;
    [self.account withdraw:100 success:^() {
        typeof(self) __strong strongSelf = weakSelf;
        [strongSelf  updateBalanceLabel];
    }];
}

- (IBAction)deposit:(id)sender {
    static int a = 0;
    NSLog(@">>>>>>  加了一百%d",a++);

    __weak __typeof(self)weakSelf = self;
    [self.account deposit:100 success:^() {
        typeof(self) __strong strongSelf = weakSelf;
        [strongSelf  updateBalanceLabel];
    }];

}

- (void)updateBalanceLabel{
    self.balanceLabel.text  = [NSString stringWithFormat:@"balance %ld",(long)self.account.balance];
}
@end
