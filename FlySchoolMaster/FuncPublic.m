//
//  FuncPublic.m
//  MaiTian
//
//  Created by 谌 安 on 13-3-1.
//  Copyright (c) 2013年 MaiTian. All rights reserved.
//

#import "FuncPublic.h" 
#import "MTAppDelegate.h"
#import <CommonCrypto/CommonDigest.h>

FuncPublic * _funcPublic    =   nil;
@implementation FuncPublic
@synthesize spin;
@synthesize _NavigationArray;
@synthesize _CurrentShowNavigationIndex;
@synthesize _IsHomeEnter;
@synthesize upVC;
@synthesize downVC;
+(FuncPublic*)SharedFuncPublic
{
    if( _funcPublic == nil )
    {
        _funcPublic =   [[FuncPublic alloc] init];
        _funcPublic._IsHomeEnter    =   YES;
    }
    return _funcPublic;
}
#pragma mark 打开及关闭风火轮
-(void)StartActivityAnimation:(UIViewController*)target
{
    if( self.spin != nil )
    {
        [self.spin removeFromSuperview];
        self.spin   =   nil;
    }
    spin=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spin.color=[UIColor darkGrayColor];
    spin.center=CGPointMake([FuncPublic GetSceneRect].size.width/2, [FuncPublic GetSceneRect].size.height/2);
    [target.view addSubview:spin];
    [target.view bringSubviewToFront:self.spin];
    [self.spin startAnimating];
}
-(void)StopActivityAnimation
{
    [self.spin stopAnimating];
}
#pragma mark 打开及关闭风火轮   end------------
/*
 *获得机型宽高
 */
+(CGRect)GetSceneRect
{
    return [[UIScreen mainScreen] bounds];
}
/*
 *将控件添加到windows上   控件的x坐标需要设定为－100
 *view:需要添加到windows上面。显示在最上面的view
 */
+(void)ViewAddToWindows:(UIView*)view
{

    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    view.transform = CGAffineTransformScale([FuncPublic transformForOrientation], 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    view.transform = CGAffineTransformScale([FuncPublic transformForOrientation], 1, 1);
    [UIView commitAnimations];
    //view.frame   =   CGRectMake(-100, 0, [FuncPublic GetSceneRect].size.width, [FuncPublic GetSceneRect].size.height);
    [window addSubview:view];
}
+ (CGAffineTransform)transformForOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}
#pragma mark 实例屏保 end----------
 
+(int)IosPosChange:(int)Num
{
    if(IS_IPHONE_7)
    {
        return Num;
    }
    return 0;
}

/*
 *保存default信息
 *srt:需保存的文字
 *key:关键字
 */
+(void)SaveDefaultInfo:(id)str Key:(NSString*)_key
{
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    
    [standardUserDefault setValue:str forKey:_key];
    
    [standardUserDefault synchronize];
}
/*
 *获得保存default信息
 *key:关键字
 */
+(id)GetDefaultInfo:(NSString*)_key
{
    id temp  =     [[NSUserDefaults standardUserDefaults] objectForKey:_key];
    if(  temp == nil )
    {
        return nil;
    }
    return temp;
}
/*
 * str:需显示的信息
 */
