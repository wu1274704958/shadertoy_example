float sdf(vec2 uv)
{
    return 0.25f - length(uv);
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
}