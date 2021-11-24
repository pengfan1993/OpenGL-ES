//
//  Hello_triangle.h
//  openGL es
//
//  Created by 彭凡 on 2021/11/2.
//

#ifndef Hello_triangle_h
#define Hello_triangle_h

#include <OpenGLES/ES3/gl.h>
#include <stdio.h>

typedef struct {
    
    //handle to a program object
    GLuint programObject;
    
} UserData;

typedef  struct ESContext ESContext;
struct ESContext {
    
    /// Put platform  data here
    void *platformData;
    
    void *userData;
    
    GLint width;
    
    GLint height;
    
    //callBacks
    void (* drawFunc) (ESContext *);
    void (* shutdownFunc) (ESContext *);
    void (* keyFunc) (ESContext *, unsigned char, int , int);
    void ( *updateFunc) (ESContext *, float dealTime);

};

int init (ESContext *esContext);
GLuint loadShader (GLenum  type, const char *shaderSrc);
void draw( ESContext *esContext);
void shutDown(ESContext *esContext);
int esMain(ESContext *esContext);
#endif /* Hello_triangle_h */

