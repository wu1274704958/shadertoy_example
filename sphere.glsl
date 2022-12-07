#define TMIN 0.01f
#define TMAX 20.f
#define RAY_MARCH_TIMES 128
#define PRECISION 0.001
#define LIGHT_POS vec3(1,2,-1)
#define LIGHT_DIR vec3(0,0,1)
#define LIGHT_AMBIENT vec3(1)
#define LIGHT_DIFFUSE vec3(1)
#define LIGHT_SPECULAR vec3(1)
#define VIEW_POS vec3(0,0,-1)
#define SHININESS 100.

vec2 fixUV(vec2 c)
{
    return (c - iResolution.xy * 0.5f) / min(iResolution.x, iResolution.y); 
}
float sdf(vec3 uv)
{
    return length(uv + vec3(0,0,-0.7)) - 0.5f;
}
float rayMarch(vec3 vp,vec3 dir){
    float t = TMIN;
    for(int i = 0;i < RAY_MARCH_TIMES && t < TMAX;++i)
    {
        vec3 p = vp + t * dir;
        float d = sdf(p);
        if(abs(d) <= PRECISION)
            return d;
        t += d;
    }
    return t;
}
vec3 calcNormal(vec3 p) // for function f(p)
{
    const float h = 0.0001; // replace by an appropriate value
    const vec2 k = vec2(1,-1);
    return normalize( k.xyy*sdf( p + k.xyy*h ) + 
                      k.yyx*sdf( p + k.yyx*h ) + 
                      k.yxy*sdf( p + k.yxy*h ) + 
                      k.xxx*sdf( p + k.xxx*h ) );
}
vec3 render(vec3 cp,vec2 uv)
{
    vec3 light_pos = vec3(sin(iTime) * 2.,1,cos(iTime) * 2.);
    vec3 col = vec3(1);
    vec3 dir = vec3(uv,0) - cp;
    vec3 vp = cp + dir;
    float dist = rayMarch(vp,normalize(dir));
    if(dist > TMAX)
        return vec3(0);
    vec3 world_pos = vp + normalize(dir) * dist; 
    vec3 nor = calcNormal(world_pos);
    vec3 ambient = 0.01 * LIGHT_AMBIENT * col;
    //diffuse
    vec3 L = normalize(light_pos - world_pos);
    float diff = max(dot(nor, L),0.);
    vec3 diffuse = 1. * diff * LIGHT_DIFFUSE * col;
    //specular
    vec3 view_dir = normalize(VIEW_POS - world_pos);
    vec3 reflect_dir = reflect(-L,nor);
    float spec = pow(max(dot(view_dir,reflect_dir),0.0),SHININESS);
    vec3 specular = 0.5 * spec * LIGHT_SPECULAR * col;
    return ambient + diffuse + spec;
}
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fixUV(fragCoord);
    vec3 col = render(VIEW_POS,uv);
    //col += sin(abs(y*100.) );
    fragColor = vec4(col,1);
}