//
//  MatrixTransform.c
//  Matrix-Transform
//
//  Created by pengfan on 2021/11/26.
//

#include "MatrixTransform.h"

int init (ESContext *esContext) {
    return 1;
}


void draw(ESContext *esContext) {
    
}

void shutDown(ESContext *esContext) {
    
}

void esMain(ESContext *esContext) {
    
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
    glShaderSource(shader, 1,shaderSrc, NULL);
    
    //编译着色器
    glCompileShader(shader);
    
    
    //检查着色器状态
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    
    if (!compiled) {//着色器未编译成功
        GLint infoLength = 0;
        
        //查询log信息长度，根据这个长度创建字符串
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLength);
        
        
        if (infoLength > 1) {
            char *logInfo = malloc(sizeof(char) * infoLength);
            
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
