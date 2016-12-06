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
    
    
    //滥用 @synchronized (self) 会很危险，因为所有同步块都会彼此抢夺同一个锁。要是有很多属性都这样写，那么每个属性的同步块都要等待其他所有同步块执行完毕才能执行，其实我们只是想要每个属性各自独立的同步
    //实用@synchronized (self)从某种程度上来说，是线程安全的，但却无法保证访问该对象时是线程安全的。当然，访问属性的操作确实是原子的。实用属性时，确实能从中获取有效值，然而在同一个线程上多次调用getter方法，每次获取的结果却是未必相同的。在两次访问操作之间，可能有其他线程写入了新的值。
    //解决方案： 将写入操作和读取操作放在同一个线程中执行，保证数据同步。
    //dispatch_barrier在并发队列中创建一个同步点，当并发队列中遇到一个 dispatch_barrier时，会延时执行该 dispatch_barrier，等待在 dispatch_barrier之前提交的任务block执行完后才开始执行，之后，并发队列继续执行后续block任务。
    //在队列中，栅栏块必须单独执行，不能和其他块并行。并发队列如果发现接下来要处理的块是个栅栏块，那么就一直等待当前所有兵法块都执行完毕，才会单独执行这个栅栏块。等待栅栏块执行过后，再按正常方式继续向下执行。
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
