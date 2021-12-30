#version 300 es 
precision mediump float;

layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoords;

out vec2 TexCoords;
out vec3 Normal; //法线向量
out vec3 fragPos;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main()
{
    TexCoords = aTexCoords;  

    mat4 mvpTransform = projection * view * model; 

    gl_Position = mvpTransform * vec4(aPos, 1.0);

    //法线向量转换为世界空间坐标系
    Normal = mat3(transpose(inverse(model))) * aNormal;

    //顶点位置，转换为世界空间坐标系
    fragPos = (model * vec4(aPos, 0.0)).xyz;
}
