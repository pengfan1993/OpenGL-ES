#version 300 es 
in vec4 vPosition;
in vec4 vColor;
out vec fColor;

uniform mat4 modelTransform;
uniform mat4 viewTransform;
uniform mat4 projectTransform;

void main(){
    fColor = vColor;
    mat4 mvpMatrix = modelTransform * viewTransform * projectTransform;
    gl_Position = mvpMatrix * vPosition;
}