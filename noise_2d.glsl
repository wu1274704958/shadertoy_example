#define PI 3.1415926538
float random (in vec2 st) {
    return fract(sin(dot(st.xy,vec2(1562.898,785.233))) * 43758.543);
}

float noise(in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    
    vec2 u = f*f*(3.0-2.0*f);
    float x1 = mix(a,b,u.x);
    float x2 = mix(c,d,u.x);
    float y = mix(x1,x2,u.y);
    return y;
}
float calcNoise(vec3 p)
{
    vec2 np = vec2(0);
    vec3 noz = vec3(p.xy,0.);
    np.x = acos(dot(normalize(noz),vec3(0.99,0.,0.))) / PI;
    vec3 noy = vec3(0.,p.yz);
    np.y = acos(dot(normalize(noy),vec3(0.,0.99,0.))) / PI;
    return noise(np * 3. + iTime) * 0.06;
}

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
#define SHININESS 50.

vec2 fixUV(vec2 c)
{
    return (c - iResolution.xy * 0.5f) / min(iResolution.x, iResolution.y); 
}
float sdf(vec3 uv)
{
    float n = calcNoise(uv);
    return length(uv + vec3(0,0,-0.5)) - 0.5f + n;
}
float rayMarch(in vec3 ro, in vec3 rd) {
    float t = TMIN;
    for(int i = 0; i < RAY_MARCH_TIMES && t < TMAX; i++) {
        vec3 p = ro + t * rd;
        float d = sdf(p);
        if(d < PRECISION)
            break;
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
    vec3 dir = vec3(uv,0) - cp;
    vec3 vp = cp + dir;
    float dist = rayMarch(vp,normalize(dir));
    if(dist > TMAX)
        return vec3(0);
    vec3 world_pos = vp + normalize(dir) * dist; 
    vec3 col = vec3(1.);//vec3(0,calcNoise(world_pos),0);
    vec3 nor = calcNormal(world_pos);
    vec3 ambient = 0.06 * LIGHT_AMBIENT * col;
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