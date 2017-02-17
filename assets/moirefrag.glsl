#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;

uniform float r; // radius
uniform float n;
uniform float m; // multiplier
uniform bool flip; // flip black and white?22

float circle(in vec2 _st, in float _radius){
    vec2 dist = _st-vec2(.75*m, .5*m);
    float retVal = sin(n*(sqrt(dot(dist, dist))+_radius));
//		(1.-smoothstep(_radius-.1-(_radius*0.01),
//                         _radius-.1+(_radius*0.01),
//                        (dot(dist,dist))*4.0));
   dist = _st-vec2(.25*m, .25*m);
   retVal += cos(n*(sqrt(dot(dist,dist))+_radius));
   dist = _st-vec2(.5*m, .75*m);
   retVal += sin(n*(sqrt(dot(dist,dist))+_radius));
   retVal += .5;
   if (flip) retVal *= -1.;
   //retVal /= m;
   return retVal;
}

void main(){
     vec2 st = gl_FragCoord.xy/u_resolution.xy*m;
     
     vec3 color = vec3(circle(st,r));
     
     gl_FragColor = vec4( color, 1.0 );
}