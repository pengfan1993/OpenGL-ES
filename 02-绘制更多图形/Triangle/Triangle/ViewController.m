//
//  ViewController.m
//  Triangle
//
//  Created by pengfan on 2021/11/26.
//

#import "ViewController.h"
@interface ViewController()
@property (nonatomic,assign)GLuint vertexBufferID;
@property (nonatomic,strong)EAGLContext *context;
@property (nonatomic,strong)GLKBaseEffect *baseEffect;
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEAGL];
    [self bindBuffer];
}
//初始化
- (void)setupEAGL {
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    NSAssert(self.context != nil, @"EAGLContext initialization failed!");
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    
    [EAGLContext setCurrentContext:self.context];
}

- (void)bindBuffer {
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    
    //顶点数据，这里创建四个顶点，以及颜色数据，为了更好区分三种不同方式绘制三角形的区别
    static GLfloat vertices[] = {
        -0.5f,0.0f,0.0f,  1.0f,0.0f,0.0f, //v0, (x,y,z,r,g,b)
        0.0f,-0.5f,0.0f,  0.0f,1.0f,0.0f, //v1, (x,y,z,r,g,b)
        0.5f,0.0f,0.0f,  0.0f,0.0f,1.0f,  //v2, (x,y,z,r,g,b)
        0.0f,0.5f,0.0f,  1.0f,1.0f,0.0f,  //v3, (x,y,z,r,g,b)
        
    };
    
    
    //设置当前图形上下文的背景颜色
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    
    //生成缓冲区，绑定数组缓冲区
    glGenBuffers(1, &_vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    if (0 != _vertexBufferID) {//清除缓冲对象
        glDeleteBuffers(1, &_vertexBufferID);
        _vertexBufferID = 0;
    }
    //置空
    [EAGLContext setCurrentContext:nil];
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [self.baseEffect prepareToDraw];
    glClear(GL_COLOR_BUFFER_BIT);
    
    //开启顶点属性数组(开启颜色和位置)
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    //这里vertices数组中，表示颜色的数据前还有三个float类型的表示位置的数据，所以这个偏移量就是这样计算
    GLuint offset = 3 * sizeof(float);
    
    //给顶点着色器传入数据
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 6, NULL);
    
    glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 6, (const void *)offset);
    
    
//    //以三角带的形式绘制点
//    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
//
//    //以三角扇形的形式绘制点
//    glDrawArrays(GL_TRIANGLES, 0, 4);
    
    //以三角形的形式绘制点
    glDrawArrays(GL_TRIANGLES, 0, 4);

    //设置线的宽度为5像素
    //glLineWidth(5);
    
//    //以直线带的方式绘制线段
//    glDrawArrays(GL_LINE_STRIP, 0, 4);
    
//    //以直线的方式绘制线段
//    glDrawArrays(GL_LINES, 0, 4);
    
    //以直线环的方式绘制线段
    //glDrawArrays(GL_LINE_LOOP, 0, 4);
    
    glDisableVertexAttribArray(GLKVertexAttribColor);
    glDisableVertexAttribArray(GLKVertexAttribPosition);
}
@end
