//
//  ViewController.m
//  HKRandomImagePhotoBrowser
//
//  Created by houke on 2017/12/18.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()
{
    NSDictionary *layout;
    NSArray *contentArr;
}

@end

@implementation ViewController
-(void)setData
{
    layout = @{
                             @"line_count": @5,
                             @"row_count": @3,
                             @"scale": @0.8
                             };
    contentArr = @[
                            @{
                              @"line_num": @0,
                              @"row_num": @0,
                              @"width": @2,
                              @"height": @2,
                              @"img": @"http://p1b0tkq2t.bkt.clouddn.com/c0978109-1998-4362-872d-22c6344600c2.gif",
                                },
                            @{
                                @"line_num": @2,
                                @"row_num": @0,
                                @"width": @1,
                                @"height": @1,
                                @"img": @"http://p1b0tkq2t.bkt.clouddn.com/u=169725531,3494195910&fm=200&gp=0.jpg",
                                },
                            @{
                                @"line_num": @3,
                                @"row_num": @0,
                                @"width": @2,
                                @"height": @2,
                                @"img": @"http://p1b0tkq2t.bkt.clouddn.com/u=1943249770,628140654&fm=200&gp=0.jpg",
                                },
                            @{
                                @"line_num": @2,
                                @"row_num": @1,
                                @"width": @1,
                                @"height": @1,
                                @"img": @"http://p1b0tkq2t.bkt.clouddn.com/u=1977804817,1381775671&fm=200&gp=0.jpg",
                                },
                            @{
                                @"line_num": @0,
                                @"row_num": @2,
                                @"width": @1,
                                @"height": @1,
                                @"img": @"http://p1b0tkq2t.bkt.clouddn.com/u=3002450272,3513177793&fm=200&gp=0.jpg",
                                },
                            @{
                                @"line_num": @1,
                                @"row_num": @2,
                                @"width": @1,
                                @"height": @1,
                                @"img": @"http://p1b0tkq2t.bkt.clouddn.com/u=3237130557,2380283222&fm=200&gp=0.jpg",
                                },
                            @{
                                @"line_num": @2,
                                @"row_num": @2,
                                @"width": @1,
                                @"height": @1,
                                @"img": @"http://p1b0tkq2t.bkt.clouddn.com/u=3556193862,2051987174&fm=27&gp=0.jpg",
                                },
                            @{
                                @"line_num": @3,
                                @"row_num": @2,
                                @"width": @1,
                                @"height": @1,
                                @"img": @"http://p1b0tkq2t.bkt.clouddn.com/u=618477273,3443545549&fm=27&gp=0.jpg",
                                },
                            @{
                                @"line_num": @4,
                                @"row_num": @2,
                                @"width": @1,
                                @"height": @1,
                                @"img": @"http://p1b0tkq2t.bkt.clouddn.com/u=619444398,63439158&fm=11&gp=0.jpg",
                                }
                            ];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self setData];
    [self makeRandomImageView];
    
}
-(void)makeRandomImageView
{
    CGFloat gap = 7;
    CGFloat totalWidth = SCREEN_WIDTH - 30;
    
    NSInteger lineCount = [[layout objectForKey:@"line_count"] integerValue];
    NSInteger rowCount = [[layout objectForKey:@"row_count"] integerValue];
    CGFloat imageWidthUnit = ((totalWidth-gap*(lineCount-1))/lineCount);
    float scale = [[layout objectForKey:@"scale"] floatValue];
    CGFloat imageHeightUnit = imageWidthUnit *scale;
    
    CGFloat origin_X ;
    CGFloat origin_Y ;
    CGFloat size_Width ;
    CGFloat size_Height ;
    for (NSUInteger i = 0; i < contentArr.count; i++) {
        
        NSInteger nLine = [[contentArr[i] valueForKey:@"line_num"] intValue];
        NSInteger nRow = [[contentArr[i] valueForKey:@"row_num"] intValue];
        origin_X = 15 +(imageWidthUnit+gap)*nLine;
        origin_Y = 100 +(imageHeightUnit+gap)*nRow;
        NSInteger unitWidth = [[contentArr[i] valueForKey:@"width"] intValue];
        NSInteger unitHeight = [[contentArr[i] valueForKey:@"height"] intValue];
        size_Width = imageWidthUnit*unitWidth+(unitWidth-1)*gap;
        size_Height = imageHeightUnit*unitHeight+(unitHeight-1)*gap ;
        
        UIImageView *imageView = [UIImageView new];
        imageView.tag = 10+i;
        imageView.backgroundColor = [UIColor redColor];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 4;
        imageView.frame = CGRectMake(origin_X, origin_Y, size_Width, size_Height);
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[contentArr[i] valueForKey:@"img"]]];
//        imageView.image = [UIImage imageNamed:[contentArr[i] valueForKey:@"img"]];
        [self.view addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
    }
}

-(void)imageViewTap:(UITapGestureRecognizer *)tap
{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i<contentArr.count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [contentArr[i] objectForKey:@"img"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = self.view.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = (tap.view.tag-10); // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
