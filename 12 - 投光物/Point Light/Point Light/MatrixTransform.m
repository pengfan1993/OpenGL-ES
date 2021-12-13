//
//  MatrixTransform.c
//  Matrix-Transform
//
//  Created by pengfan on 2021/11/26.
//

#include "MatrixTransform.h"
#import <Foundation/Foundation.h>
GLuint loadShader(GLenum  shaderType,const char *shaderSrc);

const char * loadShaderSource(NSString *filePath) {
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *shaderStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [shaderStr cStringUsingEncoding:NSUTF8StringEncoding];
}
int init (ESContext *esContext) {
    NSString *vertexFile = [[NSBundle mainBundle] pathForResource:@"vertex.glsl" ofType:nil];
    NSString *fragmentFile = [[NSBundle mainBundle] pathForResource:@"fragment.glsl" ofType:nil];
    //顶点着色器
    const char * vShaderStr = loadShaderSource(vertexFile);
    const char * fShaderStr = loadShaderSource(fragmentFile);
    
    GLuint vertexShader;
    GLuint fragmentShader;
    GLuint programObject;
    GLint linked;
    
    //加载两个着色器
    vertexShader = loadShader(GL_VERTEX_SHADER, vShaderStr);
    
    fragmentShader = loadShader(GL_FRAGMENT_SHADER, fShaderStr);
    
    programObject = glCreateProgram();
    
    
    //创建失败
    if (programObject == 0) {
        return 0;
    }
    
    glAttachShader(programObject, vertexShader);
    glAttachShader(programObject, fragmentShader);
    
    glLinkProgram(programObject);
    
    glGetProgramiv(programObject, GL_LINK_STATUS, &linked);
    
    if (!linked) {
        GLint infoLength = 0;
        
        glGetProgramiv(programObject, GL_INFO_LOG_LENGTH, &infoLength);
        
        if (infoLength > 1) {
            char *info = (char *)malloc(sizeof(char) * infoLength);
            
            glGetProgramInfoLog(programObject, infoLength, NULL, info);
            
            printf("program linked fail------%s",info);
            
            free(info);
        }
        
        glDeleteProgram(programObject);
        return  GL_FALSE;
    }
    
    esContext->program = programObject;
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    return  GL_TRUE;
}


void draw(ESContext *esContext) {
    //设置窗口
    glViewport(0, 0, esContext->width, esContext->height);
    
    //使用项目
    glUseProgram(esContext->program);
    
    
    //绘制顶点
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
}

void shutDown(ESContext *esContext) {
    glDeleteProgram(esContext->program);
}

int esMain(ESContext *esContext) {
    if (!init(esContext)) {
        return  GL_FALSE;
    }
    
    esContext->drawFunc = draw;
    esContext->shutDownFunc = shutDown;
    return GL_TRUE;

    
}



/// 加载一个着色器
/// @param shaderType 着色器类型
/// @param shaderSrc 着色器源字符串
GLuint loadShader(GLenum  shaderType,const char *shaderSrc) {
    
    GLuint shader;
    GLint compiled;
    
    //创建着色器对象
    shader = glCreateShader(shaderType);
    
    if (shader == 0) {//创建失败
        return 0;
        
    }
    
    //加载着色器原文件
    glShaderSource(shader, 1,&shaderSrc, NULL);
    
    //编译着色器
    glCompileShader(shader);
    
    
    //检查着色器状态
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    
    if (!compiled) {//着色器未编译成功
        GLint infoLength = 0;
        
        //查询log信息长度，根据这个长度创建字符串
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLength);
        
        
        if (infoLength > 1) {
            char *logInfo = (char *)malloc(sizeof(char) * infoLength);
            
            glGetShaderInfoLog(shader, infoLength, NULL, logInfo);
            
            printf("error compiling shader: \n %s \n",logInfo);
            free(logInfo);
        }
        
        //删除着色器
        glDeleteShader(shader);
        return 0;
    }
    
    return shader;
}
