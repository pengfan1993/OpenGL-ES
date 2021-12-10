//
//  ViewController.m
//  VAO VBO
//
//  Created by pengfan on 2021/12/10.
//

#import "ViewController.h"
#import "MatrixTransform.h"

@interface ViewController() {
    ESContext _esContext;
}
@property (nonatomic,strong)EAGLContext *context;
@property(nonatomic,assign) GLuint vboId;
@property(nonatomic,assign) GLuint vaoId;
@property (nonatomic,assign)GLuint eboId;
@property(nonatomic,assign)GLuint positionIndex;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEAGL];
    [self loadData];
}
- (void)setupEAGL {
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:_context];
    memset(&_esContext,0, sizeof(ESContext));
    esMain(&_esContext);
}
- (void)loadData {
    static GLfloat points[] = {
        -0.5, 0.5, 0.0,
        -0.5, -0.5, 0.0,
        0.5, -0.5, 0.0,
        0.5,  0.5, 0.0,
        
    };
    
    static GLushort indices[] = {
        0,1,3,
        1,2,3,
    };
    
    //创建并绑定VAO
    glGenVertexArrays(1, &_vaoId);
    glBindVertexArray(_vaoId);
    
    
    //创建并绑定VBO
    glGenBuffers(1, &_vboId);
    glBindBuffer(GL_ARRAY_BUFFER, _vboId);
    
    //填充缓冲区数据
    glBufferData(GL_ARRAY_BUFFER, sizeof(points), points, GL_STATIC_DRAW);
    
    _positionIndex = glGetAttribLocation(_esContext.program, "vPosition");
    
    //加载顶点属性数组
    glVertexAttribPointer(_positionIndex, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), NULL);
    
    //创建并绑定EBO， 加载数据
    glGenBuffers(1, &_eboId);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _eboId);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    
    //解绑 VAO VBO EBO
    glBindVertexArray(0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}
- (void)draw {
    //设置窗口
    glViewport(0, 0, _esContext.width, _esContext.height);
    
    //使用项目
    glUseProgram(_esContext.program);
    
    //绑定VAO，这时（VAO 统一管理 VBO EBO）
    glBindVertexArray(_vaoId);
    glEnableVertexAttribArray(_positionIndex);
    
    //绘制顶点，采用EBO
    //这里不用glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, NULL);
    
    glBindVertexArray(0);
    glDisableVertexAttribArray(_positionIndex);
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [super glkView:view drawInRect:rect];
    _esContext.width = view.drawableWidth;
    _esContext.height = view.drawableHeight;
    [self draw];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    //不在需要VAO VBO的时候记得删除一下
    if (_vboId != 0 && _vaoId != 0) {
        glDeleteBuffers(1, &_vboId);
        glDeleteVertexArrays(1, &_vaoId);
    }
    
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
    
}
@end
