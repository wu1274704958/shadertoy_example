void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float minR = min(iResolution.x,iResolution.y);
    vec2 uv = fragCoord / minR - vec2( iResolution.x / minR,iResolution.y / minR ) * 0.5f;
    vec4 col = vec4(0,0,0,1);
    if(length(uv) < 0.4f)
        col.y = 1.;
    fragColor = col;
}