#version 300 es
precision mediump float;

struct Material {
    sampler2D diffuseMap;
    sampler2D specularMap;
    float shineness; //高光反射

};
struct Light {
    vec3 diffuse;
    vec3 specular;
    vec3 ambient;


    float constant;
    float linear;
    float quadratic;

    //聚光指向的方向
    vec3 spotDir;

    //切光角
    float cutOff;

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

    // 顶点到光源的距离
    float  distan = length(lightPos - fragPos);

    //计算环境光照(漫反射贴图也用于环境反射)
    vec3 ambient = light.ambient *  vec3(texture(material.diffuseMap, oTextCoord));

    //计算漫反射
    vec3 norm = normalize(N);

    vec3 lightDirection = normalize(lightPos - fragPos);

    float diffu  = max(dot(norm,lightDirection), 0.0);

    vec3 diffuse = light.diffuse * diffu * vec3(texture(material.diffuseMap, oTextCoord));

    //计算镜面反射
    vec3 viewDirection = normalize(viewPos - fragPos);

    vec3 reflectDirection =  reflect(-lightDirection,norm);

    float spec = pow( max(dot(viewDirection, reflectDirection), 0.0), material.shineness);
    vec3 specular = light.specular * spec * vec3(texture(material.specularMap, oTextCoord));
    
    //计算从片段指向光源的向量和聚光所指的方向的夹角
    float theta = dot(lightDirection, normalize(-light.spotDir));
    
    vec4 color = vec4(1.0);
    
//如果处于切光角内，就这样计算，否则就用环境光照，不至于太暗
    if (theta > light.cutOff)
    {
        diffuse *= theta;
        specular *= theta;
        color = vec4((ambient + diffuse + specular), 1.0);
    }
    else {
        color = vec4(ambient, 1.0);

    }
    fragColor = color;
}
