//
//  UIButton+webimage.m
//  PhotographyAssociation
//
//  Created by 黄超 on 13-2-20.
//  Copyright (c) 2013年 shangc. All rights reserved.
//

#import "UIButton+webimage.h"

@implementation UIButton (webimage)
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    //self.image = placeholder;
    [self setImage:placeholder forState:UIControlStateNormal];
    if (url)
    {
        UIActivityIndicatorView *activi = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.frame.size.width-70)/2,(self.frame.size.height-70)/2, 70, 70)] ;
        
        activi.color=[UIColor blackColor];
        [self addSubview:activi];
        [activi startAnimating];
        [activi release];
        activi.tag=123456;
          
        [manager downloadWithURL:url delegate:self options:options];
    }
}
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.alpha=0; 
     [self setImage:image forState:UIControlStateNormal];
    UIActivityIndicatorView *activi=(UIActivityIndicatorView *)[self viewWithTag:123456];
    [activi stopAnimating];
    [activi removeFromSuperview];
    [UIView beginAnimations:nil context:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.8];
    self.alpha=1;
    [UIView commitAnimations];

    // self.bounds=CGRectMake(0, 0,320.0f, image.size.height*320/image.size.width);
    
    
}
- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error
{
    UIActivityIndicatorView *activi=(UIActivityIndicatorView *)[self viewWithTag:123456];
    [activi stopAnimating];
    [activi removeFromSuperview];
}
@end
