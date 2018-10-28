//
//  ViewController.m
//  DWQcommit
//
//  Created by 杜文全 on 16/5/10.
//  Copyright © 2016年 com.iOSDeveloper.duwenquan. All rights reserved.
//

#import "ViewController.h"
#import "DWQcommitController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    DWQRatingView *start2= [DWQRatingView initWithPoint:CGPointMake(self.view.bounds.size.width/2-70, 230) withSize:30 totalStart:3];
    
    [self.view addSubview:start2];
    start2.needIntValue=YES;
    
//    start2.scoreNum=@4;//星星显示个数
    
    start2.normalColorChain([UIColor redColor]);
    start2.highlightColorChian([UIColor greenColor]);
    
    start2.scroreBlock=^(NSNumber *number){
        NSLog(@"返回的分数:%@",number);
    };
    
}
- (IBAction)commit:(id)sender {
    
//    DWQCommitController *publishVC = [[DWQCommitController alloc] init];
//    [self presentViewController:publishVC animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
