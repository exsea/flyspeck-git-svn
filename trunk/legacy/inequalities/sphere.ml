(*
2009 definitions.


*)

let atn2 = new_definition(`atn2(x,y) =
    if ( abs y < x ) then atn(y / x) else
    (if (&0 < y) then ((pi / &2) - atn(x / y)) else
    (if (y < &0) then (-- (pi/ &2) - atn (x / y)) else (  pi )))`);;

(* ------------------------------------------------------------------ *)

let sqrt8 = new_definition (`sqrt8 = sqrt (&8) `);;
let sqrt2 = new_definition (`sqrt2 = sqrt (&2) `);;

let pi_rt18 = new_definition(`pi_rt18= pi/(sqrt (&18))`);;


(* ------------------------------------------------------------------ *)
(*  This polynomial is essentially the Cayley-Menger determinant.     *)
(* ------------------------------------------------------------------ *)
let delta_x = kepler_def (`delta_x x1 x2 x3 x4 x5 x6 =
        x1*x4*(--x1 + x2 + x3 -x4 + x5 + x6) +
        x2*x5*(x1 - x2 + x3 + x4 -x5 + x6) +
        x3*x6*(x1 + x2 - x3 + x4 + x5 - x6)
        -x2*x3*x4 - x1*x3*x5 - x1*x2*x6 -x4*x5*x6`);;

(* ------------------------------------------------------------------ *)
(*   The partial derivative of delta_x with respect to x4.            *)
(* ------------------------------------------------------------------ *)

let delta_x4 = kepler_def(`delta_x4 x1 x2 x3 x4 x5 x6
        =  -- x2* x3 -  x1* x4 + x2* x5
        + x3* x6 -  x5* x6 + x1* (-- x1 +  x2 +  x3 -  x4 +  x5 +  x6)`);;

let delta_x6 = kepler_def(`delta_x6 x1 x2 x3 x4 x5 x6
	= -- x1 * x2 - x3*x6 + x1 * x4
	+ x2* x5 - x4* x5 + x3*(-- x3 + x1 + x2 - x6 + x4 + x5)`);;

(* ------------------------------------------------------------------ *)
(*  Circumradius       .                                              *)
(* ------------------------------------------------------------------ *)

(* same as ups_x 
let u_x = kepler_def(
        `u_x x1 x2 x3 = (--(x1*x1+x2*x2+x3*x3)) +
        (&2) * (x1*x2+x2*x3+x3*x1)`);;
*)

let ups_x = kepler_def(`ups_x x1 x2 x6 = 
    --x1*x1 - x2*x2 - x6*x6 
    + &2 *x1*x6 + &2 *x1*x2 + &2 *x2*x6`);;


let eta_x = kepler_def(`eta_x x1 x2 x3 =
        (sqrt ((x1*x2*x3)/(ups_x x1 x2 x3)))
        `);;

let eta_y = kepler_def(`eta_y y1 y2 y3 =
                let x1 = y1*y1 in
                let x2 = y2*y2 in
                let x3 = y3*y3 in
                eta_x x1 x2 x3`);;

let rho_x = kepler_def(`rho_x x1 x2 x3 x4 x5 x6 =
        --x1*x1*x4*x4 - x2*x2*x5*x5 - x3*x3*x6*x6 +
        (&2)*x1*x2*x4*x5 + (&2)*x1*x3*x4*x6 + (&2)*x2*x3*x5*x6`);;

let rad2_y = kepler_def(`rad2_y y1 y2 y3 y4 y5 y6 =
        let (x1,x2,x3,x4,x5,x6)= (y1*y1,y2*y2,y3*y3,y4*y4,y5*y5,y6*y6) in
        (rho_x x1 x2 x3 x4 x5 x6)/((delta_x x1 x2 x3 x4 x5 x6)*(&4))`);;


let chi_x = kepler_def(`chi_x x1 x2 x3 x4 x5 x6
        = -- (x1*x4*x4) + x1*x4*x5 + x2*x4*x5 -  x2*x5*x5
        + x1*x4*x6 + x3*x4*x6 +
   x2*x5*x6 + x3*x5*x6 -  (&2) * x4*x5*x6 -  x3*x6*x6`);;



(* ------------------------------------------------------------------ *)
(*   The formula for the dihedral angle of a simplex.                 *)
(*   The variables xi are the squares of the lengths of the edges.    *)
(*   The angle is computed along the first edge (x1).                 *)
(* ------------------------------------------------------------------ *)

