//
//  ViewController.m
//  Matrix-Transform
//
//  Created by pengfan on 2021/11/26.
//

#import "ViewController.h"
#include "MatrixTransform.h"
@interface ViewController(){
    ESContext _esContext;
}
@property (nonatomic,strong)EAGLContext *context;
@property (nonatomic,assign)GLKMatrix4 transformMatrix;
@property (nonatomic,assign)GLuint vertexBufferId;
@property (nonatomic,assign)double elapsedTime;
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.elapsedTime = 0;
    [self setupEGAL];
}
- (void)setupEGAL {
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:_context];
    
    memset(&_esContext, 0, sizeof(_esContext));
    esMain(&_esContext);
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    _elapsedTime += 2.0;
    float varyFactor = GLKMathDegreesToRadians(_elapsedTime);
    _esContext.width = view.drawableWidth;
    _esContext.height = view.drawableHeight;
    
    // x, y, z, r, g, b,每一行存储一个点的信息，位置和颜色
    static GLfloat triangleData[36] = {
           -0.5f,    0.5f,  0.0f,  1.0f,  0.0f,  0.0f,
           -0.5f,   -0.5f,  0.0f,  0.0f,  1.0f,  0.0f,
            0.5f,   -0.5f,  0.0f,  0.0f,  0.0f,  1.0f,
            0.5f,    0.5f,  0.0f,  1.0f,  0.0f,  0.0f,
        };
    glClear(GL_COLOR_BUFFER_BIT);
    
    //x,y放大200倍，本来是展示的一个（1 * 1）像素点，需要将矩形显示出来
    GLKMatrix4 scale = GLKMatrix4MakeScale(300, 300, 300);
                        
    //随着时间绕着Y轴旋转
    GLKMatrix4 rotate = GLKMatrix4MakeRotation(varyFactor, 0, 1, 0);
        
    CGFloat width = view.frame.size.width / 2.0;
    CGFloat height = view.frame.size.height / 2.0;
    
    //正交投影(可视的Z轴范围是-10.0 ~ 10.0)
    GLKMatrix4 orthoMatrix = GLKMatrix4MakeOrtho(-width, width, -height, height, -10.0, 10.0);
    
    //注意顺序，先旋转，后平移，最后矩阵投影
    self.transformMatrix = GLKMatrix4Multiply(scale, rotate);
    self.transformMatrix = GLKMatrix4Multiply(orthoMatrix, self.transformMatrix);
    
    //加载统一变量
    GLuint uniformLocation = glGetUniformLocation(_esContext.program, "transform");
    glUniformMatrix4fv(uniformLocation, 1, GL_FALSE, self.transformMatrix.m);

    
    //gen Buffer and Bind
    if (_vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
        glBufferData(GL_ARRAY_BUFFER, sizeof(triangleData), triangleData, GL_STATIC_DRAW);
    }
    
    int colorLocation = glGetAttribLocation(_esContext.program, "vcolor");
   
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(colorLocation);
    
    GLuint offset  = 3 * sizeof(float);
    

    
    //加载顶点属性数据
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), NULL);
    glVertexAttribPointer(colorLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (const void *) offset);
    _esContext.drawFunc(&_esContext);
    
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(colorLocation);
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    if (_vertexBufferId != 0) {
        glDeleteBuffers(1, _vertexBufferId);
    }
    self.elapsedTime = 0;
    
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
    
    
}

@end
