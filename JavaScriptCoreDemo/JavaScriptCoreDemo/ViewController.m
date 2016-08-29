//
//  ViewController.m
//  JavaScriptCoreDemo
//
//  Created by liuhaiyuan on 16/8/4.
//  Copyright © 2016年 liuhaiyuan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic)JSContext *jsContext;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:str]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)didOnClicked:(id)sender {
    
    NSString *alertJs=@"alert('Hello Word')";
    [self.jsContext evaluateScript:alertJs];
}

#pragma mark - UIWebViewDelegate 
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    _jsContext[@"startFunction"] =^(id obj){
        ////这里通过block回调从而获得h5传来的json数据
        /*block中捕获JSContexts
         我们知道block会默认强引用它所捕获的对象，如下代码所示，如果block中直接使用context也会造成循环引用，这使用我们最好采用[JSContext currentContext]来获取当前的JSContext:
         */
        [JSContext currentContext];
        NSData *data = [(NSString *)obj dataUsingEncoding:NSUTF8StringEncoding ];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@" data   %@   ======  ShareUrl %@",obj,dict[@"shareUrl"]);
    };
    
    __weak JSContext *context = self.jsContext;
    _jsContext[@"nslogInfo"] =^(id obj){
        ////这里通过block回调从而获得h5传来的json数据
        /*block中捕获JSContexts
         我们知道block会默认强引用它所捕获的对象，如下代码所示，如果block中直接使用context也会造成循环引用，这使用我们最好采用[JSContext currentContext]来获取当前的JSContext:
         */
//        [JSContext currentContext];
        JSValue *value = [context evaluateScript:@"nslogInfo"];
        NSLog(@"nslogInfo %@ Value %@", (NSString *)obj, value);
    };
    
    //
    _jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        //比如把js中的方法名改掉，OC找不到相应方法，这里就会打印异常信息
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

@end
