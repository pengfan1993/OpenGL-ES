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
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.elapsedTime = 0;
    [self setupEGAL];
    [self loadDiffuseMap];
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

//绘制每个与X,Y,Z,-X,-Y,-Z轴垂直的面
- (void)drawPositiveXWithTextCoordLocation:(GLuint)textCoordLocation andPositionLocation:(GLuint)positionLocation {
    //每一行代表(x,y,z,r,g,b)
    static GLfloat positiveX[24] = {
        0.5f,  0.5f,  0.5f, 0.0f, 0.0f,
        0.5f,  -0.5f, 0.5f, 0.0f, 1.0f,
        0.5f, -0.5f, -0.5f, 1.0f, 1.0f,
        0.5f, 0.5f,  -0.5f, 1.0f, 0.0f,
        
    };
    
    if (self.vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(positiveX), positiveX, GL_STATIC_DRAW);
    
    GLuint offset = 3 * sizeof(float);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), NULL);
    glVertexAttribPointer(textCoordLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (const void *) offset);
    
    _esContext.drawFunc(&_esContext);
    
}
-(void)drawNegativeXWithTextCoordLocation:(GLuint)textCoordLocation andPositionLocation:(GLuint)positionLocation {
    //每一行代表(x,y,z,r,g,b)
    static GLfloat negativeX[] = {
        -0.5,  0.5,  0.5, 0.0f, 0.0f,
        -0.5,  0.5, -0.5, 0.0f, 1.0f,
        -0.5, -0.5, -0.5, 1.0f, 1.0f,
        -0.5, -0.5,  0.5, 1.0f, 0.0f,
        
    };
    
    if (self.vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(negativeX), negativeX, GL_STATIC_DRAW);
    
    GLuint offset = 3 * sizeof(float);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), NULL);
    glVertexAttribPointer(textCoordLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (const void *) offset);
    
    _esContext.drawFunc(&_esContext);
}
-(void) drawPositiveYWithTextCoordLocation:(GLuint)textCoordLocation andPositionLocation:(GLuint)positionLocation{
    //每一行代表(x,y,z,r,g,b)
    static GLfloat positiveY[] = {
        -0.5,   0.5,  -0.5, 0.0f, 0.0f,
        -0.5,   0.5,   0.5, 0.0f, 1.0f,
         0.5,   0.5,   0.5, 1.0f, 1.0f,
         0.5,   0.5,  -0.5, 1.0f, 0.0f,
        
    };
    
    if (self.vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(positiveY), positiveY, GL_STATIC_DRAW);
    
    GLuint offset = 3 * sizeof(float);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), NULL);
    glVertexAttribPointer(textCoordLocation, 2, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (const void *) offset);
    
    _esContext.drawFunc(&_esContext);
}
- (void)drawNegativeYWithTextCoordLocation:(GLuint)textCoordLocation andPositionLocation:(GLuint)positionLocation {
    //每一行代表(x,y,z,r,g,b)
    static GLfloat negativeY[] = {
        -0.5,  -0.5, -0.5, 0.0f, 0.0f,
        -0.5,  -0.5,  0.5, 0.0f, 1.0f,
         0.5,  -0.5,  0.5, 1.0f, 1.0f,
         0.5,  -0.5, -0.5, 1.0f, 0.0f,
        
    };
    
    if (self.vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(negativeY), negativeY, GL_STATIC_DRAW);
    
    GLuint offset = 3 * sizeof(float);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), NULL);
    glVertexAttribPointer(textCoordLocation, 2, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (const void *) offset);
    
    _esContext.drawFunc(&_esContext);
}
- (void)drawPositiveZWithTextCoordLocation:(GLuint)textCoordLocation andPositionLocation:(GLuint)positionLocation {
    //每一行代表(x,y,z,r,g,b)
    static GLfloat positiveZ[] = {
        -0.5,  0.5,  0.5, 0.0f, 0.0f,
        -0.5, -0.5,  0.5, 0.0f, 1.0f,
         0.5, -0.5,  0.5, 1.0f, 1.0f,
         0.5,  0.5,  0.5, 1.0f, 0.0f,
    };
    
    if (self.vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(positiveZ), positiveZ, GL_STATIC_DRAW);
    
    GLuint offset = 3 * sizeof(float);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), NULL);
    glVertexAttribPointer(textCoordLocation, 2, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (const void *) offset);
    
    _esContext.drawFunc(&_esContext);
}
- (void)drawNegativeZWithTextCoordLocation:(GLuint)textCoordLocation andPositionLocation:(GLuint)positionLocation {
    //每一行代表(x,y,z,r,g,b)
    static GLfloat negativeZ[] = {
        -0.5,  0.5, -0.5, 0.0f, 0.0f,
        -0.5, -0.5, -0.5, 0.0f, 1.0f,
         0.5, -0.5, -0.5, 1.0f, 1.0f,
         0.5,  0.5, -0.5, 1.0f, 0.0f,
        
    };
    
    
    
    if (self.vertexBufferId == 0) {
        glGenBuffers(1, &_vertexBufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(negativeZ), negativeZ, GL_STATIC_DRAW);
    
    GLuint offset = 3 * sizeof(float);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), NULL);
    glVertexAttribPointer(textCoordLocation, 2, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (const void *) offset);
    
    _esContext.drawFunc(&_esContext);
    
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [super glkView:view drawInRect:rect];
    _elapsedTime += 0.02;
    //时间系数
    float varyFactor =  (sin(self.elapsedTime) + 1.0) / 2.0; //0 ~ 1
    _esContext.width = view.drawableWidth;
    _esContext.height = view.drawableHeight;
    
    
    //开启深度测试，为了确定绘制的时候哪一个面绘制在上面
    glEnable(GL_DEPTH_TEST);
    
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    //获取属性color和position的index
    GLint colorIndex = glGetAttribLocation(_esContext.program, "vColor");
    GLint positionIndex = glGetAttribLocation(_esContext.program, "vPosition");
    
    //创建MVP矩阵
    GLint modelIndex = glGetUniformLocation(_esContext.program, "modelTransform");
    GLint viewIndex = glGetUniformLocation(_esContext.program, "viewTransform");
    GLint projectIndex = glGetUniformLocation(_esContext.program, "projectTransform");
    
    GLKMatrix4 rotate = GLKMatrix4MakeRotation(varyFactor * M_PI * 2, 1, 1, 1);
    GLKMatrix4 translate = GLKMatrix4MakeTranslation(-0.1, -0.1, -0.1);
    
    GLKMatrix4 modelMatrix = GLKMatrix4Multiply(translate, rotate);
    

    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), view.frame.size.width / view.frame.size.height, 0.2, 10.0);
    
    
    GLKMatrix4 cameraMatrix = GLKMatrix4MakeLookAt(0, 0, 2 * (varyFactor + 1), 0, 0, 0, 0, 1, 0);
    
    //加载MVP矩阵
    glUniformMatrix4fv(modelIndex, 1, GL_FALSE, modelMatrix.m);
    glUniformMatrix4fv(viewIndex  , 1, GL_FALSE, cameraMatrix.m);
    glUniformMatrix4fv(projectIndex, 1, GL_FALSE, projectionMatrix.m);
    
    //开启顶点属性
    glEnableVertexAttribArray(colorIndex);
    glEnableVertexAttribArray(positionIndex);
    
    
    //加载顶点数据，并且依次绘制立方体的六个面
    [self drawPositiveXWithTextCoordLocation:colorIndex andPositionLocation:positionIndex];
    [self drawNegativeXWithTextCoordLocation:colorIndex andPositionLocation:positionIndex];
    [self drawPositiveYWithTextCoordLocation:colorIndex andPositionLocation:positionIndex];
    [self drawNegativeYWithTextCoordLocation:colorIndex andPositionLocation:positionIndex];
    [self drawPositiveZWithTextCoordLocation:colorIndex andPositionLocation:positionIndex];
    [self drawNegativeZWithTextCoordLocation:colorIndex andPositionLocation:positionIndex];
   
    //关闭顶点属性
    glDisableVertexAttribArray(colorIndex);
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
