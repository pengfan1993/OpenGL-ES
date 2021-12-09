#version 300 es 
precision mediump float;

struct Material {
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;

    float shineness; //高光反射

};

struct Light {
    sampler2D diffuseMap;
    vec3 specular;

};

uniform Material material;
uniform Light light;

//光源位置
uniform vec3 lightPos;

//观察点（摄像机位置）
uniform vec3 viewPos;

//顶点位置（世界空间坐标系）
in vec3 fragPos;

//垂直于顶点的法线向量(世界空间坐标系)
in vec3 N;

in vec2 oTextCoord;

out vec4 fragColor;

void main() {
    //计算环境光照(漫反射贴图也用于环境反射)
    vec3 ambient = material.ambient *  vec3(texture(light.diffuseMap, oTextCoord));

    //计算漫反射
    vec3 norm = normalize(N);

    vec3 lightDirection = normalize(lightPos - fragPos);

    float diffu  = max(dot(norm,lightDirection), 0.0);

    vec3 diffuse = material.diffuse * diffu * vec3(texture(light.diffuseMap, oTextCoord));

    //计算环境反射
    vec3 viewDirection = normalize(viewPos - fragPos);

    vec3 reflectDirection =  reflect(-lightDirection,norm);

    float spec = pow( max(dot(viewDirection, reflectDirection), 0.0), material.shineness);
    vec3 specular = light.specular * spec * material.specular;

    fragColor = vec4((ambient + diffuse + specular), 1.0);
    
}
