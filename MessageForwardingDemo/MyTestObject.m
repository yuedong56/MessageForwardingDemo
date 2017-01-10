//
//  MyTestObject.m
//  MessageForwardingDemo
//
//  Created by yuedongkui on 2017/1/9.
//  Copyright © 2017年 LY. All rights reserved.
//

// http://www.jianshu.com/p/fa29c920409d
// http://blog.csdn.net/wangweijjj/article/details/51888750
// http://blog.sina.com.cn/s/blog_8c87ba3b0102v006.html

// iOS黑魔法－Method Swizzling ：http://www.cocoachina.com/ios/20160121/15076.html

#import "MyTestObject.h"
#import <objc/runtime.h>

//转移的实现方法
void dynamicMethodIMP(id self, SEL _cmd)
{
    NSLog(@"dynamicMethodIMP");
}

@implementation MyTestObject

//- (void)resolveThisMethodDynamically;
//{
//    NSLog(@"resolveThisMethodDynamically!!!");
//}

#pragma mark 一号接盘侠：本类内实现（dynamicMethodIMP）
//1.实例方法
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    
//    if (sel == @selector(resolveThisMethodDynamically)) {
//        class_addMethod([self class], sel, (IMP)dynamicMethodIMP, "v@:");
////        class_addMethod([self class], sel, class_getMethodImplementation([self class], @selector(myInstanceMethod:)), "v@:");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}

//2.类方法
//+ (BOOL)resolveClassMethod:(SEL)sel {
//    if (sel == @selector(resolveThisMethodDynamically)) {
//        class_addMethod(object_getClass(self), sel, class_getMethodImplementation(object_getClass(self), @selector(myClassMethod:)), "v@:");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}

#pragma mark 二号接盘侠：将消息转给其他类(NoneClass)实现
////如果一号接盘侠未实现，则会走二号
//- (id)forwardingTargetForSelector:(SEL)aSelector
//{
//    NoneClass *noneClass = [[NoneClass alloc] init];
//    if ([noneClass respondsToSelector:aSelector]) {
//        return noneClass;
//    }
//    id obj = [super forwardingTargetForSelector:aSelector];
//    return obj;
//}

#pragma mark 三号接盘侠：灵活的将目标函数以其他形式执行，可以转发给多个对象
//在给程序添加消息转发功能以前，必须覆盖两个方法，即methodSignatureForSelector:和forwardInvocation:
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL selector = [anInvocation selector];
    
    NoneClass *noneCless = [[NoneClass alloc] init];
    if ([noneCless respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:noneCless];
    }
}

//methodSignatureForSelector:的作用在于为另一个类实现的消息创建一个有效的方法签名，必须实现，并且返回不为空的methodSignature，否则会crash。
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSString *sel = NSStringFromSelector(aSelector);
    if ([sel rangeOfString:@"set"].location == 0) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    else {
        return [NSMethodSignature signatureWithObjCTypes:"@@:"];
    }
}

//如果上述3个方法都没有来处理这个消息，就会进入 NSObject 的 -(void)doesNotRecognizeSelector:(SEL)aSelector 方法中，抛出异常。

@end








@implementation NoneClass

- (void)resolveThisMethodDynamically;
{
    SEL m = _cmd;
    NSLog(@"NoneClass - resolveThisMethodDynamically");
}

@end