let dih_x = kepler_def(`dih_x x1 x2 x3 x4 x5 x6 =
       let d_x4 = delta_x4 x1 x2 x3 x4 x5 x6 in
       let d = delta_x x1 x2 x3 x4 x5 x6 in
       pi/ (&2) +  atn2( (sqrt ((&4) * x1 * d)),--  d_x4)`);;


let dih_y = kepler_def(`dih_y y1 y2 y3 y4 y5 y6 =
       let (x1,x2,x3,x4,x5,x6)= (y1*y1,y2*y2,y3*y3,y4*y4,y5*y5,y6*y6) in
       dih_x x1 x2 x3 x4 x5 x6`);;

let dih2_y = kepler_def(`dih2_y y1 y2 y3 y4 y5 y6 =
        dih_y y2 y1 y3 y5 y4 y6`);;

let dih3_y = kepler_def(`dih3_y y1 y2 y3 y4 y5 y6 =
        dih_y y3 y1 y2 y6 y4 y5`);;

let dih2_x = kepler_def(`dih2_x x1 x2 x3 x4 x5 x6 =
        dih_x x2 x1 x3 x5 x4 x6`);;

let dih3_x = kepler_def(`dih3_x x1 x2 x3 x4 x5 x6 =
	dih_x x3 x1 x2 x6 x4 x5`);;


(* ------------------------------------------------------------------ *)
(*   Harriot-Euler formula for the area of a spherical triangle       *)
(*   in terms of the angles: area = alpha+beta+gamma - pi             *)
(* ------------------------------------------------------------------ *)

let sol_x = kepler_def(`sol_x x1 x2 x3 x4 x5 x6 =
        (dih_x x1 x2 x3 x4 x5 x6) +
        (dih_x x2 x3 x1 x5 x6 x4) +  (dih_x x3 x1 x2 x6 x4 x5) -  pi`);;

let sol_y = kepler_def(`sol_y y1 y2 y3 y4 y5 y6 =
        (dih_y y1 y2 y3 y4 y5 y6) +
        (dih_y y2 y3 y1 y5 y6 y4) +  (dih_y y3 y1 y2 y6 y4 y5) -  pi`);;


(* ------------------------------------------------------------------ *)
(*   The Cayley-Menger formula for the volume of a simplex            *)
(*   The variables xi are the squares of the lengths of the edges.    *)
(* ------------------------------------------------------------------ *)

let vol_x = kepler_def(`vol_x x1 x2 x3 x4 x5 x6 =
        (sqrt (delta_x x1 x2 x3 x4 x5 x6))/ (&12)`);;

(* ------------------------------------------------------------------ *)
(*   Some lower dimensional funcions and Rogers simplices.            *)
(* ------------------------------------------------------------------ *)

let arclength = kepler_def(`arclength a b c =
        pi/(&2) + (atn2( (sqrt (ups_x (a*a) (b*b) (c*c))),(c*c - a*a  -b*b)))`);;


let volR = kepler_def(`volR a b c =
        (sqrt (a*a*(b*b-a*a)*(c*c-b*b)))/(&6)`);;

let solR = kepler_def(`solR a b c =
        (&2)*atn2( sqrt(((c+b)*(b+a))), sqrt ((c-b)*(b-a)))`);;

let dihR = kepler_def(`dihR a b c =
        atn2( sqrt(b*b-a*a),sqrt (c*c-b*b))`);;

let vorR = kepler_def(`vorR a b c =
        (&4)*(--doct*(volR a b c) + (solR a b c)/(&3))`);;

let rad2_x = kepler_def(`rad2_x x1 x2 x3 x4 x5 x6 =
        (rho_x x1 x2 x3 x4 x5 x6)/((delta_x x1 x2 x3 x4 x5 x6)*(&4))`);;

(*  deprecated:

let d3 = new_definition `d3 (v:real^3) w = dist(v,w)`;; 

let mk_vec3 = new_definition `mk_vec3 a b c = vector[a; b; c]`;;

let real3_of_triple = new_definition `real3_of_triple (a,b,c) = (mk_vec3 a b c):real^3`;;

let triple_of_real3 = new_definition `triple_of_real3 (v:real^3) = 
    (v$1, v$2, v$3)`;;



*)

(* aff is deprecated *)
let aff = new_definition `aff = ( hull ) affine`;;

let lin_combo = new_definition `lin_combo V f = vsum V (\v. f v % (v:real^N))`;;

let affsign = new_definition `affsign sgn s t (v:real^A) = (?f.
  (v = lin_combo (s UNION t) f) /\ (!w. t w ==> sgn (f w)) /\ (sum (s UNION t) f = &1))`;;


