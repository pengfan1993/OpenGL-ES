//
//  ViewController.m
//  Matrix-Transform
//
//  Created by pengfan on 2021/11/26.
//

#import "ViewController.h"
#include "MatrixTransform.h"
#include "stb_image.h"
@interface ViewController(){
    ESContext _esContext;
}
@property (nonatomic,strong)EAGLContext *context;
@property (nonatomic,assign)GLKMatrix4 transformMatrix;
@property (nonatomic,assign)GLuint vertexBufferId;
@property (nonatomic,assign)double elapsedTime;
@property (nonatomic,strong)GLKTextureInfo *baseTexture;
@property (nonatomic,copy) NSString *texturePath;
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
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"wall.jpeg" ofType:nil];
    self.baseTexture = [GLKTextureLoader textureWithContentsOfFile:filePath options:nil error:nil];
}

//利用GLKit来加载纹理
- (void)gl0View:(GLKView *)view drawInRect:(CGRect)rect {
    [super glkView:view drawInRect:rect];

    _esContext.width = view.drawableWidth;
    _esContext.height = view.drawableHeight;
    
    GLfloat factor =  (view.frame.size.width / view.frame.size.height) * 0.5;
    
    
    //（x,y,z） (s,t)
    float position[] = {
        -0.5,  factor, 0.0,  0.0, 0.0,
        -0.5, -factor, 0.0,  0.0, 1.0,
         0.5, -factor, 0.0,  1.0, 1.0,
         0.5,  factor, 0.0,  1.0, 0.0,
    };
    
    
    //开启深度测试，为了确定绘制的时候哪一个面绘制在上面
    glClear(GL_COLOR_BUFFER_BIT);
    
    GLuint vboIndex = 0;
    glGenBuffers(1, &vboIndex);
    glBindBuffer(GL_ARRAY_BUFFER, vboIndex);
    glBufferData(GL_ARRAY_BUFFER, sizeof(position), position, GL_STATIC_DRAW);
    
    GLuint positionIndex = glGetAttribLocation(_esContext.program, "vPosition");
    GLuint textCoordIndex = glGetAttribLocation(_esContext.program, "textCoord");
    
    GLuint textureLocation = glGetUniformLocation(_esContext.program, "texture1");
    
    glEnableVertexAttribArray(positionIndex);
    glEnableVertexAttribArray(textCoordIndex);
    
    GLuint offset = 3 * sizeof(float);
    glVertexAttribPointer(positionIndex, 3, GL_FLOAT, GL_FALSE, 5  * sizeof(float), NULL);
    glVertexAttribPointer(textCoordIndex, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (const void *)offset);
    
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, self.baseTexture.name);
    glUniform1i(textureLocation, 0);
    _esContext.drawFunc(&_esContext);
    
    //关闭顶点属性
    glDisableVertexAttribArray(positionIndex);
    glDisableVertexAttribArray(textCoordIndex);
    glDeleteBuffers(1, &vboIndex);
    
    
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

//不利用GLKit来加载纹理
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [super glkView:view drawInRect:rect];

    _esContext.width = view.drawableWidth;
    _esContext.height = view.drawableHeight;
    
    GLfloat factor =  (view.frame.size.width / view.frame.size.height) * 0.5;
    
    
    //（x,y,z） (s,t)
    float position[] = {
        -0.5,  factor, 0.0,  0.0, 0.0,
        -0.5, -factor, 0.0,  0.0, 1.0,
         0.5, -factor, 0.0,  1.0, 1.0,
         0.5,  factor, 0.0,  1.0, 0.0,
    };
    
    
    //开启深度测试，为了确定绘制的时候哪一个面绘制在上面
    glClear(GL_COLOR_BUFFER_BIT);
    
    GLuint vboIndex = 0;
    glGenBuffers(1, &vboIndex);
    glBindBuffer(GL_ARRAY_BUFFER, vboIndex);
    glBufferData(GL_ARRAY_BUFFER, sizeof(position), position, GL_STATIC_DRAW);
    
    GLuint positionIndex = glGetAttribLocation(_esContext.program, "vPosition");
    GLuint textCoordIndex = glGetAttribLocation(_esContext.program, "textCoord");
    
    GLuint textureLocation = glGetUniformLocation(_esContext.program, "texture1");
    
    glEnableVertexAttribArray(positionIndex);
    glEnableVertexAttribArray(textCoordIndex);
    
    GLuint offset = 3 * sizeof(float);
    glVertexAttribPointer(positionIndex, 3, GL_FLOAT, GL_FALSE, 5  * sizeof(float), NULL);
    glVertexAttribPointer(textCoordIndex, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (const void *)offset);
    
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, self.baseTexture.name);
    glUniform1i(textureLocation, 0);
    _esContext.drawFunc(&_esContext);
    
    //关闭顶点属性
    glDisableVertexAttribArray(positionIndex);
    glDisableVertexAttribArray(textCoordIndex);
    glDeleteBuffers(1, &vboIndex);
    
    
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
