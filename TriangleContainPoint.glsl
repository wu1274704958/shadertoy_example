
float TriangleContainPoint(vec2 a,vec2 b,vec2 c,vec2 p)
{
	vec2 v0 = c - a;
    vec2 v1 = b - a;
    vec2 v2 = p - a;

    float dot00 = dot(v0, v0);
    float dot01 = dot(v0, v1);
    float dot02 = dot(v0, v2);
    float dot11 = dot(v1, v1);
    float dot12 = dot(v1, v2);

    float invDenom = 1.0 / (dot00 * dot11 - dot01 * dot01);
    float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
    float v = (dot00 * dot12 - dot01 * dot02) * invDenom;

    return (u >= 0.0) && (v >= 0.0) && (u + v <= 1.0) ? 1.0f : 0.0f;
}


mat2 RotateMatrix(float rotate)
{
	mat2 mat;
	mat[0][0] = cos(rotate);
	mat[0][1] = sin(rotate);
	mat[1][0] = -sin(rotate);
	mat[1][1] = cos(rotate);
	return mat;
}

float degreesToRadians(float degrees) {
    return degrees * 0.01745329251;
}
float radiansToDegrees(float radians) {
    return radians * (180.0 / 3.14159265359);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float minR = min(iResolution.x,iResolution.y);
    vec2 uv = fragCoord / minR - vec2( iResolution.x / minR,iResolution.y / minR ) * 0.5f;
    mat2 m = RotateMatrix(degreesToRadians(90.0f));
    vec2 p1 = m * vec2(0.2,0.2);
    vec2 p2 = m * vec2(-0.2,0.2);
    vec2 p3 = m * vec2(0.0,0.0);
    
    vec4 col = vec4(TriangleContainPoint(p1,p2,p3,uv),0,0,1);
    //col = vec4(uv,0,1);
    fragColor = col;
}