#version 300 es

precision mediump float;

in vec3 fragLigntColor;
in vec4 fragPos;
in vec3 lightPos;
in vec3 Normal;

out vec4 fragColor;
void main() {
    //环境光照强度
    float ambientFactor = 0.3;
    
    //计算环境光照
    vec3 ambient = ambientFactor * fragLigntColor;

    
    //计算漫反射
    vec3 norm = normalize(Normal);
    vec3 lightDirection = normalize(lightPos - vec3(fragPos.xyz));
    
    //小于0的取值0
    float diff = max(dot(norm,lightDirection), 0.0);
    vec3 diffuse = diff * fragLigntColor;
    
    //设定材料颜色为红色
    vec3 materialColor = vec3(1.0,0.0,0.0);
    
    vec3 result = (ambient + diffuse) * materialColor;

    //应用环境光照
    fragColor = vec4(result,1.0f);
}
