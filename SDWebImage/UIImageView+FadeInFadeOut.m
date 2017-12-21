//
//  UIImageView+FadeInFadeOut.m
//  SDWebImage-FadeInFadeOut
//
//  Created by srx on 16/5/5.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import "UIImageView+FadeInFadeOut.h"

@implementation UIImageView (FadeInFadeOut)
- (void)sd_setImageFIFOWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholde {
    [self sd_setImageFIFOWithURL:url placeholderImage:placeholde  animateWithDuration:0.35f];
}

- (void)sd_setImageFIFOWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder animateWithDuration:(CGFloat)duration {
    
    [self sd_setImageFIFOWithURL:url placeholderImage:placeholder options:SDWebImageRefreshCached | SDWebImageCacheMemoryOnly | SDWebImageRetryFailed | SDWebImageLowPriority animateWithDuration:duration];
}

- (void)sd_setImageFIFOWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options animateWithDuration:(CGFloat)duration {
    
    [self sd_setImageWithURL:url  placeholderImage:placeholder options:options completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)  {
        
        if (image && cacheType == SDImageCacheTypeNone)  {
            CATransition *fadeIn = [CATransition animation];
            fadeIn.duration = duration;
            fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            fadeIn.subtype = kCATransitionFade;
            [self.layer addAnimation:fadeIn forKey:@"fadeIn"];
        }
        
    }];
}
- (void)sd_setHeadingTwoLineImageFIFOWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options withImageView:(UIImageView *)imageView animateWithDuration:(CGFloat)duration {
    
    [self sd_setImageWithURL:url  placeholderImage:placeholder options:options completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)  {
        
        if (image && cacheType == SDImageCacheTypeNone)  {
            CATransition *fadeIn = [CATransition animation];
            fadeIn.duration = duration;
            fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            fadeIn.subtype = kCATransitionFade;
            [self.layer addAnimation:fadeIn forKey:@"fadeIn"];
        }
        
        if (image != nil) {
            
            if (image.size.height/image.size.width>0.5) {
                CGRect rect = CGRectMake(0, 0, image.size.width, image.size.width/2);//创建矩形框
                CGImageRef cgimg = CGImageCreateWithImageInRect([image CGImage], rect);
                imageView.image=[UIImage imageWithCGImage:cgimg];
                CGImageRelease(cgimg);
            }
            if (image.size.width/image.size.height>2) {
                CGRect rect = CGRectMake(image.size.width/2-image.size.height, 0, image.size.height*2, image.size.height);//创建矩形框
                CGImageRef cgimg = CGImageCreateWithImageInRect([image CGImage], rect);
                imageView.image=[UIImage imageWithCGImage:cgimg];
                CGImageRelease(cgimg);
            }
           
        }
        
    }];
}

@end
