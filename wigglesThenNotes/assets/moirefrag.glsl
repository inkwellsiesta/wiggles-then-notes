// Author @patriciogv - 2015
// http://patriciogonzalezvivo.com

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;

uniform float r;

float circle(in vec2 _st, in float _radius){
    vec2 dist = _st-vec2(0.5);
    return 1.-smoothstep(_radius-(_radius*0.01),
                         _radius+(_radius*0.01),
                         dot(dist,dist)*4.0);
}

void main(){
     vec2 st = gl_FragCoord.xy/u_resolution.xy;
     
     vec3 color = vec3(circle(st,r));

     gl_FragColor = vec4( color, 1.0 );
}