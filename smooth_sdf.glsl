float sdf(vec2 uv)
{
    float y = smoothstep(0., 1., uv.x);
    return y - uv.y;
}
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec3 col = vec3(0);
    vec2 uv = fragCoord / iResolution.xy;
    float y = sdf(uv);
    col.g = abs(y);
    col += sin(abs(y*100.) + cos(iTime) * 10.);
    fragColor = vec4(col,1);
}