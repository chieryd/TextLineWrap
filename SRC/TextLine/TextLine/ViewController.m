//
//  ViewController.m
//  TextLine
//
//  Created by HanDong Wang on 2018/4/17.
//  Copyright © 2018年 HanDong Wang. All rights reserved.
//

#import "ViewController.h"
#import "TextWithMoreDetailView.h"
#import "TextWithMoreDetailViewModel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet TextWithMoreDetailView *textView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *string1 = @"不谋万世者，不足谋一时。2016年3月，习近平总书记参加湖南代表团审议，在听取基层代表有关农业问题的意见建议后强调，要以科技为支撑走内涵式现代农业发展道路，实现藏粮于地、藏粮于技。同时，习近平总书记多次强调要保护农民种粮积极性，要让农业成为有奔头的产业。新时期，藏粮于技、藏粮于地、藏粮于民成为确保粮食安全的三个支柱。不谋万世者，不足谋一时。2016年3月，习近平总书记参加湖南代表团审议，在听取基层代表有关农业问题的意见建议后强调，要以科技为支撑走内涵式现代农业发展道路，实现藏粮于地、藏粮于技。同时，习近平总书记多次强调要保护农民种粮积极性";
    
//    NSString *string1 = @"shdfahufheuhadushfuahfuasdfhaugfuejfhasduhfasfeadsjfhaiuehuandsjkhfaheuhadshfiauefhajdskfajsdklfjasdklfjaejsianslkdfjak;jfeiojasdkjfkajeiakdsjfakhfiahefnsdjhfiaheansdjfhaiekandsfuiahsfeinakdshfiahiehnakdihfiehaidvcxzjdijvicxzjvidjvicxjihvlzghdl;cxhdisahvczxhkvhdhivzxkchkvhsadhvh;xkcvkzxkhvoih;jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjljjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjggggggggggggggggggggggggggggjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjggggggggggggg";
    
    TextWithMoreDetailViewModel *model = [[TextWithMoreDetailViewModel alloc] initWithString:string1
                                                                                 stringColor:[UIColor blackColor]
                                                                                  stringFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16.0]
                                                                       stringParagraphHeight:5
                                                                                numberOfLine:5
                                                                                       width:240.0f
                                                                                  moreString:@"查看更多"
                                                                             moreStringColor:[UIColor blueColor]
                                                                                  foldString:@"折叠"
                                                                             foldStringColor:[UIColor blueColor]
                                                                                        fold:YES];
    
    [self.textView setModel:model];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
