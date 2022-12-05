#define PI 3.1415926538
float random(float x){
    return fract(sin(x)*12561.1516);
}
float noise(float x){
    float i = floor(x);
    float f  = fract(x);
    float u = f*f*(3.0-2.0*f);
    return mix(random(i),random(i+1.0),u);
}

float sdf(vec2 uv)
{
    float a = acos(dot(normalize(uv),vec2(0.99,0.)));
    a /= PI;
    float n = noise(a * 0.3 * 10. + iTime) * 0.06;
    return 0.25f - length(uv) + n;
} 
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec3 col = vec3(0);
    vec2 uv = fragCoord / iResolution.xy - vec2(0.5f);
    float y = sdf(uv);
    col.g = smoothstep(0.,0.25,y);
     if(y < 0.0)
         col = smoothstep(0.,0.5,abs(y)) * vec3(0.2,0,1);
    //col += sin(abs(y*100.) );
    fragColor = vec4(col,1);
    //fragColor = vec4(0,1,1,1);
}