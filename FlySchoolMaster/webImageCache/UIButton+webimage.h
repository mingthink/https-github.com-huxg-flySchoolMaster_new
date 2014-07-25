//
//  UIButton+webimage.h
//  PhotographyAssociation
//
//  Created by 黄超 on 13-2-20.
//  Copyright (c) 2013年 shangc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManagerDelegate.h"
#import "SDWebImageManager.h"
@interface UIButton (webimage)<SDWebImageManagerDelegate>
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@end