let sgn_gt = new_definition `sgn_gt = (\t. (&0 < t))`;;
let sgn_ge = new_definition `sgn_ge = (\t. (&0 <= t))`;;
let sgn_lt = new_definition `sgn_lt = (\t. (t < &0))`;;
let sgn_le = new_definition `sgn_le = (\t. (t <= &0))`;;

(* conv is deprecated.  Use `convex hull S` instead *)

let conv = new_definition `conv S:real^A->bool = affsign sgn_ge {} S`;;
let conv0 = new_definition `conv0 S:real^A->bool = affsign sgn_gt {} S`;;
let cone = new_definition `cone v S:real^A->bool = affsign sgn_ge {v} S`;;
let cone0 = new_definition `cone0 v S:real^A->bool = affsign sgn_gt {v} S`;;


let aff_gt_def = new_definition `aff_gt = affsign sgn_gt`;;
let aff_ge_def = new_definition `aff_ge = affsign sgn_ge`;;
let aff_lt_def = new_definition `aff_lt = affsign sgn_lt`;;
let aff_le_def = new_definition `aff_le = affsign sgn_le`;;

let voronoi = new_definition `voronoi v S = { x | !w. ((S w) /\ ~(w=v)) ==> (dist( x, v) < dist( x, w)) }`;;

let voronoi_le = new_definition `voronoi_le v S = { x | !w. ((S w) /\ ~(w=v)) ==> (dist( x, v) <= dist( x, w)) }`;;

let line = new_definition `line x = (?v w. ~(v  =w) /\ (x = affine hull {v,w}))`;;

let plane = new_definition `plane x = (?u v w. ~(collinear {u,v,w}) /\ (x = affine hull {u,v,w}))`;;
let closed_half_plane = new_definition `closed_half_plane x = (?u v w. ~(collinear {u,v,w}) /\ (x = aff_ge {u,v} {w}))`;;
let open_half_plane = new_definition `open_half_plane x = (?u v w. ~(collinear {u,v,w}) /\ (x = aff_gt {u,v} {w}))`;;
let coplanar = new_definition `coplanar S = (?x. plane x /\ S SUBSET x)`;;
let closed_half_space = new_definition `closed_half_space x = (?u v w w'. ~(coplanar {u,v,w,w'}) /\ (x = aff_ge {u,v,w} {w'}))`;;
let open_half_space = new_definition `open_half_space x = (?u v w w'. ~(coplanar {u,v,w,w'}) /\ (x = aff_gt {u,v,w} {w'}))`;;

(* WMJHKBL *)
let bis = new_definition `bis u v = {x | dist(x,u) = dist(x,v)}`;;

(* TIWZVEW *)
let bis_le = new_definition `bis_le u v = {x | dist(x,u) <= dist(x,v) }`;;
let bis_lt = new_definition `bis_lt u v = {x | dist(x,u) < dist(x,v) }`;;

(* XCJABYH *)
let circumcenter = new_definition `circumcenter S = @v. ( (affine hull S) v /\ (?c. !w. (S w) ==> (c = dist(v,w))))`;;

(* XPLPHNG *)
(* circumradius *)
let radV = new_definition `radV S = @c. !w. (S w) ==> (c = dist(circumcenter S,w))`;;



(* EOBLRCS *)
let orientation = new_definition `orientation S v sgn = affsign sgn (S DIFF {v}) {v} (circumcenter S)`;;

(* ANGLE *)

let arcV = new_definition `arcV u v w = acs (( (v - u) dot (w - u))/((norm (v-u)) * (norm (w-u))))`;;

let dihV = new_definition  `dihV w0 w1 w2 w3 = 
     let va = w2 - w0 in
     let vb = w3 - w0 in
     let vc = w1 - w0 in
     let vap = ( vc dot vc) % va - ( va dot vc) % vc in
     let vbp = ( vc dot vc) % vb - ( vb dot vc) % vc in
       arcV (vec 0) vap vbp`;;

(* polar coordinates *)

let radius = new_definition `radius x y = sqrt((x pow 2) + (y pow 2))`;;
let polar_angle = new_definition `polar_angle x y = 
         let theta = atn2(x,y) in
	 if (theta < &0) then (theta + (&2 * pi)) else theta`;;
let polar_c = new_definition `polar_c x y = (radius x y,polar_angle x y)`;;

let less_polar = new_definition `less_polar (x,y) (x',y') = 
        let (r,theta) = polar_c x y in
	let (r',theta') = polar_c x' y' in
        (theta < theta') \/ ((theta =theta') /\ (r < r'))`;;

let min_polar = new_definition `min_polar V = ( @ u. V u /\ (!w. V w /\ ~(u = w) ==> (less_polar u w)))`;;