+(void)ShowAlert:(NSString*)str
{
    UIAlertView* alert  =   [[UIAlertView alloc] initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
    [alert show];
}
/*
 * _path  =   图片路径
 */
+(NSString*)GetNewPhotoUrl:(NSString*)_path
{//edit an.chen
    return [NSString stringWithFormat:@"%@?t=picture&i=%@",SERVER,_path];
}
/*
 *  name:文件名
 *  ext:后缀
 */
+(UIImage*)CreatedImageFromFile:(NSString *)name ofType:(NSString *)ext
{
    //return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:ext]];
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@.%@",name,ext]];
}

/*
 * 通过iphone的坐标得到 与误差坐标，得到 二个值
 * IphoneRect:最初坐标
 * num:误差值
 * _kind: 1:X变 2：y变 3：w变 4: h变 5：x w 变 6： y h 变
 */
+(CGRect)Iphone5OrIphone4:(CGRect)IphoneRect Num:(float)_num Kind:(int)_kind
{
    if( IS_IPHONE_5 )
    {
        return IphoneRect;
    }
    CGRect tempRect =   CGRectZero;
    switch (_kind) {
        case 1:
            tempRect    =   CGRectMake(IphoneRect.origin.x + _num, IphoneRect.origin.y,
                                       IphoneRect.size.width, IphoneRect.size.height);
            break;
        case 2:
            tempRect    =   CGRectMake(IphoneRect.origin.x , IphoneRect.origin.y+ _num,
                                       IphoneRect.size.width, IphoneRect.size.height);
            break;
        case 3:
            tempRect    =   CGRectMake(IphoneRect.origin.x, IphoneRect.origin.y,
                                       IphoneRect.size.width+ _num, IphoneRect.size.height);
            break;
        case 4:
            tempRect    =   CGRectMake(IphoneRect.origin.x, IphoneRect.origin.y,
                                       IphoneRect.size.width, IphoneRect.size.height + _num);
            break;
        case 5:
            tempRect    =   CGRectMake(IphoneRect.origin.x + _num, IphoneRect.origin.y,
                                       IphoneRect.size.width + _num, IphoneRect.size.height);
            break;
        case 6:
            tempRect    =   CGRectMake(IphoneRect.origin.x, IphoneRect.origin.y + _num,
                                       IphoneRect.size.width, IphoneRect.size.height + _num);
            break;
        default:
            break;
    }
    return tempRect;
}
/*
 * 攻能：图片等比例缩放，上下左右留白
 * size:缩放的width,height
 * _pimage:需要改变的图片
 */
+(UIImage*)scaleToSize:(CGSize)size ParentImage:(UIImage*)_PImage
{
    CGFloat width = CGImageGetWidth(_PImage.CGImage);
    CGFloat height = CGImageGetHeight(_PImage.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [_PImage drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}
/*
 *通过尺寸获得size
 * IphoneSize:最初坐标
 * num:误差值
 * _kind: 1:w变 2：h变
 */
+(CGSize)SizeByIphone:(CGSize)IphoneSize  Num:(float)_num Kind:(int)_kind
{
    if( IS_IPHONE_5 )
    {
        return IphoneSize;
    }
    CGSize tempSize =   CGSizeZero;
    switch (_kind) {
        case 1:
        {
            tempSize    =   CGSizeMake(IphoneSize.width+_num, IphoneSize.height);
        }
            break;
        case 2:
        {
            tempSize    =   CGSizeMake(IphoneSize.width, IphoneSize.height+_num);
        }
            break;
        default:
            break;
    }
    return tempSize;
}
#pragma mark- InstanceView
/*
 *  实例image
 *FileNmae:图片文件名
 *ect:图片后缀名
 *_rect:位置
 *target:父类
 *_index:tag
 */
+(UIImageView*)InstanceImageView:(NSString*)FileName Ect:(NSString*)ect  RECT:(CGRect)_rect Target:(id)target TAG:(int)_index
{
    UIImageView* view   =   [[UIImageView alloc] init];
    view.image =    [FuncPublic CreatedImageFromFile:FileName ofType:ect];
    view.frame =   _rect;
    view.tag            =   _index;
    [(UIView*)target addSubview:view];
    return view;
}
 

/*
 *FileNmae:正常状态按键文件名
 *ect:正常状态按键后缀名
 *
 *FileName2:按下状态文件名
 *ect2:按下状态后缀名
 *AddView:需要添加到的view，（有时可能直接需要view，所以增加了vc，用来做delegate）
 *ViewController:用于做button delegate
 *_rect:位置
 *_sel:方法
 *_Kind:1=setBackgroundImage 2= setImage
 *_index:tag
 */
+(UIButton*)InstanceButton:(NSString*)FileName Ect:(NSString*)ect  RECT:(CGRect)_rect AddView:(UIView*)view ViewController:(UIViewController*)VC SEL_:(SEL)_sel Kind:(int)_Kind  TAG:(int)_index
{
    
    UIButton* button    =   [UIButton buttonWithType:UIButtonTypeCustom];
    
        button.frame =   _rect;
 
    //button.backgroundColor  =   [UIColor redColor];
    if( _Kind == 1 )
    {
        if(![FileName isEqualToString:@""])
        {
            [button setBackgroundImage:[FuncPublic CreatedImageFromFile:FileName ofType:ect] forState:UIControlStateNormal];
        }
//        if(![FileName2 isEqualToString:@""])
//        {
//            [button setBackgroundImage:[FuncPublic CreatedImageFromFile:FileName2 ofType:ect2] forState:UIControlStateHighlighted];
//        }
    }
    else if(_Kind == 2 )
    {
        if(![FileName isEqualToString:@""])
        {
            [button setImage:[FuncPublic CreatedImageFromFile:FileName ofType:ect] forState:UIControlStateNormal];
        }
//        if(![FileName2 isEqualToString:@""])
//        {
//            [button setImage:[FuncPublic CreatedImageFromFile:FileName2 ofType:ect2] forState:UIControlStateHighlighted];
//        }
    }
    [button addTarget:VC action:_sel forControlEvents:UIControlEventTouchUpInside];
    button.tag  =  _index;
    [view addSubview:button];
    return button;
}
/*
 *实例label
 *_info:lable信息
 *_rect:位置
 *name:字体名字，没有则，不需要特别设置
 *_red:字体红色
 *green:字体绿色
 *blue:字体蓝色
 *_fontsize:字体大小
 *target:parent类
 *Lines:几行
 *_index:tag
 */
+(UILabel*)InstanceLabel:(NSString*)_Info RECT:(CGRect)_rect FontName:(NSString*)Name Red:(CGFloat)_red green:(CGFloat)green blue:(CGFloat)blue  FontSize:(int)_FontSize Target:(id)target Lines:(int)_lines TAG:(int)_index Ailgnment:(int)_ailgnment//1：中，2：左，3：右
{
    UILabel* label  =   [[UILabel alloc] initWithFrame:_rect];
    
   
        label.frame =   _rect;
    
    label.text      =   _Info;
    switch (_ailgnment) {
        case 1:
            label.textAlignment =   NSTextAlignmentCenter;
            break;
        case 2:
            label.textAlignment =   NSTextAlignmentLeft;
            break;
        case 3:
            label.textAlignment =   NSTextAlignmentRight;
            break;
        default:
            break;
    }
    label.backgroundColor   =   [UIColor clearColor];
    label.numberOfLines =  0;// _lines;
    [FuncPublic ChangeLable:&label FontName:Name Red:_red green:green blue:blue FontSize:_FontSize];
    if ([Name  isEqual: @""]) {
        label.font = [UIFont systemFontOfSize:_FontSize];
    }
    label.tag   =   _index;
    [(UIView*)target addSubview:label];
    //[label release];
    return label;
}
#pragma mark- other
/*
 *  将指定控件移到当前最上层
 *  _view:需要改变的view
 *  _index:需要移动到最上层的索引
 */
+(void)MoveUIToTop:(UIView*)_view Index:(int)_index
{
    for(UIView* item in _view.subviews )
    {
        if( _index == item.tag )
        {
            [_view bringSubviewToFront:item];
            return;
        }
    }
}
/*
 * label:需要改变的label地址
 * name:字体名字
 * _red：红色值
 * green：绿色值
 * blue: 蓝色值
 * _fontsize:字体大小
 */
+(void)ChangeLable:(UILabel**)label FontName:(NSString*)Name Red:(CGFloat)_red green:(CGFloat)green blue:(CGFloat)blue  FontSize:(int)_FontSize
{
    //edit an.chen
    if( [Name isEqualToString:@""] )
    {
        Name    =   @"Thonburi";
    }
    (*label).font       =   [UIFont fontWithName:Name size:_FontSize];
    (*label).textColor   =   [UIColor colorWithRed:_red/255 green:green/255 blue:blue/255 alpha:1];
}
/*
 *  动画移位
 * _rect:需要移动到的位置
 * _view:需要移动的视图
 * _duration:动画时间
 * _str:动画名
 * sel:移动完成后返回的方法
 */
+(void)Translation:(CGRect)_rect Image:(UIView*)_view Duration:(float)_Duration Str:(NSString*)_str Select:(SEL)sel
             tager:(id)_tager
{
    [UIView beginAnimations:_str context:NULL];
    //    //移动时间2秒
    [UIView setAnimationDuration:_Duration];
    //
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    //
    //    //图片持续移动
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:sel];
    [UIView setAnimationDelegate:_tager];
    //    //重新定义图片的位置和尺寸,位置
    _view.frame   =   _rect;
    //    //完成动画移动
    [UIView commitAnimations];
}

/*
 *获得navigationarray的实例
 */
+(NSMutableArray*)NavigationArray
{
    if( [FuncPublic SharedFuncPublic]._NavigationArray == nil )
    {
        [FuncPublic SharedFuncPublic]._NavigationArray  =   [[NSMutableArray alloc] init];
    }
    return [FuncPublic SharedFuncPublic]._NavigationArray;
}
/*
 *通过name实例类，并添加navigation
 *Name:类名
 *_nav:保存navigation
 *_pvc:父类
 */
+(void)InstanceVC:(NSString*)Name ParentVC:(UIViewController*)_pVC
{
    id temp    =   [[NSClassFromString(Name) alloc] initWithNibName:Name bundle:nil];
    [(UIViewController*)temp viewWillAppear:NO];
    NSMutableDictionary* dict   =   [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict setObject:temp forKey:@"Nav"];
    [dict setObject:Name forKey:@"ClassName"];
    [[FuncPublic NavigationArray] addObject:dict];
    //[dict release];
    //[temp release];
}
 
//edit an.chen
/*
 *移除动画
 */
+(void)RemoveWindowsAnimation
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    [window.layer removeAnimationForKey:@"aa"];
}

 
+(NSString*) md5:(NSString *)str

{
	
	const char *cStr = [str UTF8String];
	
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	
	CC_MD5( cStr, strlen(cStr), result );
	
    NSString* tmp = [NSString stringWithFormat:
                     
                     @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                     
                     result[0], result[1], result[2], result[3], result[4],
                     
                     result[5], result[6], result[7],
                     
                     result[8], result[9], result[10], result[11], result[12],
                     
                     result[13], result[14], result[15]
                     
                     ];
    
    tmp = [tmp lowercaseString];
	return tmp;
}

/*
 *通过毫秒获得日期
 */
+(NSString*)StringTimeToDate:(NSString*)str
{
    NSString* tem       =   str;//Date(1363190400000+0800)
    NSArray*    array   =   [tem componentsSeparatedByString:@"("];
    if( array > 0 )
    {
        NSString* string    =   [array objectAtIndex:1];
        NSArray*  array2    =   [string componentsSeparatedByString:@"+"];
        if( [array2 count] <= 1 )
        {
            return @"";
        }
        else if( [array2 count] > 1 )
        {
            NSString* NewStr    =   [array2 objectAtIndex:0];
            NSTimeInterval Time =   [NewStr longLongValue];
            NSDate *date    =   [NSDate dateWithTimeIntervalSince1970:Time/1000];
            NSDateFormatter* dateFormatter  =   [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd"];
            NSString *regStr = [dateFormatter stringFromDate:date];
            //[dateFormatter release];
            return regStr;
        }
        
    }
    return @"";
}

+(NSString *) urlEncoderString:(NSString *)str
{
    NSString *result = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                            (CFStringRef)str,
                                                                            NULL,
                                                                            (CFStringRef)@";/?:@&=$+{}<>,",
                                                                            kCFStringEncodingUTF8));
    /* 上面意思就是把 str转化为网络上可以传输的标准格式
     CFStringRef就是一个C语言的NSString类
     CF = CoreFoundation
     (CFStringRef)@";/?:@&=$+{}<>," 表示这些不用转化
     */
    return result;
} 

