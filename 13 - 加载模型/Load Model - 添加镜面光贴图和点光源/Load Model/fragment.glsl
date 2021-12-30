#version 300 es
precision mediump float;

//材质
struct Material {
    sampler2D texture_diffuse1;
    sampler2D texture_specular1;
    float shineness;//高光
};

struct Light {
    vec3 diffuse;
    vec3 specular;
    vec3 ambient;

};
uniform Material material;
uniform Light light;

//点光源位置
uniform vec3 lightPos;

//观察位置(摄像机位置)
uniform vec3 viewPos;


in vec2 TexCoords;
in vec3 Normal; //法线向量
in vec3 fragPos;


out vec4 FragColor;


void main()
{    

    //计算环境光
    vec3 ambient = light.ambient * vec3(texture(material.texture_diffuse1, TexCoords));

    //计算漫反射
    vec3 norm = normalize(Normal);

    vec3 ligthDirection = normalize(lightPos - fragPos);

    float diffu = max(dot(norm,ligthDirection), 0.0);

	vec3 diffuse = light.diffuse * diffu  *  vec3(texture(material.texture_diffuse1, TexCoords));
    

    //计算镜面反射

    //观察方向
    vec3 viewDirection =  normalize(viewPos - fragPos);

    vec3 reflectDirection = reflect(-ligthDirection,norm);

    float spec = pow(max(dot(viewDirection,reflectDirection),0.0) , material.shineness);

    vec3 specular = light.specular * spec * vec3(texture(material.texture_specular1,TexCoords));

    FragColor = vec4((ambient + diffuse + specular ),1.0);
}