let polar_cycle = new_definition `polar_cycle V v =  
       let W = {u  | V u /\ less_polar v u} in
       if (W = EMPTY) then min_polar V else min_polar W`;;

let iter_spec = prove(`?iter. !f u:A. (iter 0 f u = u) /\ (!n. (iter (SUC n) f u = f(iter n f u)))`,
    (SUBGOAL_THEN `?g. !f (u:A).  (g f u 0 = u) /\ (!n. (g f u (SUC n) = f (g f u n)))` CHOOSE_TAC) THENL
     ([REWRITE_TAC[GSYM SKOLEM_THM;num_RECURSION_STD];REWRITE_TAC[]]) THEN
     (EXISTS_TAC `\ (i:num) (f:A->A)  (u:A). (g f u i):A`) THEN
      (BETA_TAC) THEN
     (ASM_REWRITE_TAC[]));;

let iter = new_specification ["iter"] iter_spec;;

let orthonormal = new_definition `orthonormal e1 e2 e3 = 
     (( e1 dot e1 = &1) /\ (e2 dot e2 = &1) /\ ( e3 dot e3 = &1) /\
     ( e1 dot e2 = &0) /\ ( e1 dot e3 = &0) /\ ( e2 dot e3 = &0) /\
     (&0 <  (cross e1 e2) dot e3))`;;

(* spherical coordinates *)
let azim_hyp_def = new_definition `azim_hyp = (!v w w1 w2. ?theta. !e1 e2 e3. ?psi h1 h2 r1 r2.
   ~(collinear {v, w, w1}) /\ ~(collinear {v, w, w2}) /\
   (orthonormal e1 e2 e3) /\ ((dist( w, v)) % e3 = (w - v)) ==>
   ((&0 <= theta) /\ (theta < &2 * pi) /\ (&0 < r1) /\ (&0 < r2) /\
   (w1 - v = (r1 * cos(psi)) % e1 + (r1 * sin(psi)) % e2 + h1 % (w-v)) /\
   (w2 - v = (r2 * cos(psi + theta)) % e1 + (r2 * sin(psi + theta)) % e2 + h2 % (w-v))))`;;

let azim_spec = prove(`?theta. !v w w1 w2 e1 e2 e3. ?psi h1 h2 r1 r2.
   (azim_hyp) ==>
   ~(collinear {v, w, w1}) /\ ~(collinear {v, w, w2}) /\
   (orthonormal e1 e2 e3) /\ ((dist( w, v)) % e3 = (w - v)) ==>
   ((&0 <= theta v w w1 w2) /\ (theta v w w1 w2 < &2 * pi) /\ (&0 < r1) /\ (&0 < r2) /\
   (w1 - v = (r1 * cos(psi)) % e1 + (r1 * sin(psi)) % e2 + h1 % (w-v)) /\
   (w2 - v = (r2 * cos(psi + theta v w w1 w2)) % e1 + (r2 * sin(psi + theta v w w1 w2)) % e2 + h2 % (w-v)))`,
   (REWRITE_TAC[GSYM SKOLEM_THM;GSYM RIGHT_IMP_EXISTS_THM;GSYM RIGHT_IMP_FORALL_THM]) THEN
     (REWRITE_TAC[azim_hyp_def]) THEN
     (REPEAT STRIP_TAC) THEN
     (ASM_REWRITE_TAC[RIGHT_IMP_EXISTS_THM]));;

let azim_def = new_specification ["azim"] azim_spec;;


let cyclic_set = new_definition `cyclic_set W v w = 
     (~(v=w) /\ (FINITE W) /\ (!p q h. W p /\ W q /\ (p = q + h % (v - w)) ==> (p=q)) /\
        (W INTER (affine hull {v,w}) = EMPTY))`;;




let azim_cycle_hyp_def = new_definition `azim_cycle_hyp = 
  (?sigma.  !W proj v w e1 e2 e3 p. 
        (W p) /\
        (cyclic_set W v w) /\ ((dist( v ,w)) % e3 = (w-v)) /\
	(orthonormal e1 e2 e3) /\ 
	(!u x y. (proj u = (x,y)) <=> (?h. (u = v + x % e1 + y % e2 + h % e3))) ==>
	(proj (sigma W v w p) = polar_cycle (IMAGE proj W) (proj p)))`;;

