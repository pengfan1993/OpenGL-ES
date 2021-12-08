//
//  ViewController.m
//  OpenGLES_CH_2
//
//  Created by pengfan on 2021/11/23.
//

#import "ViewController.h"

@interface ViewController()

@property(assign,nonatomic)GLuint vertexBufferID;
@property(strong,nonatomic)GLKBaseEffect *baseEffect;

@end

@implementation ViewController

typedef struct {
    GLKVector3 positionCoords;
}SceneVertex;


static const GLfloat vertices[] = {
    -0.5f,-0.5f,0.0f,1.0f,0.0f,0.0f, //对应（x,y,z,r,g,b） position 和 color 排布
    0.5f,-0.5f,0.0f,0.0f,1.0f,0.0f,
    0.0f,0.5f,0.0f,0.0f,0.0f,1.0f,
};
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vertexBufferID = 0;
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's view is not a GLKView");
    
    //创建一个opengl es 3.0版本的图形上下文
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    //设置当前的context为显示的上下文
    [EAGLContext setCurrentContext:view.context];
    
    
    //创建一个Base effect，内部封装ES的相关操作，让我们避免写着色器，以及创建program,加载着色器，连接program的过程
    self.baseEffect = [[GLKBaseEffect alloc] init];
    
    self.baseEffect.useConstantColor = GL_TRUE;
    //self.baseEffect.constantColor = GLKVector4Make(1.0f, 0.0f, 1.0f, 1.0f);
    
   //设置当前图形上下文的背景颜色
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);

    
    //生成顶点数组缓冲区对象，并且绑定，然后初始化一个缓冲保存在GPU中，相对于opengl ES 2.0的客户数组对象，这种方法更高效，因为客户数组对象需要将内存复制到GPU中，这种方法可以显著地改进渲染性能，也会降低内存带宽和电力需求，这对于手持设备相当重要。
    
    glGenBuffers(1, &_vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    
    
    //OK，到这里初始化工作完成了
}

//下面就是绘图工作了，在这个方法里完成绘制内容
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self.baseEffect prepareToDraw];
    
    //擦出之前的绘制(这里清楚颜色缓冲区，关于颜色缓冲区后面的例子再说明)
    glClear(GL_COLOR_BUFFER_BIT);
    
    //开启顶点属性数组
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    
    //命令GPU从缓冲区中读取顶点属性
    //关于参数说明，
    //第一个制定属性索引，这里是顶点位置，
    //第二个是顶点数组中为索引引用的顶点属性所指定的分量数量（有效值为1~4），因为这里指定的属性是position，是一个包含三个分量的向量（x,y,z）,所以这里指定为3，
    //第三个指定数据类型，为float,
    //第四个参数：表示非浮点数转化时是否需要规范化，这里不用转化，所以传GL_FALSE
    //第五个参数：步长，如果这个值为0，表示每个顶点的属性数据顺序存储，如果大于0，则指定为索引i到i+1的顶点数据之间的位移，这里指定为SceneVertex的大小就是表示位移为0，是顺序存储的，
    //第六个参数:这里使用的缓冲区对象，表示缓冲区的偏移量，这里为NULL表示从最开始的位置
    GLuint offset = 3 * sizeof(float);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 6, NULL);
    glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 6, (const void *)offset);
    
    //调用这个函数绘制三角形
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

//一些清除资源工作
- (void)viewDidUnload {
    [super viewDidUnload];
    
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    if (0 != _vertexBufferID) {//清除缓冲对象
        glDeleteBuffers(1, &_vertexBufferID);
        _vertexBufferID = 0;
    }
    
    //置空
    ((GLKView *) self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}
@end
