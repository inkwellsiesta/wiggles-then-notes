#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;

uniform float r;

float circle(in vec2 _st, in float _radius){
    vec2 dist = _st-vec2(0.5);
    float retVal = abs(sin(20*(sqrt(dot(dist, dist))+_radius)));
//		(1.-smoothstep(_radius-.1-(_radius*0.01),
//                         _radius-.1+(_radius*0.01),
//                         (dot(dist,dist))*4.0));
   dist = _st-vec2(.75, .25);
   retVal += abs(sin(20*(sqrt(dot(dist,dist))+_radius)));
   return retVal;
}

void main(){
     vec2 st = gl_FragCoord.xy/u_resolution.xy;
     
     vec3 color = vec3(circle(st,r));

     gl_FragColor = vec4( color, 1.0 );
}