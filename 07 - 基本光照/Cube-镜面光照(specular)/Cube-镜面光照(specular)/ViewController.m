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

//绘制每个与X,Y,Z,-X,-Y,-Z轴垂直的面
- (void)drawPositiveXWithColorLocation:(GLuint)colorLocation andPositionLocation:(GLuint)positionLocation {
    //每一行代表(x,y,z,r,g,b)
    static GLfloat positiveX[24] = {
        0.5f,  0.5f,  0.5f, 1.0f, 0.0f, 0.0f,
        0.5f, -0.5f,  0.5f, 1.0f, 0.0f, 0.0f,
        0.5f, -0.5f, -0.5f, 1.0f, 0.0f, 0.0f,
        0.5f,  0.5f, -0.5f, 1.0f, 0.0f, 0.0f,
        
    };
    
    if (self.vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(positiveX), positiveX, GL_STATIC_DRAW);
    
    GLuint offset = 3 * sizeof(float);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), NULL);
    glVertexAttribPointer(colorLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (const void *) offset);
    
    _esContext.drawFunc(&_esContext);
    
}
-(void)drawNegativeXWithColorLocation:(GLuint)colorLocation andPositionLocation:(GLuint)positionLocation {
    //每一行代表(x,y,z,r,g,b)
    static GLfloat positiveX[] = {
        -0.5,  0.5,  0.5, -1.0f, 0.0f, 0.0f,
        -0.5,  0.5, -0.5, -1.0f, 0.0f, 0.0f,
        -0.5, -0.5, -0.5, -1.0f, 0.0f, 0.0f,
        -0.5, -0.5,  0.5, -1.0f, 0.0f, 0.0f,
        
    };
    
    if (self.vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(positiveX), positiveX, GL_STATIC_DRAW);
    
    GLuint offset = 3 * sizeof(float);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), NULL);
    glVertexAttribPointer(colorLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (const void *) offset);
    
    _esContext.drawFunc(&_esContext);
}
-(void)drawPositiveYWithColorLocation:(GLuint)colorLocation andPositionLocation:(GLuint)positionLocation{
    //每一行代表(x,y,z,r,g,b)
    static GLfloat positiveX[] = {
        -0.5,   0.5,  -0.5, 0.0f, 1.0f, 0.0f,
        -0.5,   0.5,   0.5, 0.0f, 1.0f, 0.0f,
         0.5,   0.5,   0.5, 0.0f, 1.0f, 0.0f,
         0.5,   0.5,  -0.5, 0.0f, 1.0f, 0.0f,
        
    };
    
    if (self.vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(positiveX), positiveX, GL_STATIC_DRAW);
    
    GLuint offset = 3 * sizeof(float);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), NULL);
    glVertexAttribPointer(colorLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (const void *) offset);
    
    _esContext.drawFunc(&_esContext);
}
- (void)drawNegativeYWithColorLocation:(GLuint)colorLocation andPositionLocation:(GLuint)positionLocation {
    //每一行代表(x,y,z,r,g,b)
    static GLfloat positiveX[] = {
        -0.5,  -0.5, -0.5, 0.0f, -1.0f, 0.0f,
        -0.5,  -0.5,  0.5, 0.0f, -1.0f, 0.0f,
         0.5,  -0.5,  0.5, 0.0f, -1.0f, 0.0f,
         0.5,  -0.5, -0.5, 0.0f, -1.0f, 0.0f,
        
    };
    
    if (self.vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(positiveX), positiveX, GL_STATIC_DRAW);
    
    GLuint offset = 3 * sizeof(float);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), NULL);
    glVertexAttribPointer(colorLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (const void *) offset);
    
    _esContext.drawFunc(&_esContext);
}
- (void)drawPositiveZWithColorLocation:(GLuint)colorLocation andPositionLocation:(GLuint)positionLocation {
    //每一行代表(x,y,z,r,g,b)
    static GLfloat positiveX[] = {
        -0.5,  0.5,  0.5, 0.0f, 0.0f, 1.0f,
        -0.5, -0.5,  0.5, 0.0f, 0.0f, 1.0f,
         0.5, -0.5,  0.5, 0.0f, 0.0f, 1.0f,
         0.5,  0.5,  0.5, 0.0f, 0.0f, 1.0f,
    };
    
    if (self.vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(positiveX), positiveX, GL_STATIC_DRAW);
    
    GLuint offset = 3 * sizeof(float);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), NULL);
    glVertexAttribPointer(colorLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (const void *) offset);
    
    _esContext.drawFunc(&_esContext);
}
- (void)drawNegativeZWithColorLocation:(GLuint)colorLocation andPositionLocation:(GLuint)positionLocation {
    //每一行代表(x,y,z,r,g,b)
    static GLfloat positiveX[] = {
        -0.5,  0.5, -0.5, 0.0f, 0.0f, -1.0f,
        -0.5, -0.5, -0.5, 0.0f, 0.0f, -1.0f,
         0.5, -0.5, -0.5, 0.0f, 0.0f, -1.0f,
         0.5,  0.5, -0.5, 0.0f, 0.0f, -1.0f,
        
    };
    
    
    
    if (self.vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(positiveX), positiveX, GL_STATIC_DRAW);
    
    GLuint offset = 3 * sizeof(float);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), NULL);
    glVertexAttribPointer(colorLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (const void *) offset);
    
    _esContext.drawFunc(&_esContext);
    
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [super glkView:view drawInRect:rect];

    //* 跟上一章例子相比，这里不做随时间改变的变换
    _esContext.width = view.drawableWidth;
    _esContext.height = view.drawableHeight;
    
    
    //开启深度测试，为了确定绘制的时候哪一个面绘制在上面
    glEnable(GL_DEPTH_TEST);
    
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    //获取Color和position的index
    GLint positionIndex = glGetAttribLocation(_esContext.program, "vPosition");
    GLint normalIndex = glGetAttribLocation(_esContext.program, "N");

    
    /*
     uniform mat4 modelTransform;
     uniform mat4 viewTransform;
     uniform mat4 projectTransform;
     **/
    //创建MVP矩阵
    GLint modelIndex = glGetUniformLocation(_esContext.program, "modelTransform");
    GLint viewIndex = glGetUniformLocation(_esContext.program, "viewTransform");
    GLint projectIndex = glGetUniformLocation(_esContext.program, "projectTransform");
    GLint lightColorIndex = glGetUniformLocation(_esContext.program, "lightColor");
    GLint lightPosIndex = glGetUniformLocation(_esContext.program, "lightPos");
    GLint invertTransposeIndex = glGetUniformLocation(_esContext.program, "invertTransposeMatrix");
    
    GLint viewposIndex = glGetUniformLocation(_esContext.program, "viewPos");
    
    
    GLKMatrix4 rotate = GLKMatrix4MakeRotation(M_PI * 0.3, 0,1,0);
    GLKMatrix4 rotate2 = GLKMatrix4MakeRotation(M_PI * 0.15, 1, 0, 0);
    
    GLKMatrix4 modelMatrix = GLKMatrix4Multiply(rotate2, rotate);
    
    
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), view.frame.size.width / view.frame.size.height, 0.2, 10.0);
    
    
    GLKMatrix4 cameraMatrix = GLKMatrix4MakeLookAt(0, 0, 2, 0, 0, 0, 0, 1, 0);
    
    
    //设置环境光颜色为白色
    static float light[3] = {1.0f, 1.0f, 1.0f};
    
    //设置光源位置（世界空间坐标系）
    static float lightPos[3] = {0.0,1.5,-1.5};
    
    //这里设置观察点为摄像机的位置(cameraMatrix里eye的位置)
    static float viewPos[3] = {0.0,0.0,2.0};
    
    
    //获取法线变换矩阵
    BOOL canConvert = YES;
    GLKMatrix4 invertTransposeMatrix = GLKMatrix4InvertAndTranspose(modelMatrix, &canConvert);
    
    //如果能获取到法线矩阵，就加载
    if (canConvert) {
        glUniformMatrix4fv(invertTransposeIndex, 1, GL_FALSE, invertTransposeMatrix.m);
    }
    
    //加载MVP矩阵
    glUniformMatrix4fv(modelIndex, 1, GL_FALSE, modelMatrix.m);
    glUniformMatrix4fv(viewIndex  , 1, GL_FALSE, cameraMatrix.m);
    glUniformMatrix4fv(projectIndex, 1, GL_FALSE, projectionMatrix.m);
    //设置光照颜色
    glUniform3fv(lightColorIndex, 1, light);
    //设置光源位置
    glUniform3fv(lightPosIndex, 1, lightPos);
    //设置观察点的位置
    glUniform3fv(viewposIndex, 1, viewPos);
    
    //开启顶点属性
    glEnableVertexAttribArray(normalIndex);
    glEnableVertexAttribArray(positionIndex);
    
    //加载顶点数据，并且依次绘制立方体的六个面
    [self drawPositiveXWithColorLocation:normalIndex andPositionLocation:positionIndex];
    [self drawNegativeXWithColorLocation:normalIndex andPositionLocation:positionIndex];
    [self drawPositiveYWithColorLocation:normalIndex andPositionLocation:positionIndex];
    [self drawNegativeYWithColorLocation:normalIndex andPositionLocation:positionIndex];
    [self drawPositiveZWithColorLocation:normalIndex andPositionLocation:positionIndex];
    [self drawNegativeZWithColorLocation:normalIndex andPositionLocation:positionIndex];
   
    //关闭顶点属性
    glDisableVertexAttribArray(normalIndex);
    glDisableVertexAttribArray(positionIndex);
    glDisable(GL_DEPTH_TEST);
    
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