let azim_cycle_spec = prove(`?sigma. !W proj v w e1 e2 e3 p.
   (azim_cycle_hyp) ==> ( (W p) /\
        (cyclic_set W v w) /\ ((dist( v ,w)) % e3 = (w-v)) /\
	(orthonormal e1 e2 e3) /\ 
	(!u x y. (proj u = (x,y)) <=> (?h. (u = v + x % e1 + y % e2 + h % e3)))) ==> (proj (sigma W v w p) = polar_cycle (IMAGE proj W) (proj p))`,
	(REWRITE_TAC[GSYM RIGHT_IMP_EXISTS_THM;GSYM RIGHT_IMP_FORALL_THM]) THEN
	  (REWRITE_TAC[azim_cycle_hyp_def])
	   );;

let azim_cycle_def = new_specification ["azim_cycle"] azim_cycle_spec;;	


(* ------------------------------------------------------------------ *)
(*   Definitions from the Collection in Elementary Geometry           *)
(* ------------------------------------------------------------------ *)

(* EDSFZOT *)

let cayleyR = new_definition `cayleyR x12 x13 x14 x15  x23 x24 x25  x34 x35 x45 = 
  -- (x14*x14*x23*x23) + &2 *x14*x15*x23*x23 - x15*x15*x23*x23 + &2 *x13*x14*x23*x24 - &2 *x13*x15*x23*x24 - &2 *x14*x15*x23*x24 + 
   &2 *x15*x15*x23*x24 - x13*x13*x24*x24 + &2 *x13*x15*x24*x24 - x15*x15*x24*x24 - &2 *x13*x14*x23*x25 + 
   &2 *x14*x14*x23*x25 + &2 *x13*x15*x23*x25 - &2 *x14*x15*x23*x25 + &2 *x13*x13*x24*x25 - &2 *x13*x14*x24*x25 - &2 *x13*x15*x24*x25 + 
   &2 *x14*x15*x24*x25 - x13*x13*x25*x25 + &2 *x13*x14*x25*x25 - x14*x14*x25*x25 + &2 *x12*x14*x23*x34 - &2 *x12*x15*x23*x34 - 
   &2 *x14*x15*x23*x34 + &2 *x15*x15*x23*x34 + &2 *x12*x13*x24*x34 - &2 *x12*x15*x24*x34 - &2 *x13*x15*x24*x34 + &2 *x15*x15*x24*x34 + 
   &4 *x15*x23*x24*x34 - &2 *x12*x13*x25*x34 - &2 *x12*x14*x25*x34 + &4 *x13*x14*x25*x34 + &4 *x12*x15*x25*x34 - &2 *x13*x15*x25*x34 - &2 *x14*x15*x25*x34 - 
   &2 *x14*x23*x25*x34 - &2 *x15*x23*x25*x34 - &2 *x13*x24*x25*x34 - &2 *x15*x24*x25*x34 + &2 *x13*x25*x25*x34 + &2 *x14*x25*x25*x34 - 
   x12*x12*x34*x34 + &2 *x12*x15*x34*x34 - x15*x15*x34*x34 + &2 *x12*x25*x34*x34 + &2 *x15*x25*x34*x34 - 
   x25*x25*x34*x34 - &2 *x12*x14*x23*x35 + &2 *x14*x14*x23*x35 + &2 *x12*x15*x23*x35 - &2 *x14*x15*x23*x35 - &2 *x12*x13*x24*x35 + 
   &4 *x12*x14*x24*x35 - &2 *x13*x14*x24*x35 - &2 *x12*x15*x24*x35 + &4 *x13*x15*x24*x35 - &2 *x14*x15*x24*x35 - &2 *x14*x23*x24*x35 - &2 *x15*x23*x24*x35 + 
   &2 *x13*x24*x24*x35 + &2 *x15*x24*x24*x35 + &2 *x12*x13*x25*x35 - &2 *x12*x14*x25*x35 - &2 *x13*x14*x25*x35 + &2 *x14*x14*x25*x35 + 
   &4 *x14*x23*x25*x35 - &2 *x13*x24*x25*x35 - &2 *x14*x24*x25*x35 + &2 *x12*x12*x34*x35 - &2 *x12*x14*x34*x35 - &2 *x12*x15*x34*x35 + 
   &2 *x14*x15*x34*x35 - &2 *x12*x24*x34*x35 - &2 *x15*x24*x34*x35 - &2 *x12*x25*x34*x35 - &2 *x14*x25*x34*x35 + &2 *x24*x25*x34*x35 - 
   x12*x12*x35*x35 + &2 *x12*x14*x35*x35 - x14*x14*x35*x35 + &2 *x12*x24*x35*x35 + &2 *x14*x24*x35*x35 - 
   x24*x24*x35*x35 + &4 *x12*x13*x23*x45 - &2 *x12*x14*x23*x45 - &2 *x13*x14*x23*x45 - &2 *x12*x15*x23*x45 - &2 *x13*x15*x23*x45 + 
   &4 *x14*x15*x23*x45 + &2 *x14*x23*x23*x45 + &2 *x15*x23*x23*x45 - &2 *x12*x13*x24*x45 + &2 *x13*x13*x24*x45 + &2 *x12*x15*x24*x45 - 
   &2 *x13*x15*x24*x45 - &2 *x13*x23*x24*x45 - &2 *x15*x23*x24*x45 - &2 *x12*x13*x25*x45 + &2 *x13*x13*x25*x45 + &2 *x12*x14*x25*x45 - 
   &2 *x13*x14*x25*x45 - &2 *x13*x23*x25*x45 - &2 *x14*x23*x25*x45 + &4 *x13*x24*x25*x45 + &2 *x12*x12*x34*x45 - &2 *x12*x13*x34*x45 - 
   &2 *x12*x15*x34*x45 + &2 *x13*x15*x34*x45 - &2 *x12*x23*x34*x45 - &2 *x15*x23*x34*x45 - &2 *x12*x25*x34*x45 - &2 *x13*x25*x34*x45 + &2 *x23*x25*x34*x45 + 
   &2 *x12*x12*x35*x45 - &2 *x12*x13*x35*x45 - &2 *x12*x14*x35*x45 + &2 *x13*x14*x35*x45 - &2 *x12*x23*x35*x45 - &2 *x14*x23*x35*x45 - 
   &2 *x12*x24*x35*x45 - &2 *x13*x24*x35*x45 + &2 *x23*x24*x35*x45 + &4 *x12*x34*x35*x45 - x12*x12*x45*x45 + &2 *x12*x13*x45*x45 - 
   x13*x13*x45*x45 + &2 *x12*x23*x45*x45 + &2 *x13*x23*x45*x45 - x23*x23*x45*x45`;;


