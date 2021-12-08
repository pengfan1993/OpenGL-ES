#version 300 es

precision mediump float;

in vec4 vPosition;

//垂直于顶点的法向量
in vec3 N;

out vec3 fColor;
out vec3 Normal;
//片段的位置，转化为世界坐标系下的
out vec3 fragPos;

uniform mat4 modelTransform;
uniform mat4 viewTransform;
uniform mat4 projectTransform;

//法线变换矩阵，把法线向量转化到世界空间中，需要运用到法线变换矩阵
uniform mat4 invertTransposeMatrix;

void main(){
    
    mat4 mvpTransform = projectTransform * viewTransform * modelTransform;
    
    gl_Position = mvpTransform * vPosition;
    
    //将顶点位置转换为世界空间坐标
    fragPos = (modelTransform * vPosition).xyz;
    
    //法线向量转换为世界空间坐标
    Normal = (invertTransposeMatrix * vec4(N,0.0)).xyz;
}
