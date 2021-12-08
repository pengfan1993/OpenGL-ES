#version 300 es

in vec4 vPosition;
in vec4 vColor;
out vec4 fColor;

uniform mat4 modelTransform;
uniform mat4 viewTransform;
uniform mat4 projectTransform;

void main(){
    fColor = vColor;
    mat4 mvpMatrix = projectTransform * viewTransform *  modelTransform;
    gl_Position = mvpMatrix * vPosition;
}
