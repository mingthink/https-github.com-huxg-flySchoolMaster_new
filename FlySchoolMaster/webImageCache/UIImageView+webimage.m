//
//  UIImageView+webimage.m
//  nanstreet
//
//  Created by 黄超 on 12-10-30.
//  Copyright (c) 2012年 shanchen. All rights reserved.
//

#import "UIImageView+webimage.h"

@implementation UIImageView (webimage)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager cancelForDelegate:self];
    
    self.image = [UIImage imageNamed:@"placeholder.jpg"];
    if (url)
    {
//        UIActivityIndicatorView *activi = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.frame.size.width-70)/2,(self.frame.size.height-70)/2, 70, 70)] ;
//        
//        activi.color=[UIColor blackColor];
//        activi.tag=1238;
//        [self addSubview:activi];
//        [activi startAnimating];
//        [activi release];
//        if (self.frame.size.height==0) {
//            activi.alpha=0;
//        }
        
        [manager downloadWithURL:url delegate:self options:options];
        
        [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(LoadTimeout:) userInfo:nil repeats:NO];
    }
}

- (void)setLoadingImageWithURL:(NSURL *)url placeholderImage:(NSString *)placeholder
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager cancelForDelegate:self];
    
//    self.image = [FuncPublic CreatedImageFromFile:placeholder ofType:@"jpg"];
    if (url) {
        [manager downloadWithURL:url delegate:self options:0];
        
        [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(LoadTimeout:) userInfo:nil repeats:NO];
    }
}

-(void)LoadTimeout:(id)sender
{
//    UIActivityIndicatorView* activi =   (UIActivityIndicatorView*)[self viewWithTag:1238];
//    [activi stopAnimating];
    if( self.image == nil )
        self.image  = [UIImage imageNamed:@"placeholder.jpg"];
}
- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.alpha=0;
    self.image = image;
//    UIActivityIndicatorView *activi=(UIActivityIndicatorView *)[self viewWithTag:1238];
//    [activi stopAnimating];
//    [activi removeFromSuperview];
    
    [UIView beginAnimations:nil context:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.8];
    self.alpha=1;
    [UIView commitAnimations];
    
}

@end