(* PUSACOU *)

let packing = new_definition `packing S = (!u v. S u /\ S v /\ ~(u = v) ==> (&2 <= dist( u, v)))`;;

(* SIDEXYO *)

let wedge = new_definition (`wedge v1 v2 w1 w2 = 
   let z = v2 - v1 in
   let u1 = w1 - v1 in
   let u2 = w2 - v1 in
   let n = cross z u1 in
   let d =  n dot u2 in
     if (aff_ge {v1,v2} {w1} w2) then {} else
     if (aff_lt {v1,v2} {w1} w2) then aff_gt {v1,v2,w1} {n} else
     if (d > &0) then aff_gt {v1,v2} {w1,w2} else
     (:real^3) DIFF aff_ge {v1,v2} {w1,w2}`);;

(* ------------------------------------------------------------------ *)
(*   Measure and Volume, following Nguyen Tat Thang  *)
(* ------------------------------------------------------------------ *)

let sphere= new_definition`sphere x=(?(v:real^3)(r:real). (r> &0)/\ (x={w:real^3 | norm (w-v)= r}))`;;

let c_cone = new_definition `c_cone (v,w:real^3, r:real)={x:real^3 | ((x-v) dot w = norm (x-v)* norm w* r)}`;;

let circular_cone =new_definition `circular_cone (V:real^3-> bool)=
(? (v,w:real^3)(r:real). V= c_cone (v,w,r))`;;

let NULLSET_RULES,NULLSET_INDUCT,NULLSET_CASES =
  new_inductive_definition
    `(!P. ((plane P)\/ (sphere P) \/ (circular_cone P)) ==> NULLSET P) /\
     !(s:real^3->bool) t. (NULLSET s /\ NULLSET t) ==> NULLSET (s UNION t)`;;

let null_equiv = new_definition `null_equiv (s,t :real^3->bool)=(? (B:real^3-> bool). NULLSET B /\ 
((s DIFF t) UNION (t DIFF s)) SUBSET B)`;;


let normball = new_definition `normball x r = { y:real^A | dist(y,x) < r}`;;

let radial = new_definition `radial r x C <=> (C SUBSET normball x r) /\ (!u. (x+u) IN C ==> (!t.(t> &0) /\ (t* norm u < r)==>(x+ t % u) IN C))`;;

let eventually_radial = new_definition `eventually_radial x C <=> (?r. (r> &0) /\ radial r x (C INTER normball x r))`;;

let solid_triangle = new_definition `solid_triangle v0 S r = normball v0 r INTER cone v0 S`;;

let rconesgn = new_definition `rconesgn sgn v w h = {x:real^A | sgn ((x-v) dot (w-v)) (dist(x,v)*dist(w,v)*h)}`;;