/*
 dict:  字典文件
 key:   关键字
 kind:  种类  1:string 2:NSMutableArray 3:NSMutableDictionary
 */
+(id)tryObject:(NSMutableDictionary*)dict Key:(NSString*)key  Kind:(int)kind
{
    id  temp    =   nil;
    switch (kind) {
        case 1:
            temp    =   @"";
            break;
        case 2:
            temp    =   [[NSMutableArray alloc] init];
            break;
        case 3:
            temp    =   [[NSMutableDictionary alloc] init];
            break;
        default:
            temp    =   @"";
            break;
    }
    
    @try {
        if (kind == 1) {
            NSString *str = (NSString *)[dict objectForKey:key];
            str = str==nil?@"":str;
            str = (NSNull *)str == [NSNull null]?@"":str;
            str = [NSString stringWithFormat:@"%@",str];
            temp = str;
        }else{
            temp    =   [dict objectForKey:key];
        }
    }
    @catch (NSException *exception) {
        
    }
    return  temp;
}
//为空判断
+(BOOL)IsEmpty:(id)string{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSString class]] && [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    } else {
        return NO;
    }

}

// 保存任意数据到本地“FileDocuments”目录
+ (void)saveDataToLocal:(id)data toFileName:(NSString *)filename {
    // 指向文件目录
    NSString *plistFilePath= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FileDocuments"];
    
    // 判断目录是否存在,不存在创建目录
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistFilePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:plistFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 文件保持路径
    NSString *filePath= [plistFilePath stringByAppendingPathComponent:filename];
    [data writeToFile:filePath atomically:YES];     //写入文件
}

