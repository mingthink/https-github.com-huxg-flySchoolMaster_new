//
//  FuncPublic.h
//  MaiTian
//
//  Created by 谌 安 on 13-3-1.
//  Copyright (c) 2013年 MaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
@class UpVC;
@class DownVC;
@interface FuncPublic : NSObject
{
    UIActivityIndicatorView* spin;          //风火轮
    NSMutableArray*         _NavigationArray;       //所有navigation保存数组
    int                     _CurrentShowNavigationIndex;//当前所显示的界面 0:home界面
    
    BOOL                    _IsHomeEnter;   //是否从主页进入
    
    UpVC*                   upVC;
    DownVC*                 downVC; 
}
@property(nonatomic,retain)UIActivityIndicatorView* spin;
@property(nonatomic,retain)NSMutableArray* _NavigationArray;
@property(nonatomic,assign)int             _CurrentShowNavigationIndex;
@property(nonatomic,assign)BOOL            _IsHomeEnter;
@property(nonatomic,retain)UpVC*           upVC;
@property(nonatomic,retain)DownVC*         downVC;
+(FuncPublic*)SharedFuncPublic;
#pragma mark 打开及关闭风火轮
-(void)StartActivityAnimation:(UIViewController*)target;
-(void)StopActivityAnimation;
#pragma mark 打开及关闭风火轮   end------------

+(NSString *)getDvid;
+ (NSString *)createUUID;

/*
 IOS7坐标移位
 */
+(int)IosPosChange:(int)Num;


/*
 *获得机型宽高
 */
+(CGRect)GetSceneRect;
/*
 *将控件添加到windows上   控件的x坐标需要设定为－100
 *view:需要添加到windows上面。显示在最上面的view
 */
+(void)ViewAddToWindows:(UIView*)view;
+ (CGAffineTransform)transformForOrientation;
/*
 *保存default信息
 *srt:需保存的文字
 *key:关键字
 */
+(void)SaveDefaultInfo:(id)str Key:(NSString*)_key;
/*
 *获得保存default信息
 *key:关键字
 */
+(id)GetDefaultInfo:(NSString*)_key;
/*
 * str:需显示的信息
 */
+(void)ShowAlert:(NSString*)str;
/*
 * _path  =   路径
 */
+(NSString*)GetNewPhotoUrl:(NSString*)_path;
/*
 *  name:文件名
 *  ext:后缀
 */
+(UIImage*)CreatedImageFromFile:(NSString *)name ofType:(NSString *)ext;

/*
 * 通过iphone的坐标得到 与误差坐标，得到 二个值
 * IphoneRect:最初坐标
 * num:误差值
 * _kind: 1:X变 2：y变 3：w变 4: h变 5：x w 变 6： y h 变
 */
+(CGRect)Iphone5OrIphone4:(CGRect)IphoneRect Num:(float)_num Kind:(int)_kind;
/*
 *通过尺寸获得size
 * IphoneSize:最初坐标
 * num:误差值
 * _kind: 1:w变 2：h变
 */
+(CGSize)SizeByIphone:(CGSize)IphoneSize  Num:(float)_num Kind:(int)_kind;
/*
 * 攻能：图片等比例缩放，上下左右留白
 * size:缩放的width,height
 * _pimage:需要改变的图片
 */
+(UIImage*)scaleToSize:(CGSize)size ParentImage:(UIImage*)_PImage;
/*
 *  实例image
 *FileNmae:图片文件名
 *ect:图片后缀名
 *_rect:位置
 *target:父类
 *_index:tag
 *
 */
+(UIImageView*)InstanceImageView:(NSString*)FileName  Ect:(NSString*)ect  RECT:(CGRect)_rect Target:(id)target TAG:(int)_index;
 
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
+(UIButton*)InstanceButton:(NSString*)FileName Ect:(NSString*)ect RECT:(CGRect)_rect AddView:(UIView*)view ViewController:(UIViewController*)VC SEL_:(SEL)_sel Kind:(int)_Kind  TAG:(int)_index;
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
+(UILabel*)InstanceLabel:(NSString*)_Info RECT:(CGRect)_rect FontName:(NSString*)Name Red:(CGFloat)_red green:(CGFloat)green blue:(CGFloat)blue  FontSize:(int)_FontSize Target:(id)target Lines:(int)_lines TAG:(int)_index Ailgnment:(int)_ailgnment;

/*
 *  将指定控件移到当前最上层
 *  _view:需要改变的view
 *  _index:需要移动到最上层的索引
 */
+(void)MoveUIToTop:(UIView*)_view Index:(int)_index;
/*
 * label:需要改变的label地址
 * name:字体名字
 * _red：红色值
 * green：绿色值
 * blue: 蓝色值
 * _fontsize:字体大小
 */
+(void)ChangeLable:(UILabel**)label FontName:(NSString*)Name Red:(CGFloat)_red green:(CGFloat)green blue:(CGFloat)blue  FontSize:(int)_FontSize;
/*
 *  动画移位
 * _rect:需要移动到的位置
 * _view:需要移动的视图
 * _duration:动画时间
 * _str:动画名
 * sel:移动完成后返回的方法
 */
+(void)Translation:(CGRect)_rect Image:(UIView*)_view Duration:(float)_Duration Str:(NSString*)_str Select:(SEL)sel
             tager:(id)_tager;

/*
 *获得navigationarray的实例
 */
+(NSMutableArray*)NavigationArray;
/*
 *通过name实例类，并添加navigation
 *Name:类名
 *_nav:保存navigation
 *_pvc:父类
 */
+(void)InstanceVC:(NSString*)Name ParentVC:(UIViewController*)_pVC;
 
//edit an.chen
/*
 *移除动画
 */
+(void)RemoveWindowsAnimation;  

+(NSString*) md5:( NSString *)str;
/*
 *通过毫秒获得日期
 */
+(NSString*)StringTimeToDate:(NSString*)str;
/*
 *转字符串 网络支持格式 转化为网络上可以传输的标准格式
 */
+ (NSString *) urlEncoderString:(NSString *)str; 
/*
 dict:  字典文件
 key:   关键字
 kind:  种类  1:string 2:NSMutableArray 3:NSMutableDictionary
 */
+(id)tryObject:(NSMutableDictionary*)dict Key:(NSString*)key Kind:(int)kind;

//为空判断
+(BOOL)IsEmpty:(id)str;


// 保存任意数据到本地“FileDocuments”目录
+ (void)saveDataToLocal:(id)data toFileName:(NSString *)filename;

// 读取本地“FileDocuments”目录下的文件
+ (NSString *)readFileOfFileDocuments:(NSString *)filename;

//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string;

//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string;

+(NSString *)emptyStr:(id)str;

+(void)showMessage:(UIViewController *)viewController Msg:(NSString *)msg BtnTitle:(NSString *)title action:(SEL)action close:(SEL)action;
+(void)InstanceNavgationBar:(NSString *)title action:(SEL)action superclass:(UIViewController *)controll isroot:(BOOL)isroot;
@end
