#version 300 es
precision mediump float;

struct Material {
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    float shineness;
};

uniform vec3 lightColor;
//光源位置
uniform vec3 lightPos;

//观察点的位置
uniform vec3 viewPos;

//物体材质
uniform Material material;

in vec3 Normal;
in vec3 fragPos;

out vec4 gColor;

void main() {
    //计算环境光照
    vec3 ambient =  lightColor * material.ambient;
    
    //计算漫反射
    vec3 norm = normalize(Normal);
    vec3 lightDirection = normalize(lightPos - fragPos);
    
    float diffu = dot(norm,lightDirection);
    vec3 diffuse = lightColor * (diffu * material.diffuse);
    
    //计算镜面光照
    
    //观察向量
    vec3 viewDirection = normalize(viewPos - fragPos);
    //反射向量
    vec3 reflectDirection = reflect(-lightDirection,norm);
    
    float spec = pow(max(dot(viewDirection,reflectDirection), 0.0) , material.shineness);
    
    vec3 specular =  lightColor * (spec * material.specular);

    //最终颜色（这里指定物体颜色为红色）
    vec3 result = ambient + diffuse + specular;

    gColor = vec4(result,1.0);

}
