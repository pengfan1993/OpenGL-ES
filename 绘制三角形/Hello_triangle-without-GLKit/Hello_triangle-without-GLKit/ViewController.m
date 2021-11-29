//
//  ViewController.m
//  OpenGLES_CH_2
//
//  Created by pengfan on 2021/11/23.
//

#import "ViewController.h"
#include "Hello_triangle.h"
@interface ViewController() {
    ESContext _esContext;
}
@property(nonatomic,strong)EAGLContext *context;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化对象，这里选用 opengl-es 3.0版本
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    NSAssert(self.context != nil, @"failed to initialized an EAGLCcontext");
    
    //为当前的GLKView对象设置上下文
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
    
}
- (void)setupGL {
    [EAGLContext setCurrentContext:self.context];
    
    memset(&_esContext, 0, sizeof(_esContext));
    
    esMain(&_esContext);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    _esContext.width = view.drawableWidth;
    _esContext.height = view.drawableHeight;
    if (_esContext.drawFunc) {
        _esContext.drawFunc(&_esContext);
    }
    
}
- (void)tearDownGL {
    [EAGLContext setCurrentContext: self.context];
    
    if (_esContext.shutdownFunc) {
        _esContext.shutdownFunc(&_esContext);
    }
}
- (void)dealloc {
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && (self.view.window == nil)) {
        self.view = nil;
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
}
@end
