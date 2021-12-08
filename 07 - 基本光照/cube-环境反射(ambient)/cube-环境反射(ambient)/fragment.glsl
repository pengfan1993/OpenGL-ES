#version 300 es
precision mediump float;

uniform vec3 lightColor;

in vec3 fColor;

out vec4 gColor;

void main() {
    //计算环境光照
    float ambientStrength = 0.2;

    vec3 ambient =  ambientStrength  * lightColor;

    //最终颜色等于环境光照乘以物体颜色
    vec3 result = ambient * fColor;

    gColor = vec4(result,1.0);

}
