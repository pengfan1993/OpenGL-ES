#version 300 es
precision mediump float;

uniform vec3 lightColor;
//光源位置
uniform vec3 lightPos;

//观察点的位置
uniform vec3 viewPos;

in vec3 Normal;
in vec3 fragPos;

out vec4 gColor;

void main() {
    //计算环境光照
    float ambientStrength = 0.3;

    vec3 ambient =  ambientStrength  * lightColor;
    
    //计算漫反射
    //计算光线位置
    vec3 norm = normalize(Normal);
    vec3 lightDirection = normalize(lightPos - fragPos);
    
    float diffu = dot(norm,lightDirection);
    vec3 diffuse = diffu * lightColor;
    
    //计算镜面光照
    //定义一个镜面强度
    float specularStrength = 0.5;
    
    //观察向量
    vec3 viewDirection = normalize(viewPos - fragPos);
    //反射向量
    vec3 reflectDirection = reflect(-lightDirection,norm);
    
    float spec = pow(max(dot(viewDirection,reflectDirection), 0.0) , 32.0);
    
    vec3 specular = specularStrength * spec * lightColor;

    //最终颜色（这里指定物体颜色为红色）
    vec3 result = (ambient + diffuse + specular) * vec3(1.0,0.0,0.0);

    gColor = vec4(result,1.0);

}
