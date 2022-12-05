void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec3 col = vec3(0);
    vec2 uv = fragCoord / iResolution.xy;
    float y = smoothstep(0., 1., uv.x);
    if(abs(y - uv.y) < min(fwidth(uv.x),fwidth(uv.y)))
        col.r = 1.;
    fragColor = vec4(col,1);
}