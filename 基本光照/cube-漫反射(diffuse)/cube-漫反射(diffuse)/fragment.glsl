#version 300 es
precision mediump float;

uniform vec3 lightColor;
//光源位置
uniform vec3 lightPos;

in vec3 Normal;
in vec3 fragPos;

out vec4 gColor;

void main() {
    //计算环境光照
    float ambientStrength = 0.2;

    vec3 ambient =  ambientStrength  * lightColor;
    
    //计算漫反射
    //计算光线位置
    vec3 norm = normalize(Normal);
    vec3 lightDirection = normalize(lightPos - fragPos);
    
    float diffu = dot(norm,lightDirection);
    vec3 diffuse = diffu * lightColor;

    //最终颜色（这里指定物体颜色为红色）
    vec3 result = (ambient + diffuse) * vec3(1.0,0.0,0.0);

    gColor = vec4(result,1.0);

}
