//
//  Hello_triangle.c
//  openGL es
//
//  Created by 彭凡 on 2021/11/2.
//

#include "Hello_triangle.h"
#include <stdlib.h>

int init (ESContext *esContext) {
    UserData *userData = esContext->userData;
    //顶点着色器
    char vShaderStr[] =
       "#version 300 es                          \n"
       "layout(location = 0) in vec4 vPosition;  \n"
       "void main()                              \n"
       "{                                        \n"
       "   gl_Position = vPosition;              \n"
       "   gl_PointSize = 25.0;                  \n" //改变点的大小
       "}                                        \n";

    //片段着色器
    char fShaderStr[] =
       "#version 300 es                              \n"
       "precision mediump float;                     \n"
       "out vec4 fragColor;                          \n"
       "void main()                                  \n"
       "{                                            \n"
       "   fragColor = vec4 ( 0.0, 1.0, 0.0, 1.0 );  \n" //这里设置颜色为绿色
       "}                                            \n";
    
    GLuint vertexShader;
    GLuint fragmentShader;
    GLuint programObject;
    GLint linked;
    
    //加载两个顶点着色器
    //顶点着色器
    vertexShader = loadShader(GL_VERTEX_SHADER, vShaderStr);
    //片段着色器
    fragmentShader = loadShader(GL_FRAGMENT_SHADER, fShaderStr);
    
    //创建program对象
    programObject = glCreateProgram();
    
    
    //处理创建失败
    if (programObject == 0) {//创建失败
        return 0;
    }
    
    //将着色器装配到项目
    glAttachShader(programObject, vertexShader);
    glAttachShader(programObject, fragmentShader);
    
    //链接项目
    glLinkProgram(programObject);
    
    
    //检查项目的状态
    glGetProgramiv(programObject, GL_LINK_STATUS, &linked);
    
    if (!linked) {//链接失败，打印日志
        GLint infoLen = 0;
        glGetProgramiv(programObject, GL_INFO_LOG_LENGTH, &infoLen);
        
        if (infoLen > 1) {//确定打印日志信息长度
            char *infoLog = malloc (sizeof(char) * infoLen);
            
            glGetProgramInfoLog(programObject, infoLen, NULL, infoLog);
            
            printf("error Info-----------%s",infoLog);
            
            free (infoLog);
            
        }
        
        //项目链接失败就删除项目
        glDeleteProgram(programObject);
        return GL_FALSE;
        
    }
    
    //保存用户信息
    userData->programObject = programObject;
    
    //设置背景色
    glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
    
    return GL_TRUE;
}
GLuint loadShader (GLenum  type, const char *shaderSrc) {
    
    GLuint shader;
    GLint compiled;
    
    //创建着色器对象
    shader = glCreateShader(type);
    
    if (shader == 0) {//创建失败
        return 0;
    }
    
    //加载着色器源数据
    glShaderSource(shader, 1, &shaderSrc, NULL);
    
    //编译着色器
    glCompileShader(shader);
    
    //检查编译器状态
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    
    if (!compiled) {//如果未编译成功
        GLint infoLeng = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLeng);
        
        if (infoLeng > 1) {
            char *logInfo = malloc(sizeof(char) * infoLeng);
            
            glGetShaderInfoLog(shader, infoLeng, NULL, logInfo);
            
            printf("error compiling shader: \n%s\n", logInfo);
            
            free(logInfo);
        }
        
        glDeleteShader(shader);
        return 0;
    }
    
    return shader;
}

void draw( ESContext *esContext) {
    UserData *userData = esContext->userData;
    GLint width = esContext->width;
    GLint height = esContext->height;
    
    GLfloat vVertices[] = {
        0.0f,  0.5f,  0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f, -0.5f, 0.0f
        
    };
    
    //设置窗口
    glViewport(0, 0, esContext->width, esContext->height);
    
    //清除颜色缓冲区
    glClear(GL_COLOR_BUFFER_BIT);
    
    //使用项目
    glUseProgram(userData->programObject);
    
    //加载顶点数据
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, vVertices);
    
    //开启顶点数组
    glEnableVertexAttribArray(0);
    
    //绘制顶点
    glDrawArrays(GL_POINTS, 0, 3);

}

//阻断操作
void shutDown(ESContext *esContext) {
    UserData *userData = esContext->userData;
    glDeleteProgram(userData->programObject);
}

//初始化操作，为结构体成员赋值
int esMain(ESContext *esContext) {
    esContext->userData = malloc(sizeof(UserData));
    
    //初始化失败，返回false
    if (!init(esContext)) {
        return  GL_FALSE;
    }
    
    esContext->shutdownFunc = shutDown;
    esContext->drawFunc = draw;
    
    return  GL_TRUE;
}

void bindToBuffer(ESContext *esContext) {
    GLuint blockId, bufferId;
    GLint blockSize;
    GLuint bindingPoint = 1;
    GLfloat lightData[] =
    {
        //lightDirection (padded to vec4 based on std140 rule)
        1.0f, 0.0f, 0.0f, 0.0f,
        
        //light Position
        0.0f, 0.0f, 0.0f, 1.0f
    };
    
    UserData *data = esContext->userData;
    
    //获取统一变量块索引
    blockId = glGetUniformBlockIndex(data->programObject, "LightBlock");
    
    
    //关联统一变量块索引和绑定点
    glUniformBlockBinding(data->programObject, blockId, bindingPoint);
    
    //获取lightdata大小，
    glGetActiveUniformBlockiv(data->programObject, blockId, GL_UNIFORM_BLOCK_DATA_SIZE, &blockSize);
    
    //创建和填充缓冲对象
    glGenBuffers(1, &bufferId);
    glBindBuffer(GL_UNIFORM_BUFFER, bufferId);
    glBufferData(GL_UNIFORM_BUFFER, blockSize, lightData, GL_DYNAMIC_DRAW);
    
    //绑定缓冲对象和统一变量块缓冲点
    glBindBufferBase(GL_UNIFORM_BUFFER, bindingPoint, bufferId);
    
    GLboolean have;
    glGetBooleanv(GL_SHADER_COMPILER, &have);
    
   
    
}
