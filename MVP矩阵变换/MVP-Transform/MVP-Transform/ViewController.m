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
    _elapsedTime += 0.02;
    float varyFactor =  (sin(self.elapsedTime) + 1) / 2.0; //0 ~ 1
    _esContext.width = view.drawableWidth;
    _esContext.height = view.drawableHeight;
    
    // x, y, z, r, g, b,每一行存储一个点的信息，位置和颜色
    static GLfloat triangleData[24] = {
           -0.5f,    0.5f,  0.0f,  1.0f,  0.0f,  0.0f,
           -0.5f,   -0.5f,  0.0f,  0.0f,  1.0f,  0.0f,
            0.5f,   -0.5f,  0.0f,  0.0f,  0.0f,  1.0f,
            0.5f,    0.5f,  0.0f,  1.0f,  0.0f,  0.0f,
        };
    glClear(GL_COLOR_BUFFER_BIT);
    
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), view.frame.size.width / view.frame.size.height, 0.2, 10.0);
    
    
    GLKMatrix4 cameraMatrix = GLKMatrix4MakeLookAt(0, 0, 2 * (varyFactor + 1), 0, 0, 0, 0, 1, 0);
    
    //1.第一个模型变换
    //往x轴平移0.7
    GLKMatrix4 translate = GLKMatrix4MakeTranslation(0.7, 0, 0);
                        
    //随着时间绕着Y轴旋转
    GLKMatrix4 rotate = GLKMatrix4MakeRotation(varyFactor * M_PI * 2, 0, 0, 1);
                    
    GLKMatrix4 modelMatrix = GLKMatrix4Multiply(translate, rotate);
    
    //2.第二个模型变换
    GLKMatrix4 translate1 = GLKMatrix4MakeTranslation(-0.7, 0, 0 );
    GLKMatrix4 rotate1    = GLKMatrix4MakeRotation(varyFactor * M_PI * 2, 0, 1, 0);
    GLKMatrix4 modelMatrix1 = GLKMatrix4Multiply(translate1, rotate1);
    
    //加载统一变量
    GLuint modelMatrixIndex = glGetUniformLocation(_esContext.program, "modelTransform");
    GLuint viewMatrixIndex = glGetUniformLocation(_esContext.program, "viewTransform");
    GLuint projectMatrixIndex = glGetUniformLocation(_esContext.program, "projectTransform");
    
    //加载统一变量
    glUniformMatrix4fv(modelMatrixIndex, 1, GL_FALSE, modelMatrix.m);
    
    glUniformMatrix4fv(projectMatrixIndex, 1, GL_FALSE, projectionMatrix.m);
    
    glUniformMatrix4fv(viewMatrixIndex, 1, GL_FALSE, cameraMatrix.m);
    
    //gen Buffer and Bind
    if (_vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
        glBufferData(GL_ARRAY_BUFFER, sizeof(triangleData), triangleData, GL_STATIC_DRAW);
    }
    
    int positionLocation = glGetAttribLocation(_esContext.program, "vPosition");
    int colorLocation = glGetAttribLocation(_esContext.program, "vColor");
   
    glEnableVertexAttribArray(positionLocation);
    glEnableVertexAttribArray(colorLocation);
    
    GLuint offset  = 3 * sizeof(float);
    
    //加载顶点属性数据
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), NULL);
    glVertexAttribPointer(colorLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (const void *) offset);
    _esContext.drawFunc(&_esContext);
    
    glUniformMatrix4fv(modelMatrixIndex, 1, GL_FALSE, modelMatrix1.m);
    _esContext.drawFunc(&_esContext);
    
    glDisableVertexAttribArray(positionLocation);
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