(* drop primes *)

let rcone_ge = new_definition `rcone_ge = rconesgn ( >= )`;;
let rcone_gt = new_definition `rcone_gt = rconesgn ( > )`;;
let rcone_lt = new_definition `rcone_lt = rconesgn ( < )`;;
let rcone_eq = new_definition `rcone_eq = rconesgn ( = )`;;

let scale = new_definition `scale (t:real^3) (u:real^3) = vector[t$1 * u$1; t$2 * u$2; t$3 * u$3]`;;

let ellipsoid = new_definition `ellipsoid t r = IMAGE (scale t) (normball(vec 0)r)`;;

let conic_cap = new_definition `conic_cap v0 v1 r a = normball v0 r INTER rcone_gt v0 v1 a`;;

let frustum = new_definition `frustum v0 v1 h1 h2 a = { y | rcone_gt v0 v1 a y /\
		let d = (y - v0) dot (v1 - v0) in
		let n = norm(v1 - v0) in
                  (h1*n < d /\ d < h2*n)}`;;

let frustt = new_definition `frustt v0 v1 h a = frustum v0 v1 (&0) h a`;;

let rect = new_definition `rect (a:real^3) (b:real^3) = {(v:real^3) | !i. ( a$i < v$i /\ v$i < b$i )}`;;

(*
let is_tetrahedron = new_definition `is_tetrahedron S = ?v0 v1 v2 v3. (S = conv0 {v0,v1,v2,v3})`;;
*)

let primitive = new_definition `primitive (C:real^3->bool) = 
  ((?v0 v1 v2 v3 r.  (C = solid_triangle v0 {v1,v2,v3} r)) \/
  (?v0 v1 v2 v3. (C = conv0 {v0,v1,v2,v3})) \/
  (?v0 v1 v2 v3 h a. (C = frustt v0 v1 h a INTER wedge v0 v1 v2 v3)) \/
  (?v0 v1 v2 v3 r c. (C = conic_cap v0 v1 r c INTER wedge v0 v1 v2 v3)) \/
  (?a b.  (C = rect a b)) \/
  (?t r. (C = ellipsoid t r)) \/
  (?v0 v1 v2 v3 r. (C = normball v0 r INTER wedge v0 v1 v2 v3)))`;;

let MEASURABLE_RULES,MEASURABLE_INDUCT,MEASURABLE_CASES =
  new_inductive_definition
    `(!C. primitive C ==> measurable C) /\
    ( !Z. NULLSET Z ==> measurable Z) /\
     (!X t. measurable X ==> (measurable (IMAGE (scale t) X))) /\
     (!X v. measurable X ==> (measurable (IMAGE ((+) v) X))) /\
    ( !(s:real^3->bool) t. (measurable s /\ measurable t) ==> measurable (s UNION t)) /\
    ( !(s:real^3->bool) t. (measurable s /\ measurable t) ==> measurable (s INTER t)) /\
    ( !(s:real^3->bool) t. (measurable s /\ measurable t) ==> measurable (s DIFF t))
   `;;


let SDIFF = new_definition `SDIFF X Y = (X DIFF Y) UNION (Y DIFF X)`;;


let vol_solid_triangle = new_definition `vol_solid_triangle v0 v1 v2 v3 r = 
   let a123 = dihV v0 v1 v2 v3 in
   let a231 = dihV v0 v2 v3 v1 in
   let a312 = dihV v0 v3 v1 v2 in
     (a123 + a231 + a312 - pi)*(r pow 3)/(&3)`;;

let vol_frustt_wedge = new_definition `vol_frustt_wedge v0 v1 v2 v3 h a = 
       (azim v0 v1 v2 v3)*(h pow 3)*(&1/(a*a) - &1)/(&6)`;;

(* volume of intersection of conic cap and wedge *)
let vol_conic_cap_wedge = new_definition `vol_conic_cap_wedge v0 v1 v2 v3 r c = 
       (azim v0 v1 v2 v3)*(&1 - c)*(r pow 3)/(&3)`;;


let vol_conv = new_definition `vol_conv v1 v2 v3 v4 =
   let x12 = dist(v1,v2) pow 2 in
   let x13 = dist(v1,v3) pow 2 in
   let x14 = dist(v1,v4) pow 2 in
   let x23 = dist(v2,v3) pow 2 in
   let x24 = dist(v2,v4) pow 2 in
   let x34 = dist(v3,v4) pow 2 in
   sqrt(delta_x x12 x13 x14 x34 x24 x34)/(&12)`;;

