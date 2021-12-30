//
//  ViewController.m
//  Matrix-Transform
//
//  Created by pengfan on 2021/11/26.
//

#import "ViewController.h"
#include "MatrixTransform.h"
#import "ModelLoader.h"
@interface ViewController(){
    ESContext _esContext;
}
@property (nonatomic,strong)EAGLContext *context;
@property (nonatomic,assign)GLKMatrix4 transformMatrix;
@property (nonatomic,assign)GLuint vertexBufferId;
@property (nonatomic,assign)double elapsedTime;
@property (nonatomic,strong)GLKTextureInfo *diffuseMap;
@property (nonatomic,strong)GLKTextureInfo *specularMap;
@property (nonatomic,strong)ModelLoader *loader;
@end
@implementation ViewController
- (ModelLoader *)loader {
    if (_loader == nil) {
        _loader = [[ModelLoader alloc] initWithFilePath:[[NSBundle mainBundle] pathForResource:@"nanosuit.obj" ofType:nil] andContext:&_esContext];
    }
    return _loader;
}
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
    [super glkView:view drawInRect:rect];
    self.elapsedTime += 0.01;
    
    //这里没添加时间参数，绘制静止的
    
    _esContext.width = view.drawableWidth;
    _esContext.height = view.drawableHeight;
    
    
    //开启深度测试，为了确定绘制的时候哪一个面绘制在上面
    glEnable(GL_DEPTH_TEST);
    
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    //获取属性color和position的index
    
    //创建MVP矩阵
    GLint modelIndex = glGetUniformLocation(_esContext.program, "model");
    GLint viewIndex = glGetUniformLocation(_esContext.program, "view");
    GLint projectIndex = glGetUniformLocation(_esContext.program, "projection");
    GLint lightPosIndex = glGetUniformLocation(_esContext.program, "lightPos");
    GLint viewPosIndex = glGetUniformLocation(_esContext.program, "viewPos");

    GLKMatrix4 scale = GLKMatrix4MakeScale(0.2, 0.2, 0.2);
    GLKMatrix4 translate = GLKMatrix4MakeTranslation(0, -2.0, -1.0);
    GLKMatrix4 rotate = GLKMatrix4MakeRotation(M_PI * self.elapsedTime, 0,1,0);

    GLKMatrix4 modelMatrix = GLKMatrix4Multiply(rotate,scale);
    modelMatrix = GLKMatrix4Multiply(translate, modelMatrix);

    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), view.frame.size.width / view.frame.size.height, 0.2, 10.0);
    
    
    GLKMatrix4 cameraMatrix = GLKMatrix4MakeLookAt(0.0, 0.5 , 2.0, 0, 0, 0, 0, 1, 0);
    
    //加载MVP矩阵
    glUniformMatrix4fv(modelIndex, 1, GL_FALSE, modelMatrix.m);
    glUniformMatrix4fv(viewIndex  , 1, GL_FALSE, cameraMatrix.m);
    glUniformMatrix4fv(projectIndex, 1, GL_FALSE, projectionMatrix.m);
    
    
    //设置光源位置（世界空间坐标系）
    static float lightPos[3] = {1.0,1.0,1.2};
    
    //这里设置观察点为摄像机的位置(cameraMatrix里eye的位置)
    static float viewPos[3] = {0.0, 0.5 , 2.0};
    
    glUniform3fv(lightPosIndex, 1, lightPos);
    glUniform3fv(viewPosIndex, 1, viewPos);
    
    //设置材质
    glUniform3f(glGetUniformLocation(_esContext.program, "light.ambient"), 1.0, 1.0, 1.0);
    glUniform3f(glGetUniformLocation(_esContext.program, "light.diffuse"), 1.0, 1.0, 1.0);
    glUniform3f(glGetUniformLocation(_esContext.program, "light.specular"), 1.0, 1.0, 1.0);
    
    
    //设置光线属性

    glUniform1f(glGetUniformLocation(_esContext.program, "material.shineness"), 32.0);
    
    //设置窗口
    glViewport(0, 0, _esContext.width, _esContext.height);
    
    //使用项目
    glUseProgram(_esContext.program);
    
    
    [self.loader draw];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    if (_vertexBufferId != 0) {
        glDeleteBuffers(1, &_vertexBufferId);
    }
    self.elapsedTime = 0;
    
    
    
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
    
}

@end
