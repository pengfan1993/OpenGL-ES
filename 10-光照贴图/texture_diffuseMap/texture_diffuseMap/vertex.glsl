#version 300 es 
precision mediump float;

in vec4 vPosition;
in vec3 Normal;
in vec2 textCoord;

uniform mat4 modelTransform;
uniform mat4 viewTransform;
uniform mat4 projectTransform;

//法线变换矩阵（世界空间坐标系下）
uniform mat4 invertTransposeMatrix;

//顶点位置（世界空间坐标系）
out vec3 fragPos;

//垂直于顶点的法线向量(世界空间坐标系)
out vec3 N;

//纹理坐标
out vec2 oTextCoord;

void main() {
    mat4 mvpTransform = projectTransform * viewTransform * modelTransform;

    gl_Position = mvpTransform * vPosition;

//世界空间坐标系下的顶点位置
    fragPos = (modelTransform * vPosition).xyz;

//世界坐标系下的法线向量
    N = (invertTransposeMatrix * vec4(Normal, 0.0)).xyz;
}