let vol_rect = new_definition `vol_rect a b = 
   if (a$1 < b$1) /\ (a$2 < b$2) /\ (a$3 < b$3) then (b$3-a$3)*(b$2-a$2)*(b$1-a$1) else &0`;;

let vol_ball_wedge = new_definition `vol_ball_wedge v0 v1 v2 v3 r = 
   (azim v0 v1 v2 v3)*(&2)*(r pow 3)/(&3)`;;


let volume_props = new_definition `volume_props  (vol:(real^3->bool)->real) = 
    ( (!C. vol C >= &0) /\
     (!Z. NULLSET Z ==> (vol Z = &0)) /\
     (!X Y. measurable X /\ measurable Y /\ NULLSET (SDIFF X Y) ==> (vol X = vol Y)) /\
     (!X t. (measurable X) /\ (measurable (IMAGE (scale t) X)) ==> (vol (IMAGE (scale t) X) = abs(t$1 * t$2 * t$3)*vol(X))) /\
     (!X v. measurable X ==> (vol (IMAGE ((+) v) X) = vol X)) /\
     (!v0 v1 v2 v3 r. (r > &0) /\ (~(collinear {v0,v1,v2})) /\ ~(collinear {v0,v1,v3}) ==> vol (solid_triangle v0 {v1,v2,v3} r) = vol_solid_triangle v0 v1 v2 v3 r) /\
     (!v0 v1 v2 v3. vol(conv0 {v0,v1,v2,v3}) = vol_conv v0 v1 v2 v3) /\
     (!v0 v1 v2 v3 h a. ~(collinear {v0,v1,v2}) /\ ~(collinear {v0,v1,v3}) /\ (h >= &0) /\ (a > &0) /\ (a <= &1) ==> vol(frustt v0 v1 h a INTER wedge v0 v1 v2 v3) = vol_frustt_wedge v0 v1 v2 v3 h a) /\
     (!v0 v1 v2 v3 r c.  ~(collinear {v0,v1,v2}) /\ ~(collinear {v0,v1,v3}) /\ (r >= &0) /\ (c >= -- (&1)) /\ (c <= &1) ==> (vol(conic_cap v0 v1 r c INTER wedge v0 v1 v2 v3) = vol_conic_cap_wedge v0 v1 v2 v3 r c)) /\ 
     (!(a:real^3) (b:real^3). vol(rect a b) = vol_rect a b) /\
     (!v0 v1 v2 v3 r. ~(collinear {v0,v1,v2}) /\ ~(collinear {v0,v1,v3}) /\ (r >= &0)  ==> (vol(normball v0 r INTER wedge v0 v1 v2 v3) = vol_ball_wedge v0 v1 v2 v3 r)))`;;

let vol_def = new_definition `vol = ( @ ) volume_props`;;

let solid = new_definition `solid x C = (@s. ?c. (c > &0) /\ (!r. (r > &0) /\ (r < c) ==> 
     (s = &3 * vol(C INTER normball x r)/(r pow 3))))  `;;

let sovo = new_definition `sovo x C (v,s) = v* vol(C) + s* solid x C`;;

let phivo = new_definition `phivo h t (v,s) = v*t*h*(t+h)/(&6) + s`;;

let avo = new_definition `avo h t l= (&1 - h/t)*(phivo h t l - phivo t t l)`;;

let ortho0 = new_definition `ortho0 x v1 v2 v3 = conv0 {x,x+v1,x+v1+v2,x+v1+v2+v3}`;;

let make_point = new_definition `make_point v1 v2 v3 w r1 r2 r3 = @v. (aff_ge {v1,v2,v3} {w} (v:real^3)) /\ (r1 = dist(v1,v)) /\ (r2 = dist(v2,v)) /\ (r3 = dist(v3,v))`;;

let rogers = new_definition `rogers v0 v1 v2 v3 c = 
   let w = (&1/ (&2)) % (v0 + v1) in
   let p = circumcenter {v0,v1,v2} in
   let q = make_point v0 v1 v2 v3 c c c in
   conv {v0,w,p,q}`;;

let rogers0 = new_definition `rogers0 v0 v1 v2 v3 c = 
   let w = (&1/ (&2)) % (v0 + v1) in
   let p = circumcenter {v0,v1,v2} in
   let q = make_point v0 v1 v2 v3 c c c in
   conv0 {v0,w,p,q}`;;

let abc_param = new_definition `abc_param v0 v1 v2 c = 
    let a = (&1/(&2)) * dist(v0,v1) in
    let b = radV {v0,v1,v2} in
     (a,b,c)`;;
