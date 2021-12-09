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
@property (nonatomic,strong)GLKTextureInfo *baseTexture;
@property (nonatomic,copy) NSString *texturePath;
@property (nonatomic,copy)NSData *imageData;
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
    
    GL_NEAREST
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    
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
//- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
//    [super glkView:view drawInRect:rect];
//
//    _esContext.width = view.drawableWidth;
//    _esContext.height = view.drawableHeight;
//
//    GLfloat factor =  (view.frame.size.width / view.frame.size.height) * 0.5;
//
//
//    //（x,y,z） (s,t) 顶点位置和纹理坐标
//    float position[] = {
//        -0.5,  factor, 0.0,  0.0, 0.0,
//        -0.5, -factor, 0.0,  0.0, 1.0,
//         0.5, -factor, 0.0,  1.0, 1.0,
//         0.5,  factor, 0.0,  1.0, 0.0,
//    };
//
//
//    //开启深度测试，为了确定绘制的时候哪一个面绘制在上面
//    glClear(GL_COLOR_BUFFER_BIT);
//
//    GLuint vboIndex = 0;
//    glGenBuffers(1, &vboIndex);
//    glBindBuffer(GL_ARRAY_BUFFER, vboIndex);
//    glBufferData(GL_ARRAY_BUFFER, sizeof(position), position, GL_STATIC_DRAW);
//
//    GLuint positionIndex = glGetAttribLocation(_esContext.program, "vPosition");
//    GLuint textCoordIndex = glGetAttribLocation(_esContext.program, "textCoord");
//
//    GLuint textureLocation = glGetUniformLocation(_esContext.program, "texture1");
//
//    glEnableVertexAttribArray(positionIndex);
//    glEnableVertexAttribArray(textCoordIndex);
//
//    GLuint offset = 3 * sizeof(float);
//    glVertexAttribPointer(positionIndex, 3, GL_FLOAT, GL_FALSE, 5  * sizeof(float), NULL);
//    glVertexAttribPointer(textCoordIndex, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (const void *)offset);
//
//    //生成纹理并绑定
//    GLuint textId = 0;
//    glGenTextures(1, &textId);
//    glBindTexture(GL_TEXTURE_2D, textId);
//    static size_t width = 0,height = 0;
//    if (_imageData == nil) {
//        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wall.jpeg" ofType:nil]];
//        CGImageRef imageref = [img CGImage];
//
//         width = CGImageGetWidth(imageref);
//         height = CGImageGetHeight(imageref);
//
//        GLubyte *textureData = (GLubyte *)malloc(width * height * 4);
//
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//
//        //每个像素点四个字节RGBA
//        NSUInteger bytesperPixel = 4;
//        NSUInteger bytesperRow = bytesperPixel * width;
//        NSUInteger bitsperComponent = 8;
//
//        CGContextRef context = CGBitmapContextCreate(textureData, width, height, bitsperComponent, bytesperRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
//
//
//
//        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageref);
//        CGColorSpaceRelease(colorSpace);
//        CGContextRelease(context);
//        _imageData = [NSData dataWithBytes:textureData length:(width * height * 4)];
//    }
//
//    //必须要设置纹理环绕方式和纹理过滤方式，不然不会显示
//   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
//   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
//   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
//   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
//
//    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 750, 750, 0, GL_RGBA, GL_UNSIGNED_BYTE, (unsigned char *)_imageData.bytes);
//
//    glUniform1i(textureLocation, 0);
//    _esContext.drawFunc(&_esContext);
//
//    //关闭顶点属性
//    glDisableVertexAttribArray(positionIndex);
//    glDisableVertexAttribArray(textCoordIndex);
//    glDeleteBuffers(1, &vboIndex);
//    glBindTexture(GL_TEXTURE_2D, 0);
//    glDeleteTextures(1, &textId);
//
//
//}

@end
