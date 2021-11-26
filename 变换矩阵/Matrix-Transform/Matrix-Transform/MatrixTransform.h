//
//  MatrixTransform.h
//  Matrix-Transform
//
//  Created by pengfan on 2021/11/26.
//

#ifndef MatrixTransform_h
#define MatrixTransform_h

#include <stdio.h>
#include <stdlib.h>
#include <OpenGLES/ES3/gl.h>

typedef struct ESContext ESContext;

struct ESContext {
    //保存平台的一些数据
    void *platformData;
    
    GLuint program;
    
    //屏幕绘制的宽度
    GLint width;
   
    //绘制的高度
    GLint height;
    
    void (*drawFunc)(ESContext *);
    void (*shutDownFunc)(ESContext *);
    void (*updateFunc)(ESContext *, float dealTime);
    
};

/// 初始化操作
int init (ESContext *esContext);

///绘图方法
void draw(ESContext *esContext);

///处理终止
void shutDown(ESContext *esContext);

///赋值操作
void esMain(ESContext *esContext);

#endif /* MatrixTransform_h */