// 读取本地“FileDocuments”目录下的文件
+ (NSString *)readFileOfFileDocuments:(NSString *)filename {
    // 指向文件目录
    NSString *plistFilePath= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FileDocuments"];
    
    // 文件路径
    NSString *filePath= [plistFilePath stringByAppendingPathComponent:filename];
    // 文件存在判断
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        // 读取文件
        return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    } else {
        return @"";
    }
}


+ (NSString *)createUUID
{
	// Create universally unique identifier (object)
	CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
	
	// Get the string representation of CFUUID object.
	NSString *uuidStr = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
	
	CFRelease(uuidObject);
	
	return uuidStr;
}
//判断是否为整形：
+(BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}


//判断是否为浮点形：
+(BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}


+(NSString *)emptyStr:(id)str{
    if ([FuncPublic IsEmpty:str]) {
        return @"";
    }else{
        return str;
    }
}

+(void)showMessage:(UIViewController *)viewController Msg:(NSString *)msg BtnTitle:(NSString *)title action:(SEL)action close:(SEL)close{
 
    UIView *dialogview = [[UIView alloc] initWithFrame:viewController.view.frame];
    dialogview.tag = dialogTag;
    [viewController.view addSubview:dialogview];
    
    [FuncPublic InstanceButton:@"" Ect:@"" RECT:CGRectMake(0, 0, DEVW, DEVH) AddView:dialogview ViewController:viewController SEL_:close Kind:1 TAG:0];
    
    [FuncPublic InstanceImageView:@"alpha" Ect:@"png" RECT:CGRectMake(0, 0, DEVW, DEVH) Target:dialogview TAG:0];
    
    UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    boxView.backgroundColor = [UIColor clearColor];
    [dialogview addSubview:boxView];
 
    UILabel *bgimg = [FuncPublic InstanceLabel:@"" RECT:CGRectMake(0, 0, 0, 0) FontName:@"" Red:0 green:0 blue:0 FontSize:12 Target:boxView Lines:0 TAG:0 Ailgnment:1];
   
    [FuncPublic InstanceImageView:@"dialog_title" Ect:@"png" RECT:CGRectMake(0, 0, 280, 29) Target:boxView TAG:0];
    
    UILabel *tit = [FuncPublic InstanceLabel:@"移动校园提示您" RECT:CGRectMake(20, 4, 200, 21) FontName:@"" Red:118 green:179 blue:87 FontSize:14 Target:boxView Lines:0 TAG:0 Ailgnment:2];
    [tit setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *msglabel = [FuncPublic InstanceLabel:msg RECT:CGRectMake(0, 0, 0, 0) FontName:@"" Red:147 green:147 blue:147 FontSize:14 Target:boxView Lines:0 TAG:0 Ailgnment:2];
     CGSize labelsize =  [msglabel.text sizeWithFont:msglabel.font constrainedToSize:CGSizeMake(183, 320) lineBreakMode:NSLineBreakByWordWrapping];
    msglabel.frame = CGRectMake(20, 38 , 240, labelsize.height);
    
    bgimg.frame = CGRectMake(0, 28, 280, labelsize.height+52);
    [bgimg setBackgroundColor:[UIColor whiteColor]];
    
    [FuncPublic InstanceImageView:@"dialog_bottom" Ect:@"png" RECT:CGRectMake(0, 80+labelsize.height, 280, 5) Target:boxView TAG:0];
    
    UIButton *btn = [FuncPublic InstanceButton:@"setting_btn_bg" Ect:@"png" RECT:CGRectMake(50, labelsize.height+45, 180, 30) AddView:boxView ViewController:viewController SEL_:action Kind:1 TAG:0];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    
    boxView.frame = CGRectMake(20,(DEVH-labelsize.height-80)/2, 280, labelsize.height+80);
} 

@end
