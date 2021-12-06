#version 300 es

in vec4 vPosition;//顶点位置
in vec3 LightColor;//环境光照颜色
in vec3 lightPosition;//漫反射光源位置
in vec3 N;  //垂直于顶点的法向量

out vec3 fragLigntColor;
out vec4 fragPos;
out vec3 lightPos;
out vec3 Normal;

uniform mat4 modelTransform;
uniform mat4 viewTransform;
uniform mat4 projectTransform;

void main(){
    
    fragLigntColor = LightColor;
    mat4 mvpMatrix = projectTransform * viewTransform *  modelTransform;
    gl_Position = mvpMatrix * vPosition;
    
    //传递顶点坐标（转化为世界坐标系）
    fragPos = modelTransform *  vPosition;
    
    //光源位置
    lightPos = lightPosition;
    
    //法向量
    Normal = N;
}
