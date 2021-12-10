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
@property (nonatomic,strong)GLKTextureInfo *diffuseMap;
@property (nonatomic,strong)GLKTextureInfo *specularMap;
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.elapsedTime = 0;
    [self setupEGAL];
    [self loadDiffuseMap];
    [self loadSpecularMap];
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
- (void)loadDiffuseMap {
    NSString *diffusePath = [[NSBundle mainBundle] pathForResource:@"diffuse_map.png" ofType:nil];
    
    self.diffuseMap = [GLKTextureLoader textureWithContentsOfFile:diffusePath options:nil error:nil];
}
- (void)loadSpecularMap {
    NSString *specularPath = [[NSBundle mainBundle] pathForResource:@"specular_map.png" ofType:nil];
    
    self.specularMap = [GLKTextureLoader textureWithContentsOfFile:specularPath options:nil error:nil];
}

//绘制每个与X,Y,Z,-X,-Y,-Z轴垂直的面
- (void)drawPositiveXWithTextCoordLocation:(GLuint)textCoordLocation andPositionLocation:(GLuint)positionLocation andNormalLocation:(GLuint)normalLocation {
    //每一行代表(x,y,z,)（s,t） (Nx,Ny,Nz), 分别是 顶点/纹理坐标/法向量
    static GLfloat positiveX[] = {
        0.5f,  0.5f,  0.5f, 0.0f, 0.0f, 1.0 , 0.0 ,0.0,
        0.5f,  -0.5f, 0.5f, 0.0f, 1.0f, 1.0 , 0.0 ,0.0,
        0.5f, -0.5f, -0.5f, 1.0f, 1.0f, 1.0 , 0.0 ,0.0,
        0.5f, 0.5f,  -0.5f, 1.0f, 0.0f, 1.0 , 0.0 ,0.0,
        
    };
    
    if (self.vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(positiveX), positiveX, GL_STATIC_DRAW);
    
    GLuint offset1 = 3 * sizeof(float);
    GLuint offset2 = 5 * sizeof(float);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), NULL);
    glVertexAttribPointer(textCoordLocation, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (const void *) offset1);
    glVertexAttribPointer(normalLocation, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (const void *)offset2);
    
    _esContext.drawFunc(&_esContext);
    
}
-(void)drawNegativeXWithTextCoordLocation:(GLuint)textCoordLocation andPositionLocation:(GLuint)positionLocation andNormalLocation:(GLuint)normalLocation {
    //每一行代表(x,y,z,)（s,t） (Nx,Ny,Nz), 分别是 顶点/纹理坐标/法向量
    static GLfloat negativeX[] = {
        -0.5,  0.5,  0.5, 0.0f, 0.0f, -1.0 , 0.0 ,0.0,
        -0.5,  0.5, -0.5, 0.0f, 1.0f, -1.0 , 0.0 ,0.0,
        -0.5, -0.5, -0.5, 1.0f, 1.0f, -1.0 , 0.0 ,0.0,
        -0.5, -0.5,  0.5, 1.0f, 0.0f, -1.0 , 0.0 ,0.0,
    };
    
    if (self.vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(negativeX), negativeX, GL_STATIC_DRAW);
    
    GLuint offset1 = 3 * sizeof(float);
    GLuint offset2 = 5 * sizeof(float);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), NULL);
    glVertexAttribPointer(textCoordLocation, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (const void *) offset1);
    glVertexAttribPointer(normalLocation, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (const void *)offset2);
    
    _esContext.drawFunc(&_esContext);
}
-(void) drawPositiveYWithTextCoordLocation:(GLuint)textCoordLocation andPositionLocation:(GLuint)positionLocation andNormalLocation:(GLuint)normalLocation{
    //每一行代表(x,y,z,r,g,b)
    static GLfloat positiveY[] = {
        -0.5,   0.5,  -0.5, 0.0f, 0.0f, 0.0 , 1.0 ,0.0,
        -0.5,   0.5,   0.5, 0.0f, 1.0f, 0.0 , 1.0 ,0.0,
         0.5,   0.5,   0.5, 1.0f, 1.0f, 0.0 , 1.0 ,0.0,
         0.5,   0.5,  -0.5, 1.0f, 0.0f, 0.0 , 1.0 ,0.0,
        
    };
    
    if (self.vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(positiveY), positiveY, GL_STATIC_DRAW);
    
    GLuint offset1 = 3 * sizeof(float);
    GLuint offset2 = 5 * sizeof(float);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), NULL);
    glVertexAttribPointer(textCoordLocation, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (const void *) offset1);
    glVertexAttribPointer(normalLocation, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (const void *)offset2);
    
    _esContext.drawFunc(&_esContext);
}
- (void)drawNegativeYWithTextCoordLocation:(GLuint)textCoordLocation andPositionLocation:(GLuint)positionLocation andNormalLocation:(GLuint)normalLocation {
    //每一行代表(x,y,z,r,g,b)
    static GLfloat negativeY[] = {
        -0.5,  -0.5, -0.5, 0.0f, 0.0f, 0.0 , -1.0 ,0.0,
        -0.5,  -0.5,  0.5, 0.0f, 1.0f, 0.0 , -1.0 ,0.0,
         0.5,  -0.5,  0.5, 1.0f, 1.0f, 0.0 , -1.0 ,0.0,
         0.5,  -0.5, -0.5, 1.0f, 0.0f, 0.0 , -1.0 ,0.0,
        
    };
    
    if (self.vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(negativeY), negativeY, GL_STATIC_DRAW);
    
    GLuint offset1 = 3 * sizeof(float);
    GLuint offset2 = 5 * sizeof(float);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), NULL);
    glVertexAttribPointer(textCoordLocation, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (const void *) offset1);
    glVertexAttribPointer(normalLocation, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (const void *)offset2);
    
    _esContext.drawFunc(&_esContext);
}
- (void)drawPositiveZWithTextCoordLocation:(GLuint)textCoordLocation andPositionLocation:(GLuint)positionLocation andNormalLocation:(GLuint)normalLocation {
    //每一行代表(x,y,z,r,g,b)
    static GLfloat positiveZ[] = {
        -0.5,  0.5,  0.5, 0.0f, 0.0f, 0.0 , 0.0 ,1.0,
        -0.5, -0.5,  0.5, 0.0f, 1.0f, 0.0 , 0.0 ,1.0,
         0.5, -0.5,  0.5, 1.0f, 1.0f, 0.0 , 0.0 ,1.0,
         0.5,  0.5,  0.5, 1.0f, 0.0f, 0.0 , 0.0 ,1.0,
    };
    
    if (self.vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(positiveZ), positiveZ, GL_STATIC_DRAW);
    
    GLuint offset1 = 3 * sizeof(float);
    GLuint offset2 = 5 * sizeof(float);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), NULL);
    glVertexAttribPointer(textCoordLocation, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (const void *) offset1);
    glVertexAttribPointer(normalLocation, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (const void *)offset2);
    
    _esContext.drawFunc(&_esContext);
}
- (void)drawNegativeZWithTextCoordLocation:(GLuint)textCoordLocation andPositionLocation:(GLuint)positionLocation andNormalLocation:(GLuint)normalLocation {
    //每一行代表(x,y,z,r,g,b)
    static GLfloat negativeZ[] = {
        -0.5,  0.5, -0.5, 0.0f, 0.0f, 0.0 , 0.0 ,-1.0,
        -0.5, -0.5, -0.5, 0.0f, 1.0f, 0.0 , 0.0 ,-1.0,
         0.5, -0.5, -0.5, 1.0f, 1.0f, 0.0 , 0.0 ,-1.0,
         0.5,  0.5, -0.5, 1.0f, 0.0f, 0.0 , 0.0 ,-1.0,
        
    };
    
    
    
    if (self.vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(negativeZ), negativeZ, GL_STATIC_DRAW);
    
    GLuint offset1 = 3 * sizeof(float);
    GLuint offset2 = 5 * sizeof(float);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), NULL);
    glVertexAttribPointer(textCoordLocation, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (const void *) offset1);
    glVertexAttribPointer(normalLocation, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (const void *)offset2);
    
    _esContext.drawFunc(&_esContext);
    
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [super glkView:view drawInRect:rect];
    
    //这里没添加时间参数，绘制静止的
    
    _esContext.width = view.drawableWidth;
    _esContext.height = view.drawableHeight;
    
    
    //开启深度测试，为了确定绘制的时候哪一个面绘制在上面
    glEnable(GL_DEPTH_TEST);
    
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    //获取属性color和position的index
    GLint textCoordIndex = glGetAttribLocation(_esContext.program, "textCoord");
    GLint positionIndex = glGetAttribLocation(_esContext.program, "vPosition");
    GLint normalIndex = glGetAttribLocation(_esContext.program, "Normal");
    
    //创建MVP矩阵
    GLint modelIndex = glGetUniformLocation(_esContext.program, "modelTransform");
    GLint viewIndex = glGetUniformLocation(_esContext.program, "viewTransform");
    GLint projectIndex = glGetUniformLocation(_esContext.program, "projectTransform");
    GLint invertTransposeIndex = glGetUniformLocation(_esContext.program, "invertTransposeMatrix");
    GLint lightPosIndex = glGetUniformLocation(_esContext.program, "lightPos");
    GLint viewPosIndex = glGetUniformLocation(_esContext.program, "viewPos");
    
    GLKMatrix4 rotate = GLKMatrix4MakeRotation(M_PI * 0.12, 0,1,0);
    GLKMatrix4 rotate2 = GLKMatrix4MakeRotation(-M_PI * 0.05, 1, 0, 0);
    
    GLKMatrix4 modelMatrix = GLKMatrix4Multiply(rotate2, rotate);

    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), view.frame.size.width / view.frame.size.height, 0.2, 10.0);
    
    
    GLKMatrix4 cameraMatrix = GLKMatrix4MakeLookAt(0,-0.5, 2, 0, 0, 0, 0, 1, 0);
    
    //加载MVP矩阵
    glUniformMatrix4fv(modelIndex, 1, GL_FALSE, modelMatrix.m);
    glUniformMatrix4fv(viewIndex  , 1, GL_FALSE, cameraMatrix.m);
    glUniformMatrix4fv(projectIndex, 1, GL_FALSE, projectionMatrix.m);
    
    //加载法线变换矩阵
    BOOL canConvert = YES;
    GLKMatrix4 invertTransposeMatrix = GLKMatrix4InvertAndTranspose(modelMatrix, &canConvert);
    if (canConvert) {
        glUniformMatrix4fv(invertTransposeIndex, 1, GL_FALSE, invertTransposeMatrix.m);
    }
    
    //设置光源位置（世界空间坐标系）
    static float lightPos[3] = {0.4,0.1,1.2};
    
    //这里设置观察点为摄像机的位置(cameraMatrix里eye的位置)
    static float viewPos[3] = {0.0,-0.5,2.0};
    
    glUniform3fv(lightPosIndex, 1, lightPos);
    glUniform3fv(viewPosIndex, 1, viewPos);
    
    //设置材质
    glUniform3f(glGetUniformLocation(_esContext.program, "light.ambient"), 0.5, 0.5, 0.5);
    glUniform3f(glGetUniformLocation(_esContext.program, "light.diffuse"), 0.5, 0.5, 0.5);
    glUniform3f(glGetUniformLocation(_esContext.program, "light.specular"), 1.0, 1.0, 1.0);
    

    
    //设置光线属性
    //加载纹理
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, self.diffuseMap.name);
    glUniform1i(glGetUniformLocation(_esContext.program, "material.diffuseMap"), 0);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, self.specularMap.name);
    glUniform1i(glGetUniformLocation(_esContext.program, "material.specularMap"), 1);
    glUniform1f(glGetUniformLocation(_esContext.program, "material.shineness"), 16.0);
    
    //开启顶点属性
    glEnableVertexAttribArray(textCoordIndex);
    glEnableVertexAttribArray(positionIndex);
    glEnableVertexAttribArray(normalIndex);
    
    
    //加载顶点数据，并且依次绘制立方体的六个面
    [self drawPositiveXWithTextCoordLocation:textCoordIndex andPositionLocation:positionIndex andNormalLocation:normalIndex];
    [self drawNegativeXWithTextCoordLocation:textCoordIndex andPositionLocation:positionIndex andNormalLocation:normalIndex];
    [self drawPositiveYWithTextCoordLocation:textCoordIndex andPositionLocation:positionIndex andNormalLocation:normalIndex];
    [self drawNegativeYWithTextCoordLocation:textCoordIndex andPositionLocation:positionIndex andNormalLocation:normalIndex];
    [self drawPositiveZWithTextCoordLocation:textCoordIndex andPositionLocation:positionIndex andNormalLocation: normalIndex];
    [self drawNegativeZWithTextCoordLocation:textCoordIndex andPositionLocation:positionIndex andNormalLocation:normalIndex];
   
    //关闭顶点属性
    glDisableVertexAttribArray(normalIndex);
    glDisableVertexAttribArray(positionIndex);
    glDisableVertexAttribArray(textCoordIndex);
    glBindTexture(GL_TEXTURE_2D, 0);
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
