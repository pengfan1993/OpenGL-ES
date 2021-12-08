#version 300 es

precision mediump float;

in vec4 vPosition;
in vec3 vColor;

out vec3 fColor;

uniform mat4 modelTransform;
uniform mat4 viewTransform;
uniform mat4 projectTransform;

void main(){
    mat4 mvpTransform = projectTransform * viewTransform * modelTransform;
    
    gl_Position = mvpTransform * vPosition;
    
    fColor = vColor;
}
