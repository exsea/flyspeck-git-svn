(* ================================ *)
(* ===== NGUYEN QUANG TRUONG ====== *)

needs "Multivariate/vectors.ml";; (* Eventually should load entire *) 	   
needs "Examples/analysis.ml";; (* multivariate-complex theory. *)	   
needs "Examples/transc.ml";; (* Then it won't need these three. *)
needs "convex_header.ml";; 
needs "definitions_kepler.ml";;


let voronoi_trg = new_definition ` voronoi_trg v S = { x | !w. ((S w) /\ ~(w=v))
==> (dist ( x , v ) < dist ( x , w )) }`;;


let conv0_2 = new_definition ` conv0_2 s = conv0 s `;;


let convex = new_definition `convex s <=> !x y u v. x IN s /\ y IN s /\ &0 <= u /\
     &0 <= v /\ (u + v = &1) ==> (u % x + v % y) IN s`;;

let aff = new_definition `aff = ( hull ) affine`;;	   
	   


let conv_trg = new_definition ` conv_trg s = convex hull s`;;

let border = new_definition ` border s = { x | ! ep. ep > &0 /\ ( ? a b. ~ (b IN s ) /\
 dist (b, x) < ep /\ a IN s /\ dist (a, x) < ep ) }`;;  

let packing_trg = new_definition `packing_trg (s:real^3 -> bool) = (! x y.  s x /\ s y /\ ( ~(x=y))
  ==> dist ( x, y) >= &2 ) `;;

let center_pac = new_definition ` center_pac s v = ( packing_trg s /\ s v )`;;

let centered_pac = new_definition ` centered_pac s v = ( packing s /\ v IN s )`;;

let d3 = new_definition ` d3 x y = dist (x,y)`;;

let voronoi2 = new_definition ` voronoi2 v S = {x| x IN voronoi_trg v S /\ d3 x v < &2 }`;;

let voro2 = new_definition ` voro2 v s = {x| x IN voronoi v s /\ d3 x v < &2 }`;;

let t0 = new_definition ` t0 = #1.255`;;


let quasi_tri = new_definition ` quasi_tri tri s = ( packing s /\ 
  tri SUBSET s /\
  (? a b c. ~( a=b \/ b=c\/ c=a) /\  { a, b, c } = tri ) /\
  (! x y.  ( x IN tri /\ y IN tri /\ (~(x=y)) ) ==> ( d3 x y <= &2 * t0 )))`;;


let simplex = new_definition ` simplex (d:real^3 -> bool) s = ( packing s /\
  d SUBSET s /\ 
( ? v1 v2 v3 v4. ~( v1 = v2 \/ v3 = v4 ) /\ {v1, v2 } INTER {v3, v4 } = {}/\ {v1,v2,v3,v4} = d )
 )`;;

let quasi_reg_tet = new_definition ` quasi_reg_tet x s = ( simplex x s /\
   (! v w. ( v IN x /\ w IN x /\ 
    ( ~ ( v = w))) 
  ==> ( d3 v w <= &2 * t0 )) )`;;

let quarter = new_definition ` quarter (q:real^3 -> bool) s =
  ( packing s /\
         simplex q s /\
         (?v w.
              v IN q /\
              w IN q /\
              &2 * t0 <= d3 v w /\
              d3 v w <= sqrt (&8) /\
              (!x y.
                   x IN q /\ y IN q /\ ~({x, y} = {v, w})
                   ==> d3 x y <= &2 * t0)))`;;

let diagonal = new_definition ` diagonal d1 d2 q s = ( quarter q s /\
         {d1, d2} SUBSET q /\
         (!x y. x IN q /\ y IN q ==> d3 x y <= d3 d1 d2))`;;

 let strict_qua = new_definition ` strict_qua d s = ( quarter d s /\ 
  ( ? x y. x IN d /\ y IN d /\ &2 * t0 < d3 x y /\ d3 x y < sqrt( &8 ) ))`;; 

let strict_qua2 = new_definition ` strict_qua2 d (ch:real^3 -> bool ) s = ( quarter d s /\ ch SUBSET d 
  /\ ( ? x y. ~( x = y ) /\ ch = {x,y} /\ &2 * t0 < d3 x y /\ d3 x y < sqrt ( &8 ) ) )`;;



let quartered_oct = new_definition `quartered_oct  (v:real^3)  (w:real^3) (v1:real^3)  (v2:real^3)  (v3:real^3)  (v4:real^3)  s =
         ( packing s /\
         ( &2 * t0 < dist (v,w) /\ dist (v,w) < sqrt (&8) ) /\
         (!x. x IN {v1, v2, v3, v4}
              ==> dist (x,v) <= &2 * t0 /\ dist (x,w) <= &2 * t0) /\
         {v, w, v1, v2, v3, v4} SUBSET s /\
         (&2 <= dist (v1,v2) /\ dist (v1,v2) <= &2 * t0) /\
         (&2 <= dist (v2,v3) /\ dist (v2,v3) <= &2 * t0) /\
         (&2 <= dist (v3,v4) /\ dist (v3,v4) <= &2 * t0) /\
         &2 <= dist (v4,v1) /\
         dist (v4,v1) <= &2 * t0 ) `;;


let adjacent_pai = new_definition ` adjacent_pai v v1 v3 v2 v4 s = ( strict_qua2 { v , v1 , v3 , v2 } { v1 , v3 } s
  /\ strict_qua2 { v , v1 , v3 , v4 } { v1 , v3 } s /\
  ( conv0 { v , v1 , v3 , v2 } INTER conv0 { v , v1 , v3 , v4 } = {} ) )`;;

let conflicting_dia = new_definition ` conflicting_dia v v1 v3 v2 v4 s = ( adjacent_pai v v1 v3 v2 v4 s
/\ adjacent_pai v v2 v4 v1 v3 s )`;;

 let interior_pos = new_definition `interior_pos v v1 v3 v2 v4 s = ( conflicting_dia v v1 v3 v2 v4 s 
  /\ ~( conv0 { v1, v3 } INTER conv0 { v , v2 , v4 } = {} ))`;;  

let isolated_qua = new_definition ` isolated_qua q s = ( quarter q s /\ ~( ? v v1 v2 v3 v4. q = 
  {v, v1, v2, v3} /\ adjacent_pai v v1 v2 v3 v4 s))`;;

let isolated_pai = new_definition ` isolated_pai q1 q2 s = ( isolated_qua q1 s /\ isolated_qua q2 s /\
  ~ (conv0 q1 INTER conv0 q2 = {}))`;;

let anchor = new_definition ` anchor (v:real^3) v1 v2 s = ( {v, v1, v2} SUBSET s /\ d3 v1 v2 <= sqrt ( &8 ) /\
  d3 v1 v2 >= &2 * t0 /\ d3 v v1 <= &2 * t0 /\ d3 v v2 <= &2 * t0 )`;;

let anchor_points = new_definition ` anchor_points v w s = { t | &2 * t0 <= d3 v w /\
  anchor t v w s }`;;

let Q_SYS = new_definition ` Q_SYS s = {q | quasi_reg_tet q s \/
              strict_qua q s /\
              (?c d.
                   !qq. c IN q /\
                        d IN q /\
                        d3 c d > &2 * t0 /\
                        (quasi_reg_tet qq s \/ strict_qua qq s) /\
                        conv0 {c, d} INTER conv0 qq = {}) \/
              strict_qua q s /\
              (CARD
               {t | ?v w.
                        v IN q /\ w IN q /\ &2 * t0 < d3 v w /\ anchor t v w s} >
               4 \/
               CARD
               {t | ?v w.
                        v IN q /\ w IN q /\ &2 * t0 < d3 v w /\ anchor t v w s} =
               4 /\
               ~(?v1 v2 v3 v4 v w. v IN q /\
                     w IN q /\
                     {v1, v2, v3, v4} SUBSET anchor_points v w s
                      /\
                     
                     &2 * t0 < d3 v w /\
                     quartered_oct v w v1 v2 v3 v4 s))
  \/ (? v w v1 v2 v3 v4. q = { v, w, v1, v2} /\ quartered_oct v w v1 v2 v3 v4 s )
  \/ (? v v1 v3 v2 v4. ( q = {v, v1, v2, v3} \/ q = {v, v1, v3, v4} ) /\
  interior_pos v v1 v3 v2 v4 s /\ anchor_points v1 v3 s = { v, v2, v4} /\
  anchor_points v2 v4 s = { v, v1, v3 } )}`;; 

let barrier = new_definition ` barrier s = { { (v1 : real^3 ) , ( v2 :real^3 ) , (v3 :real^3) } |
  quasi_tri { v1 , v2 , v3 } s \/ 
  (? v4. ( { v1 , v2 , v3 } UNION { v4 }) IN Q_SYS s ) } `;;

let obstructed = new_definition ` obstructed x y s = ( ? bar. bar IN barrier s /\
  ( ~ (conv0_2 { x , y } INTER conv_trg bar = {})))`;;

let obstruct = new_definition ` obstruct x y s = ( ? bar. bar IN barrier s /\
  ( ~ (conv0 { x , y } INTER conv bar = {})))`;;

let unobstructed = new_definition ` unobstructed x y s = ( ~( obstructed x y s ))`;;

let VC_trg = new_definition ` VC_trg x s = { z | d3 x z < &2 /\ ~obstructed x z s /\
  (! y. y IN s /\ ~ ( x = y ) /\ ~(obstructed z y s)   ==> d3 x z < d3 y z )} `;;  

let VC_INFI_trg = new_definition ` VC_INFI_trg s = { z | ( ! x. x IN s /\
  ~( z IN VC_trg x s ))}`;;


let lambda_x = new_definition `lambda_x x s = {w | w IN s /\ d3 w x < &2 /\
~obstructed w x s }`;;

let lambda_y = new_definition ` lambda_y y s = { w| w IN s /\ d3 w y < &2 /\
   ~obstruct w y s} `;;

let VC = new_definition `VC v s = { x | v IN lambda_x x s /\ 
(!w. w IN lambda_x x s /\ ~(w = v) ==> d3 x v < d3 x w) }`;;

let VC_INFI = new_definition ` VC_INFI s = { z | ( ! x. ~( z IN VC x s ))}`;;


let SET_TAC =
   let basicthms =
    [NOT_IN_EMPTY; IN_UNIV; IN_UNION; IN_INTER; IN_DIFF; IN_INSERT;
     IN_DELETE; IN_REST; IN_INTERS; IN_UNIONS; IN_IMAGE] in
   let allthms = basicthms @ map (REWRITE_RULE[IN]) basicthms @
                 [IN_ELIM_THM; IN] in
   let PRESET_TAC =
     TRY(POP_ASSUM_LIST(MP_TAC o end_itlist CONJ)) THEN
     REPEAT COND_CASES_TAC THEN
     REWRITE_TAC[EXTENSION; SUBSET; PSUBSET; DISJOINT; SING] THEN
     REWRITE_TAC allthms in
   fun ths ->
     PRESET_TAC THEN
     (if ths = [] then ALL_TAC else MP_TAC(end_itlist CONJ ths)) THEN
     MESON_TAC[];;

 let SET_RULE tm = prove(tm,SET_TAC[]);;

(* some TRUONG TACTICS *)

let PHA = REWRITE_TAC[ MESON[] ` (a/\b)/\c <=> a/\ b /\ c `];;

let NGOAC = REWRITE_TAC[ MESON[] ` a/\b/\c <=> (a/\b)/\c `];;

let DAO = NGOAC THEN REWRITE_TAC[ MESON[]` a /\ b <=> b /\ a`];;

let PHAT = REWRITE_TAC[ MESON[] ` (a\/b)\/c <=> a\/b\/c `];;

let NGOACT =  REWRITE_TAC[ GSYM (MESON[] ` (a\/b)\/c <=> a\/b\/c `)];;

let KHANANG = PHA THEN REWRITE_TAC[ MESON[]` ( a\/ b ) /\ c <=> a /\ c \/ b /\ c `] THEN 
 REWRITE_TAC[ MESON[]` a /\ ( b \/ c ) <=> a /\ b \/ a /\ c `];;

let ATTACH thm = MATCH_MP (MESON[]` ! a b. ( a ==> b ) ==> ( a <=> a /\ b )`) thm;;

let CUTHE1 th = MATCH_MP (MESON[]` ( ! a. P a ) ==> P a `) th ;;

let CUTHE2 th = MATCH_MP (MESON[]` ( ! a b. P a b ) ==> P a b`) th ;;

let CUTHE3 th = MATCH_MP (MESON[]` ( ! a b c. P a b c ) ==> P a b c`) th ;;

let CUTHE4 th = MATCH_MP (MESON[]` ( ! a b c d. P a b c d ) ==> P a b c d`) th ;;

let CUTHE5 th = MATCH_MP (MESON[]` ( ! a b c d e. P a b c d e) ==> P a b c d e`) th ;;

let CUTHE6 th = MATCH_MP (MESON[]` ( ! a b c d e f. P a b c d e f) ==> P a b c d e f`) th ;;

let CUTHE7 th = MATCH_MP (MESON[]` ( ! a b c d e f h. P a b c d e f h) ==> P a b c d e f h`) th ;;

let NHANH tm = ONCE_REWRITE_TAC[ ATTACH (tm)];;


let trg_sub_bo = prove ( `A SUBSET B <=> (!x. A x ==> B x)`, SET_TAC[] );;

let trg_sub_se = prove ( `A SUBSET B <=> (!x. x IN A  ==> x IN B )`, SET_TAC[] );;

let trg_setbool = prove (`x IN A <=> A x `, SET_TAC[] );;

let trg_boolset = prove (` A x <=>  x IN A `, SET_TAC[] );;

let trg_in_union = prove (` x IN ( A UNION B ) <=> x IN A \/ x IN B `, SET_TAC[]);;

let not_in_set3 = prove ( `~ ( x IN { z | A z /\ B z /\ C z } ) <=> ~ A x \/ ~ B x \/ ~ C x `,
  SET_TAC[]);;

let trg_d3_sym = prove ( `! x y. d3 x y = d3 y x `, SIMP_TAC[d3; DIST_SYM]);;

let affine_hull_e = prove (`affine hull {} = {}`, 
REWRITE_TAC[AFFINE_EMPTY; AFFINE_HULL_EQ]);;

let wlog = MESON[]` (! a b. ( P a b = P b a ) /\ ( Q a b \/ Q b a ) ) ==> ((? a b . P a b ) <=> ( ? a b. P a b 
  /\ Q a b ))`;;
let wlog_real = MESON[REAL_ARITH `( ! a b:real. a <= b \/ b <= a )`] ` 
(! a:real b:real . P a b = P b a ) ==> ((? a:real b . P a b ) <=> ( ? a b. P a b 
  /\ a <= b ))`;;
let dkdx = MESON[REAL_ARITH ` ! a b:real. a <= b \/ b <= a `]`! P. (!a b u v m n p . P a b u v m n p <=> P b a v u m n p)
     ==> ((?a b u v m n p. P a b u v m n p) <=> (?a b u v m n p. P a b u v m n p /\ a <= b))`;;


let tarski_arith = new_axiom `! bar. bar IN barrier s /\
                               ~(conv_trg bar INTER conv0_2 { v0 , x } ={}) /\ 
                               ~ ( v0 IN bar ) /\
                                 x IN voronoi2 v0 s /\ 
                              ~ ( x IN UNIONS {aff_ge {v0} {v1, v2} | {v0, v1, v2} IN barrier s} ) 
                            ==> { v0 } UNION bar IN Q_SYS s `;;

let simp_def = new_axiom ` (! a x y (z:real^A).
                              aff_ge {a} {x, y, z} = { t | ? s i j k. &0 <= i 
                              /\ &0 <= j /\ &0 <= k /\ s + i + j + k = &1 /\
                              t = s % a + i % x + j % y + k % z }) /\

          (!v0 v1 v2.
          aff_ge {v0} {v1, v2} =
          {t | ?u v w.
                   &0 <= v /\
                   &0 <= w /\
                   u + v + w = &1 /\
                   t = u % v0 + v % v1 + w % v2}) /\
     (!v0 v1 v2 v3.
          aff_gt {v0} {v1, v2, v3} =
          {t | ?x y z w.
                   &0 < y /\
                   &0 < z /\
                   &0 < w /\
                   x + y + z + w = &1 /\
                   t = x % v0 + y % v1 + z % v2 + w % v3}) /\
     (!v0 v1 v2 v3.
          aff_le {v1, v2, v3} {v0} =
          {t | ?a b c d.
                   d <= &0  /\
                   a + b + c + d = &1 /\
                   t = a % v1 + b % v2 + c % v3 + d % v0}) /\
     ( ! v0 v1. conv0_2 { v0, v1 } = { x | ? t. &0 < t /\ t < &1 /\ x = t % v0 + (&1 - t ) % v1 } ) /\
     (! s. conv_trg s = conv s )`;;


let AFFINE_HULL_SINGLE = prove(`!x. affine hull {x} = {x}`,
  SIMP_TAC[AFFINE_SING; AFFINE_HULL_EQ]);;

let usefull = MESON[] ` (!x. a x ==> b x ) ==>(?x. a x ) ==> c ==> d <=>
 (!x. a x ==> b x) ==> (?x. a x /\ b x ) ==> c ==> d `;;

let v1_in_convex3 = prove (` ! v1 v2 v3. v1 IN {t | ?a b c.
              &0 <= a /\ &0 <= b /\ &0 <= c /\ a + b + c = &1 /\
 t = a % v1 + b % v2 + c % v3}`, REPEAT GEN_TAC THEN REWRITE_TAC[ IN_ELIM_THM] THEN 
EXISTS_TAC ` &1 ` THEN EXISTS_TAC ` &0 ` THEN EXISTS_TAC ` &0 ` THEN 
REWRITE_TAC[ VECTOR_ARITH ` &1 % v1 + &0 % v2 + &0 % v3 = v1 `] THEN REAL_ARITH_TAC);;


let v3_in_convex3 = prove( `! v1 v2 v3. v3 IN
     {t | ?a b c.
              &0 <= a /\
              &0 <= b /\
              &0 <= c /\
              a + b + c = &1 /\
              t = a % v1 + b % v2 + c % v3}`, REWRITE_TAC[IN_ELIM_THM] THEN REPEAT GEN_TAC
THEN REPLICATE_TAC 2 (EXISTS_TAC `&0`) THEN EXISTS_TAC ` &1` THEN REWRITE_TAC[VECTOR_MUL_LZERO;
 VECTOR_ADD_LID; VECTOR_MUL_LID] THEN REAL_ARITH_TAC);;


let v1v2v3_in_convex3 = prove (` ! v1 v2 v3 . v1 IN {t | ?a b c. &0 <= a /\ &0 <= b /\ &0 <= c /\ 
a + b + c = &1 /\ t = a % v1 + b % v2 + c % v3}
   /\ v2 IN {t | ?a b c. &0 <= a /\ &0 <= b /\ &0 <= c /\ a + b + c = &1 /\ t = a % v1 + b % v2 + c % v3}
  /\ v3 IN {t | ?a b c. &0 <= a /\ &0 <= b /\ &0 <= c /\ a + b + c = &1 /\ t = a % v1 + b % v2 + c % v3}`,
REWRITE_TAC[v1_in_convex3; v3_in_convex3] THEN REPEAT GEN_TAC THEN REWRITE_TAC[IN_ELIM_THM] THEN 
EXISTS_TAC ` &0` THEN EXISTS_TAC ` &1` THEN EXISTS_TAC ` &0` THEN
REWRITE_TAC[VECTOR_ARITH` v2 = &0 % v1 + &1 % v2 + &0 % v3`] THEN REAL_ARITH_TAC);;


let convex3 = prove( `!v1 v2 v3.
     convex
     {t | ?a b c.
              &0 <= a /\
              &0 <= b /\
              &0 <= c /\
              a + b + c = &1 /\
              t = a % v1 + b % v2 + c % v3}`,
REWRITE_TAC[convex; IN_ELIM_THM] THEN 
REPEAT GEN_TAC THEN STRIP_TAC THEN 
EXISTS_TAC ` u * a + v * a'` THEN 
EXISTS_TAC ` u * b + v * b'` THEN 
EXISTS_TAC ` u * c + v * c'` THEN 
REPEAT (FIRST_X_ASSUM MP_TAC) THEN 
REWRITE_TAC[MESON[] ` a==> b==> c <=> a /\ b==> c`] THEN PHA THEN 
REWRITE_TAC[ MESON[]` &0 <= a /\ l <=> l /\ &0 <= a `] THEN PHA THEN 
NHANH (MESON[REAL_LE_MUL; REAL_ARITH ` &0 <= a /\ &0 <= b ==> &0 <= a +b `]` &0 <= v /\
 &0 <= u /\
 &0 <= c' /\
 &0 <= b' /\
 &0 <= a' /\
 &0 <= c /\
 &0 <= b /\
 &0 <= a ==> &0 <= u * c + v * c' /\
     &0 <= u * b + v * b' /\
     &0 <= u * a + v * a'`) THEN 
REWRITE_TAC[REAL_ARITH` ( a + y ) + ( b + x ) + c + z = ( a + b + c) + (
  y + x + z ) `] THEN 
REWRITE_TAC[REAL_ARITH ` a * b + a * c = a * ( b + c) `] THEN 
SIMP_TAC[] THEN 
REWRITE_TAC[ REAL_ARITH ` a * &1 = a `] THEN SIMP_TAC[] THEN 
REWRITE_TAC[VECTOR_ARITH` u % (a % v1 + b % v2 + c % v3) + v % (a' % v1 + b' % v2 + c' % v3) =
     (u * a + v * a') % v1 + (u * b + v * b') % v2 + (u * c + v * c') % v3`]);;

let INTERS_SUBSET = SET_RULE `! P t0. P t0 ==> INTERS { t| P t } SUBSET t0`;;

let SET3_SUBSET = SET_RULE`! a b c. {a,b,c} SUBSET s <=> a IN s /\ b IN s /\ c IN s `;;

let SUM_TWO_RATIO = REAL_FIELD ` ~(a + b = &0) <=> a / ( a + b) + b /(a+b) = &1`;; 

let minconvex3 = prove(`!t v1 v2 v3.
         convex t /\ {v1, v2, v3} SUBSET t
         ==> (!a b c.
                  &0 <= a /\ &0 <= b /\ &0 <= c /\ a + b + c = &1
                  ==> a % v1 + b % v2 + c % v3 IN t)`,
REPEAT GEN_TAC THEN 
REWRITE_TAC[convex; SET3_SUBSET] THEN 
STRIP_TAC THEN 
REPEAT GEN_TAC THEN 
ONCE_REWRITE_TAC[ MESON[]` &0 <= a /\ &0 <= b /\ l<=> ( a + b = &0 \/ 
  ~( a + b = &0)) /\ &0 <= a /\ &0 <= b /\ l`] THEN 
REWRITE_TAC[RIGHT_OR_DISTRIB] THEN 
REWRITE_TAC[ MESON[]` a \/ b ==> c <=> ( a ==> c ) /\ ( b ==> c )`] THEN 
REWRITE_TAC[REAL_ARITH` a + b = &0 /\ &0 <= a /\ &0 <= b /\ &0 <= c /\ a + b + c = &1
  <=> &0 = a /\ &0 = b /\ &1 = c `] THEN 
ONCE_REWRITE_TAC[ EQ_SYM_EQ] THEN 
SIMP_TAC[] THEN 
ASM_REWRITE_TAC[ VECTOR_MUL_LZERO; VECTOR_MUL_LID; VECTOR_ADD_LID] THEN 
REWRITE_TAC[MESON[]`&0 = a + b <=> a + b = &0`; SUM_TWO_RATIO] THEN 
NHANH (MESON[REAL_ARITH ` &0 <= a /\ &0 <= b ==> &0 <= a + b `]`
  dau /\ &0 <= a /\ &0 <= b /\ l ==> &0 <= a + b `) THEN 
NHANH (MESON[REAL_LE_DIV]` (aa /\ &0 <= a /\ &0 <= b /\ bb) /\ &0 <= a + b
     ==> &0 <= a / (a + b) /\ &0 <= b / (a + b)`) THEN 
REWRITE_TAC[GSYM SUM_TWO_RATIO] THEN 
PHA THEN 
NHANH (MESON[REAL_DIV_LMUL]` ~(a + b = &0) ==> a = (a+b) *(a/(a+b)) /\ b = 
  (a+b) *(b/(a+b))`) THEN 
REWRITE_TAC[MESON[VECTOR_MUL_RCANCEL]` ( dau /\ a = (a + b) * a / (a + b) /\ b = (a + b) * b / (a + b))
  /\ l ==> a % v1 + b % v2 + c % v3 IN t <=>
  ( dau /\ a = (a + b) * a / (a + b) /\ b = (a + b) * b / (a + b))
  /\ l ==> ((a + b) * a / (a + b)) % v1 + ((a + b) * b / (a + b)) % v2 + c % v3 IN t`] THEN 
REWRITE_TAC[ VECTOR_ARITH ` ((a + b) * a / (a + b)) % v1 + ((a + b) * b / (a + b)) % v2 + c % v3 
  = (a + b) % ( (a / (a + b)) % v1 + (b / (a + b)) % v2) + c % v3 `] THEN 
REWRITE_TAC[SUM_TWO_RATIO] THEN 
ASM_MESON_TAC[ REAL_ARITH` a + b + c = (a + b ) + c`]);;


let EQ_EXPAND = MESON[] `(a <=> b) <=> ( a ==> b ) /\ ( b ==> a )` ;;



let OTHER_CONVEX_CONDI = prove(` ! s. convex s <=> (! a b c v1 v2 v3. {v1, v2, v3} SUBSET s /\
    &0 <= a /\ &0 <= b /\ &0 <= c /\ a + b + c = &1
                  ==> a % v1 + b % v2 + c % v3 IN s)`,
REWRITE_TAC[EQ_EXPAND; MESON[minconvex3]`!s. (convex s
      ==> (!a b c v1 v2 v3.
               {v1, v2, v3} SUBSET s /\
               &0 <= a /\
               &0 <= b /\
               &0 <= c /\
               a + b + c = &1
               ==> a % v1 + b % v2 + c % v3 IN s))`; convex] THEN STRIP_TAC THEN 
REWRITE_TAC[SET3_SUBSET] THEN DISCH_TAC THEN 
REWRITE_TAC[REAL_ARITH`&0 <= u /\ &0 <= v /\ u + v = &1 <=>
  &0 <= u /\ &0 <= v / &2 /\ u + v/ &2 + v / &2 = &1`] THEN 
ONCE_REWRITE_TAC[MESON[REAL_ARITH` a = a / &2 + a / &2`]` u % x + v % y = 
   u % x + ( v/ &2 + v/ &2 ) % y `] THEN REWRITE_TAC[ VECTOR_ADD_RDISTRIB] THEN 
ASM_MESON_TAC[]);;


(* ============== *)


let convex3_in_inters = prove (` ! v1 v2 v3. {t | ?a b c.
          &0 <= a /\
          &0 <= b /\
          &0 <= c /\
          a + b + c = &1 /\
          t = a % v1 + b % v2 + c % v3} SUBSET
 INTERS {t | convex t /\ {v1, v2, v3} SUBSET t} `, 
REPEAT GEN_TAC THEN 
MATCH_MP_TAC (SET_RULE ` ( ! x. x IN A ==> x IN B ) ==> A SUBSET B`) THEN 
REWRITE_TAC[IN_ELIM_THM] THEN REWRITE_TAC[IN_INTERS] THEN 
REWRITE_TAC[MESON[] `( !x. (?a b c.
          &0 <= a /\
          &0 <= b /\
          &0 <= c /\
          a + b + c = &1 /\
          x = a % v1 + b % v2 + c % v3)
     ==> (!t. convex t /\ {v1, v2, v3} SUBSET t ==> x IN t))
  <=>( !x. (?a b c.
          &0 <= a /\
          &0 <= b /\
          &0 <= c /\
          a + b + c = &1 /\
          x = a % v1 + b % v2 + c % v3)
     ==> (!t. convex t /\ {v1, v2, v3} SUBSET t /\ (?a b c.
          &0 <= a /\
          &0 <= b /\
          &0 <= c /\
          a + b + c = &1 /\
          x = a % v1 + b % v2 + c % v3) ==> x IN t)) `] THEN 
GEN_TAC THEN DISCH_TAC THEN GEN_TAC THEN FIRST_X_ASSUM MP_TAC THEN 
REWRITE_TAC[ IN_ELIM_THM ; TAUT ` a ==> b ==> c <=> a /\ b ==> c `] THEN 
MESON_TAC[minconvex3]);;


(* =========== *)



let simpl_conv3 =prove(` ! v1 v2 v3. conv_trg {v1 , v2 ,v3} = {t | ?a b c. &0 <= a /\ &0 <= b /\ &0 <= c /\ a + b + c = &1 
/\ t = a % v1 + b % v2 + c % v3}`, REPEAT GEN_TAC THEN
REWRITE_TAC[conv; hull] THEN REPEAT GEN_TAC THEN 
REWRITE_TAC[ SET_RULE` a = b <=> a SUBSET b /\ b SUBSET a `] THEN
REWRITE_TAC[conv_trg; hull] THEN 
MATCH_MP_TAC (MATCH_MP ( MESON[] `(! a b. P a b) ==> P a b` ) (MESON[INTERS_SUBSET ]` 
  ! P t0 . ( P t0 /\ aa ) ==> INTERS {t | P t} SUBSET t0 /\ aa`)) THEN 
 REWRITE_TAC[convex3] THEN REWRITE_TAC[ SET_RULE `{v1 , v2, v3} SUBSET a <=>
  v1 IN a /\ v2 IN a /\ v3 IN a`] THEN REWRITE_TAC [ v1v2v3_in_convex3] THEN 
REWRITE_TAC[ SET_RULE` v1 IN t /\ v2 IN t /\ v3 IN t <=> {v1, v2, v3} SUBSET t`] THEN 
REWRITE_TAC[convex3_in_inters]);;






















(* =========== begining lemma 8.2 ========== *)

let near = new_definition ` near (v0:real^N) (r:real) s = { x | x IN s /\
  dist(x,v0) < r } `;;

let near2t0 = new_definition ` near2t0 v0 s = { x | x IN s /\ dist(v0,x) < &2 * t0 }`;;

let e_plane = new_definition ` e_plane (a:real^N) (b:real^N) x = ( ~( a=b) /\ dist(a,x) = dist(b,x))`;;

let min_dist = new_definition ` min_dist (x:real^3) s = ((?u. u IN s /\
                  (!w. w IN s /\ ~(u = w) ==> dist (u,x) < dist (w,x))) \/
             (?u v.
                  u IN s /\
                  v IN s /\
                  ~(u = v) /\
                  dist (u,x) = dist (v,x) /\
                  (!w. w IN s ==> dist (u,x) <= dist (w,x)))) `;;


let exists_min_dist = new_axiom ` ! (x :real^3) (s:real^3 -> bool).
  ~(s = {}) /\ packing s
         ==> min_dist x s`;;


let tarski_FFSXOWD = new_axiom ` !v0 v1 v2 v3 s.
         packing s /\
         ~(v1 = v2 \/ v2 = v3 \/ v3 = v1) /\
         dist (v1,v2) <= #2.51 /\
         dist (v2,v3) <= #2.51 /\
         dist (v3,v1) < sqrt (&8) /\
         {v1, v2, v3} SUBSET s /\
         ~(v0 IN {v1, v2, v3})
         ==> normball v0 #1.255 INTER conv {v1, v2, v3} = {} `;; 


(* ========== simplize.ml ============ *)

let SET3_SUBSET = SET_RULE`! a b c. {a,b,c} SUBSET s <=> a IN s /\ b IN s /\ c IN s `;;


let FINITE6 = MESON[ FINITE_RULES ] `! a b c d e f.
         FINITE {} /\
         FINITE {a} /\
         FINITE {a, b} /\
         FINITE {a, b, c} /\
         FINITE {a, b, c, d} /\
         FINITE {a, b, c, d, e} /\
         FINITE {a, b, c, d, e, f} `;; 

(* ========= new simplizing ========== *)

let elimin = REWRITE_RULE[IN];;

let CONV_EM = prove(`conv {} = {}:real^A->bool`,
  REWRITE_TAC[conv;sgn_ge;affsign;UNION_EMPTY;FUN_EQ_THM;elimin
NOT_IN_EMPTY;lin_combo;SUM_CLAUSES]
  THEN REAL_ARITH_TAC);;

let CONV_SING = prove(`!u. conv {u:real^A} = {u}`,
 REWRITE_TAC[conv;sgn_ge;affsign;FUN_EQ_THM;UNION_EMPTY;lin_combo;SUM_SING;VSUM_SING;
 elimin IN_SING] THEN REPEAT GEN_TAC THEN
 REWRITE_TAC[TAUT `(p <=> q) = ((p ==> q) /\ (q ==> p))`] THEN
 REPEAT STRIP_TAC THENL [ASM_MESON_TAC[VECTOR_MUL_LID];
 ASM_REWRITE_TAC[]] THEN EXISTS_TAC `\ (v:real^A). &1` THEN
 MESON_TAC[VECTOR_MUL_LID;REAL_ARITH `&0 <= &1`] );;


let NOV9 = prove(`!x y z.(x = y /\ y = z
      ==> conv {y, z} =
          {w | ?a b c.
                   &0 <= a /\
                   &0 <= b /\
                   &0 <= c /\
                   a + b + c = &1 /\
                   w = a % y + b % y + c % z})`,
SIMP_TAC[] THEN REWRITE_TAC[SET_RULE` {a,a} = {a}`] THEN 
REWRITE_TAC[ CONV_SING;  GSYM VECTOR_ADD_RDISTRIB] THEN 
REWRITE_TAC[ MESON[]` a + b + c = &1 /\ w = (a + b + c) % z <=>a + b + c = &1 /\
   w = &1 % z `; VECTOR_MUL_LID] THEN REWRITE_TAC[ FUN_EQ_THM] THEN 
REWRITE_TAC[ SET_RULE ` {a} x <=> a = x `; IN_ELIM_THM] THEN 
REPEAT GEN_TAC THEN DISCH_TAC THEN GEN_TAC THEN 
NGOAC THEN REWRITE_TAC[ LEFT_EXISTS_AND_THM] THEN 
MATCH_MP_TAC (MESON[] ` a ==> ( z = x <=> a /\ x = z )`) THEN 
REPLICATE_TAC 2 (EXISTS_TAC `&0`) THEN EXISTS_TAC ` &1` THEN REAL_ARITH_TAC);;


let IN_ACT_SING = SET_RULE `! a x. ({a} x <=> a = x ) /\ ( x IN {a} <=> x = a) /\ {a} a`;;


let NOV10 = prove(` ! x y. (x = y
      ==> (!x. y = x <=>
               (?a b. &0 <= a /\ &0 <= b /\ a + b = &1 /\ x = a % y + b % y))) `,
REWRITE_TAC[GSYM VECTOR_ADD_RDISTRIB] THEN 
REWRITE_TAC[ MESON[VECTOR_MUL_LID]` a + b = &1 /\ x = (a + b) % y <=> a + b = &1 /\ 
x = y`]THEN REPEAT GEN_TAC THEN DISCH_TAC THEN GEN_TAC THEN NGOAC THEN 
REWRITE_TAC[LEFT_EXISTS_AND_THM] THEN MATCH_MP_TAC (MESON[]` a ==> ( x = y <=> a /\
 y = x )`)THEN EXISTS_TAC `&0` THEN EXISTS_TAC ` &1` THEN REAL_ARITH_TAC);;





let IN_SET2 = SET_RULE `!a b x.
         (x IN {a, b} <=> x = a \/ x = b) /\ ({a, b} x <=> x = a \/ x = b)`;;


let VSUM_DIS2 = prove(` ! x y f. ~(x=y) ==>  vsum {x,y} f = f x + f y`, REWRITE_TAC[
   SET_RULE ` ~( x = y)
 <=> ~(x IN {y})`] THEN MESON_TAC[ FINITE_RULES; VSUM_CLAUSES; VSUM_SING]);;

let SUM_DIS2 = prove(`! x y f. ~(x=y) ==> sum {x,y} f = f x + f y `,REWRITE_TAC[
   SET_RULE ` ~( x = y)
 <=> ~(x IN {y})`] THEN MESON_TAC[ FINITE_RULES; SUM_CLAUSES; SUM_SING]);;
 

let TRUONG_LEMMA = prove
  (  `!x y x':real^N.
       (?f. x' = f x % x + f y % y /\ (&0 <= f x /\ &0 <= f y) /\
            f x + f y = &1) <=>
       (?a b. &0 <= a /\ &0 <= b /\ a + b = &1 /\ x' = a % x + b % y)`   ,
   REPEAT GEN_TAC THEN EQ_TAC 
THENL [MESON_TAC[]; STRIP_TAC] THEN
   ASM_CASES_TAC `y:real^N = x` THENL
    [EXISTS_TAC `\x:real^N. &1 / &2`;
     EXISTS_TAC `\u:real^N. if u = x then (a:real) else b`] THEN
   ASM_REWRITE_TAC[GSYM VECTOR_ADD_RDISTRIB] THEN
   CONV_TAC REAL_RAT_REDUCE_CONV);;


let NOV11 = prove(`! z. {z} =
 {w | ?a b c.
          &0 <= a /\
          &0 <= b /\
          &0 <= c /\
          a + b + c = &1 /\
          w = a % z + b % z + c % z}`,
REWRITE_TAC[ FUN_EQ_THM; IN_ACT_SING; IN_ELIM_THM] THEN 
REWRITE_TAC[GSYM VECTOR_ADD_RDISTRIB] THEN 
REWRITE_TAC[ MESON[VECTOR_MUL_LID]`a + b + c = &1 /\
          x = (a + b + c) % z <=> a + b + c = &1 /\ x = z`] THEN 
NGOAC THEN MATCH_MP_TAC (MESON[]` (? a b c. P a b c) ==> (! z x. z = x <=>
  (? a b c. P a b c /\ x = z))`) THEN 
REPLICATE_TAC 2 (EXISTS_TAC `&0`) THEN 
EXISTS_TAC `&1` THEN REAL_ARITH_TAC);;



let CONV2_CONV3 = prove(` !x' y z.
         (?a b. &0 <= a /\ &0 <= b /\ a + b = &1 /\ x' = a % y + b % z)
         ==> (?a b c.
                  &0 <= a /\
                  &0 <= b /\
                  &0 <= c /\
                  a + b + c = &1 /\
                  x' = a % y + b % y + c % z)`,
REPEAT GEN_TAC THEN REWRITE_TAC[ VECTOR_ARITH` a % y + b % y + c % z = (a+b) %y + c%z`] THEN STRIP_TAC THEN 
REPLICATE_TAC 2 (EXISTS_TAC `a/ &2`) THEN 
EXISTS_TAC `b:real` THEN 
REWRITE_TAC[ REAL_ARITH` a / &2 + a / &2 = a /\ a / &2 + a / &2 + b = a + b `] THEN 
ASM_SIMP_TAC[] THEN 
ASM_REAL_ARITH_TAC);;


let CONV3_CONV2 = prove(`! x' y z. (?a b c.
      &0 <= a /\
      &0 <= b /\
      &0 <= c /\
      a + b + c = &1 /\
      x' = a % y + b % y + c % z)
 ==> (?a b. &0 <= a /\ &0 <= b /\ a + b = &1 /\ x' = a % y + b % z)`,
REPEAT GEN_TAC THEN STRIP_TAC THEN EXISTS_TAC ` a + b:real` THEN 
EXISTS_TAC `c:real` THEN 
REWRITE_TAC[VECTOR_ADD_RDISTRIB] THEN 
REWRITE_TAC[VECTOR_ARITH` (a % y + b % y) + c % z = a % y + b % y + c % z `] THEN 
ASM_SIMP_TAC[REAL_ARITH ` a + b + c = (a + b) + c`] THEN 
ASM_REAL_ARITH_TAC);;


let CONV_SET2 = prove(` ! x y:real^A. conv {x,y} = {w | ? a b. &0 <= a /\ &0 <= b /\ a + b = &1 /\
  w = a%x + b%y}`,
ONCE_REWRITE_TAC[ MESON[] ` (! a b. P a b ) <=> ( ! a b. a = b \/ ~( a= b)
  ==> P a b )`] THEN 
REWRITE_TAC[ MESON[]` a \/ b ==> c <=> ( a==> c) /\ ( b==> c)`] THEN 
SIMP_TAC[] THEN 
REWRITE_TAC[ SET_RULE ` {a,a} = {a}`; CONV_SING; FUN_EQ_THM; IN_ELIM_THM] THEN 
REWRITE_TAC[ IN_ACT_SING] THEN 
REWRITE_TAC[NOV10] THEN 
REWRITE_TAC[conv; sgn_ge; affsign; lin_combo] THEN 
REWRITE_TAC[UNION_EMPTY; IN_SET2] THEN 
ONCE_REWRITE_TAC[ MESON[]`  ~(x = y) ==> (!x'. (?f. P f x') <=> l x') <=>
  ~(x = y) ==> (!x'. (?f. ~(x=y) /\ P f x') <=> l x')`] THEN 
REWRITE_TAC[ MESON[VSUM_DIS2; SUM_DIS2]` ~(x = y) /\
                    x' = vsum {x, y} ff /\ l /\ sum {x, y} f = &1 <=> ~(x = y) /\
                    x' = ff x + ff y /\ l /\ f x + f y = &1 `] THEN 
REWRITE_TAC[ MESON[]` (!w. w = x \/ w = y ==> &0 <= f w) <=> &0 <= f x /\ &0 <= f y`] THEN 
ONCE_REWRITE_TAC[ GSYM (MESON[]`  ~(x = y) ==> (!x'. (?f. P f x') <=> l x') <=>
  ~(x = y) ==> (!x'. (?f. ~(x=y) /\ P f x') <=> l x')`)] THEN 
REPEAT GEN_TAC THEN DISCH_TAC THEN GEN_TAC THEN 
REWRITE_TAC[ TRUONG_LEMMA]);;


let CONV3_A_EQ = prove(`! x y z. (x = y \/ y = z \/ z = x
  ==> conv {x, y, z} =
      {w | ?a b c.
               &0 <= a /\
               &0 <= b /\
               &0 <= c /\
               a + b + c = &1 /\
               w = a % x + b % y + c % z})`,
MATCH_MP_TAC (MESON[] `(! a b c. P a b c <=> P b a c) /\ (! a b c. a = b \/ b = c ==> P a b c)
  ==> (! a b c. a = b \/ b = c \/ c = a ==> P a b c )`) THEN 
SIMP_TAC[ MESON[ SET_RULE ` {a,b,c} = {b,a,c} `]`conv {x, y, z} = conv {y,x,z}`] THEN  
SIMP_TAC[ MESON[ REAL_ARITH` a + b + c = b + a + c`; VECTOR_ARITH` a % x + b % y + c % z
  = b % y + a % x + c % z `]` (?a b c.
               &0 <= a /\
               &0 <= b /\
               &0 <= c /\
               a + b + c = &1 /\
               w = a % x + b % y + c % z)
  <=> (?a b c.
               &0 <= a /\
               &0 <= b /\
               &0 <= c /\
               a + b + c = &1 /\
               w = a % y + b % x + c % z)`] THEN 
MATCH_MP_TAC (MESON[]` (! a b c. P a b c <=> P c b a ) /\ (! a b c. a = b ==> P a b c) 
  ==> (! a b c. a = b \/ b = c ==> P a b c)`) THEN 
SIMP_TAC[ MESON[SET_RULE `{a,b,c} ={c,b,a} `]` conv {a,b,c} = conv {c,b,a}`] THEN 
SIMP_TAC[ MESON[REAL_ARITH` a + b + c = c + b + a`; VECTOR_ARITH` a % x + b % y + c % z
  = c % z + b % y + a % x `]`(?a b c.
               &0 <= a /\
               &0 <= b /\
               &0 <= c /\
               a + b + c = &1 /\
               w = a % x + b % y + c % z) <=> 
  (?a b c.
               &0 <= a /\
               &0 <= b /\
               &0 <= c /\
               a + b + c = &1 /\
               w = a % z + b % y + c % x)`] THEN 
REWRITE_TAC[ SET_RULE`{a,a,b} = {a,b}`] THEN 
ONCE_REWRITE_TAC[ MESON[]` x = y ==> conv {y,z} = s <=> x = y /\( y = z \/
  ~(y=z))==> conv {y,z} = s `] THEN 
KHANANG THEN REWRITE_TAC[ MESON[]` a \/ b ==> c <=> (a==> c) /\ (b==> c)`] THEN 
SIMP_TAC[] THEN REWRITE_TAC[SET_RULE`{a,a} ={a}`; CONV_SING] THEN 
SIMP_TAC[NOV11] THEN REWRITE_TAC [ GSYM NOV11] THEN 
REWRITE_TAC[CONV_SET2] THEN 
REPEAT GEN_TAC THEN STRIP_TAC THEN 
 REWRITE_TAC[ FUN_EQ_THM; IN_ELIM_THM] THEN 
GEN_TAC THEN REWRITE_TAC[MESON[]` (a <=> b ) <=> ( a ==> b) /\ (b==> a)`] THEN 
REWRITE_TAC[CONV2_CONV3; CONV3_CONV2]);;


let VSUM_DIS3 = prove( `! x y z f. ~(x=y\/y=z\/z=x) ==> vsum {x,y,z} f = f x + f y + f z `,
NHANH (SET_RULE` ~(x = y \/ y = z \/ z = x) ==> ({x} INTER {y,z} = {}) `) THEN 
REWRITE_TAC[ GSYM DISJOINT; SET_RULE `{x, y, z} = {x} UNION {y,z}` ] THEN 
REWRITE_TAC[MESON[FINITE6; VSUM_UNION]` aa /\ DISJOINT {x} {y, z}
     ==> vsum ({x} UNION {y, z}) f = ab <=>  aa /\ DISJOINT {x} {y, z} ==>
  vsum {x} f + vsum {y,z} f = ab `] THEN 
 MESON_TAC[VSUM_SING; VSUM_DIS2]);;


let SUM_DIS3 = prove(` ! x y z f. ~(x = y \/ y = z \/ z = x) ==> sum {x, y, z} f = 
  f x + f y + f z `,
NHANH (SET_RULE` ~(x = y \/ y = z \/ z = x) ==> ({x} INTER {y,z} = {}) `) THEN 
REWRITE_TAC[ GSYM DISJOINT; SET_RULE `{x, y, z} = {x} UNION {y,z}` ] THEN 
REWRITE_TAC[MESON[FINITE6; SUM_UNION]` aa /\ DISJOINT {x} {y, z}
     ==> sum ({x} UNION {y, z}) f = ab <=>  aa /\ DISJOINT {x} {y, z} ==>
  sum {x} f + sum {y,z} f = ab `] THEN MESON_TAC[ SUM_SING; SUM_DIS2]);;



let EQ_EXPAND = MESON[] `(a <=> b) <=> ( a ==> b ) /\ ( b ==> a )` ;;



let CONV_SET3 = prove(`! x y z:real^A. conv {x,y,z} = { w | ? a b c. &0 <= a /\ &0 <= b /\ &0 <= c /\
a + b + c = &1 /\ w = a % x + b % y + c % z } `,
REPEAT GEN_TAC THEN 
ONCE_REWRITE_TAC[ MESON[]` conv {x,y,z} = s <=> (x = y \/ y= z \/ z = x ) \/
  ~(x = y \/ y= z \/ z = x ) ==> conv {x,y,z} = s`] THEN 
ONCE_REWRITE_TAC[ MESON[]` a \/ b ==> c <=> ( a ==> c ) /\(b==>c)`] THEN 
REWRITE_TAC[CONV3_A_EQ] THEN 	
REWRITE_TAC[conv; FUN_EQ_THM; affsign; IN_ELIM_THM; sgn_ge; lin_combo; UNION_EMPTY] THEN 
DISCH_TAC THEN GEN_TAC THEN FIRST_X_ASSUM MP_TAC THEN 
ONCE_REWRITE_TAC[ MESON[]` a ==> ((?f. P f ) <=> la ) <=> 
  a ==> ((?f. a /\ P f ) <=> la ) `] THEN REWRITE_TAC[MESON[VSUM_DIS3]` ~(x = y \/ 
y = z \/ z = x) /\ x' = vsum {x, y, z} f /\ l <=>   ~(x = y \/ y = z \/ z = x) /\
x' = f x + f y + f z /\ l `] THEN 
REWRITE_TAC[ MESON[SUM_DIS3]` ~(x = y \/ y = z \/ z = x) /\ P /\ Q /\ sum {x,y,z} f = &1 
  <=> ~(x = y \/ y = z \/ z = x) /\ P /\ Q /\ ( f x + f y + f z ) = &1`] THEN 
REWRITE_TAC[SET_RULE ` (!w. {x, y, z} w ==> &0 <= f w) <=> &0 <= f x /\ 
   &0 <= f y /\ &0 <= f z `] THEN 
ONCE_REWRITE_TAC[ GSYM (MESON[]` a ==> ((?f. P f ) <=> la ) <=> 
  a ==> ((?f. a /\ P f ) <=> la ) `)] THEN DISCH_TAC THEN 
REWRITE_TAC[ EQ_EXPAND] THEN 
REWRITE_TAC[ MESON[]` (?f. x' = f x % x + f y % y + f z % z /\
       (&0 <= f x /\ &0 <= f y /\ &0 <= f z) /\
       f x + f y + f z = &1)
  ==> (?a b c.
           &0 <= a /\
           &0 <= b /\
           &0 <= c /\
           a + b + c = &1 /\
           x' = a % x + b % y + c % z)`] THEN STRIP_TAC THEN 
EXISTS_TAC ` (\d. if d = (x:real^A) then (a:real) else ( if d = (y:real^A) then 
  (b:real)  else c ))` THEN REPEAT (FIRST_X_ASSUM MP_TAC) THEN 
REWRITE_TAC[ MESON[]`~( a \/ b ) <=> ~a /\ ~b `] THEN SIMP_TAC[]);;

(* ========== *)
let CONV3_EQ = prove(` ! x y z. conv_trg {x,y,z} = conv {x,y,z} `, REWRITE_TAC[simpl_conv3;
CONV_SET3]);;
(* ========= *)

let CONV_BAR_EQ = prove(`! bar s. bar IN barrier s ==> conv bar = conv_trg bar `,
REWRITE_TAC[barrier; IN_ELIM_THM] THEN MESON_TAC[CONV_SET3; simpl_conv3]);;

let OBSTRUCT_EQ = prove(`!x y s. obstruct x y s <=> obstructed x y s`,
REWRITE_TAC[obstruct; obstructed] THEN REWRITE_TAC[obstruct; obstructed; conv0_2] THEN 
MESON_TAC[CONV_BAR_EQ]);;

(* === repare VC === *)

(* ==== CARD ASSERTION ==== *)


let CARD_CLAUSES_IMP = prove(` !a s.
     FINITE s
     ==> CARD (a INSERT s) <= SUC (CARD s) /\
         (a IN s ==> CARD (a INSERT s) = CARD s) /\
         (~(a IN s) ==> CARD (a INSERT s) = SUC (CARD s))`,
ONCE_REWRITE_TAC[ MESON[] ` ( a ==> b /\ c ) <=> ( a ==> b ) /\ ( a ==> c )`] THEN 
REWRITE_TAC[ MESON[CARD_CLAUSES] ` FINITE s ==> ( a IN s ==> CARD (a INSERT s) = CARD s ) /\
  (~(a IN s) ==> CARD (a INSERT s) = SUC (CARD s))`] THEN 
MESON_TAC[ CARD_CLAUSES; ARITH_RULE ` a <= SUC a /\ a <= a `]);;

(* =================== *)

let CARD_SING = prove( `! a: A. CARD {a} = 1`, REWRITE_TAC[ MESON[ FINITE6; CARD_EQ_NSUM ] 
` CARD {a} = nsum {a} (\x. 1)`] THEN REWRITE_TAC[ NSUM_SING ]);;

let CARD_SET2 = prove( ` ! a b . ( CARD {a, b} = 2 <=> ~(a = b)) /\ (CARD {a, b} = 1 <=> a = b ) `,
REWRITE_TAC[ MESON[ FINITE6; CARD_CLAUSES ] ` CARD {a,b} = (if a IN {b} then CARD {b} else SUC (CARD {b}))`]
THEN REWRITE_TAC[ MESON[ FINITE6; CARD_CLAUSES ] ` CARD {a} = (if a IN {} then CARD {} else SUC (CARD {}))`]
THEN REWRITE_TAC[ NOT_IN_EMPTY; IN_SING; CARD_CLAUSES; ADD1] THEN 
MESON_TAC[ ARITH_RULE `  ~( 0+ 1 = 2 ) /\ (0 + 1) + 1 = 2 /\ ~((0 + 1) + 1 = 1 ) /\ 0 + 1 = 1  `]);;

(* ============== *)

let CARD_EQUATION = prove(`!(s: A -> bool) t.
     FINITE s /\ FINITE t
     ==> CARD (s UNION t) + CARD (s INTER t) = CARD s + CARD t `, 
NHANH (MESON[FINITE_INTER; FINITE_UNION] `FINITE s /\ FINITE t ==> FINITE ( s UNION t ) /\
    FINITE ( s INTER t ) `) THEN MESON_TAC[ CARD_EQ_NSUM; NSUM_INCL_EXCL]);;


let CARD_DISJOINT = prove(` ! s: A -> bool t. FINITE s /\ FINITE t ==> 
       ( CARD s + CARD t = CARD ( s UNION t ) <=> s INTER t ={} )`,
MESON_TAC[CARD_EQUATION; ARITH_RULE ` a + b = a <=> b = 0 `; FINITE_INTER; CARD_EQ_0]);;


let CARD2 = prove(` ! a b . CARD {a,b} <= 2 /\ ( CARD {a,b} = 2 <=> ~(a = b ) )`,
REWRITE_TAC[ MESON[ CARD_SET2] ` CARD {a, b} = 2 <=> ~(a = b)`] THEN MP_TAC CARD_SET2 THEN 
ONCE_REWRITE_TAC[ MESON[] ` CARD {a, b} <= 2 <=>
  ( a = b \/ ~( a = b)) /\ CARD {a, b} <= 2`] THEN KHANANG THEN 
REWRITE_TAC[ MESON[CARD_SET2] `a = b /\ CARD {a, b} <= 2 \/ ~(a = b) /\ CARD {a, b} <= 2 
  <=> a = b /\ 1 <= 2 \/ ~(a = b) /\ 2 <= 2`] THEN 
MESON_TAC[ARITH_RULE ` 1 <= 2 /\ 2 <= 2 `]);;


let CARD3 = prove(`! a b c . CARD {a,b,c} <= 3 /\ 
  ( CARD {a,b,c} = 3 <=> ~( a =b \/ b= c\/ c= a ))`, 
REWRITE_TAC[ SET_RULE ` {a,b,c} = {a} UNION {b,c}`] THEN 
REWRITE_TAC[ ARITH_RULE ` CARD ({a} UNION {b, c}) <= 3 <=>
  CARD ({a} UNION {b, c}) + CARD ({a} INTER {b, c}) <= 3 + CARD ({a} INTER {b, c})`] THEN 
REWRITE_TAC[ ARITH_RULE ` CARD ({a} UNION {b, c}) = 3 <=>
  CARD ({a} UNION {b, c}) + CARD ({a} INTER {b, c}) = 3 + CARD ({a} INTER {b, c})`] THEN 
REWRITE_TAC[ MESON[ FINITE_RULES; CARD_EQUATION] ` CARD ({a} UNION {b, c}) + CARD ({a} INTER {b, c})
  = CARD {a} + CARD {b,c} `] THEN REWRITE_TAC[ CARD_SING] THEN 
REWRITE_TAC[ ARITH_RULE `! a b. (1 + a <= 3 + b <=> a <= 2 + b ) /\
  (1 + a = 3 + b <=> a = 2 + b )`] THEN 
REWRITE_TAC[ MESON[CARD2; ARITH_RULE ` a <= b ==> a <= b + c: num`] ` CARD {b, c} <=   2 + CARD ({a} INTER {b, c})`] THEN 
ONCE_REWRITE_TAC[ MESON[CARD2]` CARD {b, c} = P b c <=> CARD {b, c} <= 2 /\   CARD {b, c} = P b c`] THEN 
REWRITE_TAC[ ARITH_RULE ` a <= 2 /\ a = 2 + b <=> a = 2 /\ b = 0`] THEN 
REWRITE_TAC[ MESON[FINITE_RULES; CARD2; FINITE_INTER; CARD_EQ_0] ` CARD {b, c} = 2 /\ CARD ({a} INTER {b, c}) = 0 
  <=> ~(b=c) /\ {a} INTER {b, c} = {}`] THEN SET_TAC[]);;

(* ========= *)


let CARD4 = prove(`!a b c d.
     CARD {a, b, c, d} <= 4 /\
     (CARD {a, b, c, d} = 4 <=>
      ~(a IN {b, c, d}) /\ ~(b = c \/ c = d \/ d = b))`,
NHANH (MESON[FINITE6; CARD_CLAUSES_IMP]` CARD {a, b, c, d} <= 4 ==> CARD {a, b, c, d} 
   <= SUC (CARD {b,c,d})`) THEN 
NHANH ( MESON[CARD3] ` aa <= SUC (CARD {b, c, d}) ==> CARD {b,c,d} <= 3 `) THEN 
REWRITE_TAC[ ARITH_RULE ` CARD {a, b, c, d} <= 4 /\
     CARD {a, b, c, d} <= SUC (CARD {b, c, d}) /\
     CARD {b, c, d} <= 3 <=>
     CARD {a, b, c, d} <= SUC (CARD {b, c, d}) /\ CARD {b, c, d} <= 3`] THEN 
SIMP_TAC[MESON[FINITE_RULES; CARD_CLAUSES_IMP] ` CARD {a, b, c, d} <= SUC 
        (CARD {b, c, d})`; CARD3; CARD_CLAUSES_IMP] THEN 
REWRITE_TAC[ ARITH_RULE ` CARD {a, b, c, d} = 4 <=> CARD {a, b, c, d} + CARD ( {a} 
   INTER {b,c,d} ) = 4 + CARD ({a} INTER {b,c,d})`] THEN 
REWRITE_TAC[ SET_RULE ` {a,b,c,d} = {a} UNION {b,c,d} ` ] THEN 
REWRITE_TAC[ MESON[FINITE_RULES; CARD_EQUATION; CARD_SING] ` CARD ({a} UNION {b, c, d}) + CARD ({a} INTER {b, c, d})
  = 1 + CARD {b,c,d} `] THEN 
NHANH (MESON[CARD3] ` 1 + CARD {b, c, d} = aa ==> CARD {b,c,d} <= 3 `) THEN 
REWRITE_TAC[ ARITH_RULE `1 + CARD {b, c, d} = 4 + CARD ({a} INTER {b, c, d}) /\
     CARD {b, c, d} <= 3 <=>
     CARD {b, c, d} = 3 /\ CARD ({a} INTER {b, c, d}) = 0`] THEN  
REWRITE_TAC[ CARD3] THEN 
MESON_TAC[ FINITE_RULES; FINITE_INTER; CARD_EQ_0; SET_RULE ` 
  {a} INTER {b, c, d} = {} <=> ~(a IN {b, c, d})` ]);;


let CARD5 = prove(` ! a b c d e. CARD {a,b,c,d,e} <= 5 /\
  ( CARD {a,b,c,d,e} = 5 <=> ~( a IN {b,c,d,e}) /\ 
                            ~(b IN {c, d, e}) /\ ~(c = d \/ d = e \/ e = c))`,
ONCE_REWRITE_TAC[ MESON[ FINITE_RULES; CARD_CLAUSES_IMP] ` CARD {a, b, c, d, e} <= 5 <=>
  CARD {a, b, c, d, e} <= SUC ( CARD {b,c,d,e} ) ==> CARD {a, b, c, d, e} <= 5`] THEN 
ONCE_REWRITE_TAC[ MESON[CARD4] ` aa ==> CARD {a, b, c, d, e} <= 5 <=>
  aa /\ CARD {b,c,d,e} <= 4 ==> CARD {a, b, c, d, e} <= 5`] THEN 
REWRITE_TAC[ ARITH_RULE ` a <= SUC b /\ b <= 4 ==> a <= 5 `] THEN 
REWRITE_TAC[ ARITH_RULE ` CARD {a, b, c, d, e} = 5 <=>
  CARD {a, b, c, d, e} + CARD ({a} INTER {b,c,d,e} ) = 5 + CARD ({a} INTER {b,c,d,e} )`] THEN 
REWRITE_TAC[ SET_RULE ` {a,b,c,d,e} = {a} UNION {b,c,d,e} `] THEN 
REWRITE_TAC[ MESON[FINITE_RULES; CARD_EQUATION; CARD_SING ]` CARD ({a} UNION {b, c, d, e}) + 
  CARD ({a} INTER {b, c, d, e})  = 1 + CARD {b,c,d,e} `] THEN 
ONCE_REWRITE_TAC[ MESON[ CARD4] ` 1 + CARD {b, c, d, e} = aa <=> CARD {b,c,d,e} <= 4 /\ 
     1 + CARD {b, c, d, e} = aa `] THEN 
REWRITE_TAC[ ARITH_RULE ` a <= 4 /\ 1 + a = 5 + b <=> a = 4 /\ b = 0`] THEN 
REWRITE_TAC[ CARD4; MESON[FINITE_RULES; FINITE_INTER; CARD_EQ_0] `
  CARD ({a} INTER {b, c, d, e}) = 0 <=> {a} INTER {b, c, d, e} ={} `] THEN SET_TAC[]);;
(* ============ *)

let set_3elements = prove(`(?a b c. ~(a = b \/ b = c \/ c = a) /\ {a, b, c} = {v1, v2, v3}) <=>
 ~(v1 = v2 \/ v2 = v3 \/ v3 = v1)`, REWRITE_TAC[GSYM CARD3] THEN 
MESON_TAC[]);;


let db_t0 = prove(`&2 * t0 = &2 * #1.255 /\ &2 * t0 = #2.51 /\ &2 * #1.255 = #2.51`,
  REWRITE_TAC[t0] THEN REAL_ARITH_TAC);;


let without_lost = MESON[] ` ! P x. (!a b. P a b <=> P b a) /\ (?a b. P a b /\ x = a)
     ==> (?a b. P a b /\ (x = a \/ x = b))`;;

let condi_of_wlofg = MESON[]` (!a b. P a b <=> P b a)
     ==> ((?a b. P a b /\ (x = a \/ x = b)) <=> (?a b. P a b /\ x = a))`;;


(* ============ *)
 let CARD_SET_OF_LIST_LE = prove
  (`!l. CARD(set_of_list l) <= LENGTH l`,
   LIST_INDUCT_TAC THEN
   SIMP_TAC[LENGTH; set_of_list; CARD_CLAUSES; FINITE_SET_OF_LIST] THEN
   ASM_ARITH_TAC);;

 let HAS_SIZE_SET_OF_LIST = prove
  (`!l. (set_of_list l) HAS_SIZE (LENGTH l) <=> PAIRWISE (\x y. ~(x = y)) l`,
   REWRITE_TAC[HAS_SIZE; FINITE_SET_OF_LIST] THEN LIST_INDUCT_TAC THEN
   ASM_SIMP_TAC[CARD_CLAUSES; LENGTH; set_of_list; PAIRWISE; ALL;
                FINITE_SET_OF_LIST; GSYM ALL_MEM; IN_SET_OF_LIST] THEN
   COND_CASES_TAC THEN ASM_REWRITE_TAC[SUC_INJ] THEN
   ASM_MESON_TAC[CARD_SET_OF_LIST_LE; ARITH_RULE `~(SUC n <= n)`]);;

(* ====================In your theorem we want the n=4 case, so we instantiate it:
=========================== *)

 let HAS_SIZE_SET_OF_LIST_4 = prove
  (`!a b c d:A. {a,b,c,d} HAS_SIZE 4 <=> PAIRWISE (\x y. ~(x = y)) [a;b;c;d]`,
   REPEAT GEN_TAC THEN MP_TAC(ISPEC `[a;b;c;d]:A list`HAS_SIZE_SET_OF_LIST) THEN
   REWRITE_TAC[LENGTH; set_of_list; ARITH])  ;;

(* ============================================================================
 Then finally, using this and a bit of straightforward rearrangement,
we can collapse the desired theorem to a lemma that MESON can prove
automatically: 
===============================================================================*)

 let SET_OF_4 = prove
  (`! a b c d. ( ? v1 v2 v3 v4:A. ~( v1 = v2 \/ v3 = v4 ) /\
                                {v1, v2 } INTER {v3, v4 } = {} /\
                                { a , b , c , d } = { v1 , v2, v3 ,v4}) <=>
    ~ ( a = b \/ a = c \/ a = d \/ b = c \/ b = d \/ c = d )`,
   REPEAT GEN_TAC THEN
   REWRITE_TAC[IN_INSERT; NOT_IN_EMPTY; INTER_EMPTY; SET_RULE
    `(a INSERT s) INTER t = {} <=> ~(a IN t) /\ s INTER t = {}`] THEN
   MP_TAC(MESON[]
    `(?v1 v2 v3 v4:A. {a,b,c,d} = {v1,v2,v3,v4} /\ {v1,v2,v3,v4} HAS_SIZE 4) <=>
     {a,b,c,d} HAS_SIZE 4`) THEN
   REWRITE_TAC[HAS_SIZE_SET_OF_LIST_4; PAIRWISE; ALL; DE_MORGAN_THM; CONJ_ACI]);;


let def_simplex = prove(`! s a b c d. simplex {a, b, c, d} s <=>
  packing s /\
         {a, b, c, d} SUBSET s /\
  ~ ( a = b \/ a = c \/ a = d \/ b = c \/ b = d \/ c = d ) `, REWRITE_TAC[ simplex]
THEN REPEAT GEN_TAC THEN MATCH_MP_TAC (MESON[] ` ( x <=> y ) ==> ( a /\ b /\ x <=> 
a /\ b /\ y ) `) THEN ONCE_REWRITE_TAC[MESON[]` {v1, v2, v3, v4} = {a, b, c, d} <=>
 {a, b, c, d}  = {v1, v2, v3, v4} ` ] THEN REWRITE_TAC[ SET_OF_4]);;


let strict_qua2_imply_strict_qua = prove(`! q d s. strict_qua2 q d s ==> strict_qua q s `,
REWRITE_TAC[ strict_qua2; strict_qua] THEN NHANH (SET_RULE` d = {x, y} ==> x IN d /\
 y IN d `) THEN MESON_TAC[ SET_RULE ` x IN d /\ d SUBSET s ==> x IN s `]);;

(* ========== have added to database more =====================*)


let strict_qua2_interior_pos = prove( `!s v v1 v2 v3 v4.
     interior_pos v v1 v3 v2 v4 s
     ==> strict_qua2 {v, v1, v3, v2} {v1, v3} s /\
         strict_qua2 {v, v1, v3, v4} {v1, v3} s /\
         strict_qua2 {v, v2, v4, v1} {v2, v4} s /\
         strict_qua2 {v, v2, v4, v3} {v2, v4} s`,
REWRITE_TAC[ interior_pos; conflicting_dia; adjacent_pai] THEN MESON_TAC[]);;


let RELATE_Q_SYS = prove (` ! q s. (?v v1 v3 v2 v4.
      (q = {v, v1, v2, v3} \/ q = {v, v1, v3, v4}) /\
      interior_pos v v1 v3 v2 v4 s /\
      anchor_points v1 v3 s = {v, v2, v4} /\
      anchor_points v2 v4 s = {v, v1, v3})
 ==> strict_qua q s`,
NHANH (MATCH_MP (MESON[]`( ! a b c d e f. P a b c d e f ) 
   ==> P a b c d e f`) strict_qua2_interior_pos) THEN 
NHANH (MATCH_MP (MESON[] `( ! x y z. P x y z ) ==> P x y z `) 
  strict_qua2_imply_strict_qua) THEN 
MESON_TAC[ SET_RULE ` {v, v1, v2 , v3 } = {v, v1, v3, v2}`]);;

(* ======= *)

let strict_qua_in_oct = prove (`! (q:real^3 -> bool) (s:real^3 -> bool ). (?v w v1 v2 v3 v4.
                   q = {v, w, v1, v2} /\ quartered_oct v w v1 v2 v3 v4 s)
  ==> strict_qua q s `, 

REWRITE_TAC[ quartered_oct; strict_qua; quarter] THEN 
ONCE_REWRITE_TAC[ GSYM (MESON[ DIST_TRIANGLE]` dist (v,w) <= dist (v,v1) + dist (v1,w) /\
     dist (v,w) <= dist (v,v2) + dist (v2,w) /\
     q = {v, w, v1, v2} <=>
     q = {v, w, v1, v2} `)] THEN 
ONCE_REWRITE_TAC[SET_RULE ` (!x. x IN {v1, v2, v3, v4}
          ==> dist (x,v) <= &2 * t0 /\ dist (x,w) <= &2 * t0) <=>
     (!x. x IN {v1, v2, v3, v4}
          ==> dist (x,v) <= &2 * t0 /\ dist (x,w) <= &2 * t0) /\
     dist (v1,v) <= &2 * t0 /\
     dist (v1,w) <= &2 * t0 /\ 
  dist (v2,v) <= &2 * t0 /\
     dist (v2,w) <= &2 * t0 `]  THEN 
PHA THEN REWRITE_TAC[ GSYM d3 ] THEN 
ONCE_REWRITE_TAC[ SET_RULE ` q = {v, w, v1, v2} <=> q = {v, w, v1, v2} /\
  v IN q /\ w IN q `] THEN 
REWRITE_TAC[ MESON[]` d3 v w <= d3 v v1 + d3 v1 w /\
          d3 v w <= d3 v v2 + d3 v2 w /\
          (q = {v, w, v1, v2} /\ v IN q /\ w IN q) /\
          packing s /\
          &2 * t0 < d3 v w /\
          d3 v w < sqrt (&8) /\ last <=> ((q = {v, w, v1, v2} /\ v IN q /\ w IN q) /\
          packing s /\
          &2 * t0 < d3 v w /\
          d3 v w < sqrt (&8) ) /\ d3 v w <= d3 v v1 + d3 v1 w /\
          d3 v w <= d3 v v2 + d3 v2 w /\ last ` ] THEN 
REWRITE_TAC[ MESON[]` (?v w v1 v2 v3 v4.
          ((q = {v, w, v1, v2} /\ v IN q /\ w IN q) /\
           packing s /\
           &2 * t0 < d3 v w /\
           d3 v w < sqrt (&8)) /\
          last v w v1 v2 v3 v4 )
     ==> aa /\ bb /\ cc /\
         (?x y. x IN q /\ y IN q /\ &2 * t0 < d3 x y /\ d3 x y < sqrt (&8)) <=>
     (?v w v1 v2 v3 v4.
          ((q = {v, w, v1, v2} /\ v IN q /\ w IN q) /\
           packing s /\
           &2 * t0 < d3 v w /\
           d3 v w < sqrt (&8)) /\
          last v w v1 v2 v3 v4)
     ==> aa /\ bb /\ cc  `] THEN 
REWRITE_TAC[ simplex] THEN PHA THEN SIMP_TAC[] THEN REWRITE_TAC[ d3 ] THEN 
ONCE_REWRITE_TAC[ MESON[ prove(
                         `dist (v,w) <= dist (v,v1) + dist (v1,w) /\
                           dist (v1,v) <= &2 * t0 /\
                           dist (v1,w) <= &2 * t0 /\
                              &2 * t0 < dist (v,w) /\
                              dist (v,w) < sqrt (&8)
                            ==> &0 < dist (v,v1) /\ &0 < dist (v1,w)`, SIMP_TAC[ DIST_SYM; t0] THEN 
                          REAL_ARITH_TAC)] `
          &2 * t0 < dist (v,w) /\
     dist (v,w) < sqrt (&8) /\
     dist (v,w) <= dist (v,v1) + dist (v1,w) /\
     dist (v,w) <= dist (v,v2) + dist (v2,w) /\
     (!x. x IN {v1, v2, v3, v4}
          ==> dist (x,v) <= &2 * t0 /\ dist (x,w) <= &2 * t0) /\
     dist (v1,v) <= &2 * t0 /\
     dist (v1,w) <= &2 * t0 /\
     dist (v2,v) <= &2 * t0 /\
     dist (v2,w) <= &2 * t0 /\
     last <=>
     &2 * t0 < dist (v,w) /\
     dist (v,w) < sqrt (&8) /\
     dist (v,w) <= dist (v,v1) + dist (v1,w) /\
     dist (v,w) <= dist (v,v2) + dist (v2,w) /\
     (!x. x IN {v1, v2, v3, v4}
          ==> dist (x,v) <= &2 * t0 /\ dist (x,w) <= &2 * t0) /\
     dist (v1,v) <= &2 * t0 /\
     dist (v1,w) <= &2 * t0 /\
     dist (v2,v) <= &2 * t0 /\
     dist (v2,w) <= &2 * t0 /\
     &0 < dist (v,v1) /\
     &0 < dist (v1,w) /\ &0 < dist (v,v2) /\
     &0 < dist (v2,w) /\
     last `] THEN 
REWRITE_TAC[ t0] THEN 
ONCE_REWRITE_TAC[ REAL_ARITH ` &2 <= dist (v1,v2) <=> &2 <= dist (v1,v2) /\ 
  &0 < dist(v1,v2) `] THEN 
REWRITE_TAC[ MESON[] ` &0 < dist ( a, b ) /\ sau <=> sau /\ &0 < dist ( a,b) `] THEN PHA THEN 
ONCE_REWRITE_TAC[ MESON[ DIST_NZ]` &0 < dist(a,b) <=> &0 < dist(a,b) /\ ~(a=b) `] THEN 
PHA THEN  
REWRITE_TAC[ MESON[]` ~(a=b) /\ last <=> last /\ ~( a=b) `] THEN PHA THEN 
REWRITE_TAC[ MESON[] ` q = {v, w, v1, v2} /\
          v IN q /\
          w IN q /\
          packing s /\ last <=> packing s /\ q = {v, w, v1, v2} /\
          v IN q /\
          w IN q /\
           last `] THEN 
REWRITE_TAC[ MESON[] `  (?v w v1 v2 v3 v4.
          packing s /\ last v w v1 v2 v3 v4 ) <=> packing s /\ (?v w v1 v2 v3 v4.
         last v w v1 v2 v3 v4 ) `] THEN SIMP_TAC[] THEN 
REWRITE_TAC[ MESON[] ` q = {v, w, v1, v2}  /\ last <=> last /\  q = {v, w, v1, v2} `] THEN 
ONCE_REWRITE_TAC[ SET_RULE `  {v, w, v1, v2, v3, v4} SUBSET s /\
          q = {v, w, v1, v2} <=> {v, w, v1, v2, v3, v4} SUBSET s /\
          q = {v, w, v1, v2} /\ q SUBSET s `] THEN 
REWRITE_TAC[ MESON[] `  ~(v = v1) /\
          ~(v1 = w) /\
          ~(v = v2) /\
          ~(v2 = w) /\
          ~(v4 = v1) /\
          ~(v3 = v4) /\
          ~(v2 = v3) /\
          ~(v1 = v2) /\
          {v, w, v1, v2, v3, v4} SUBSET s /\
          q = {v, w, v1, v2} /\
          q SUBSET s <=> {v, w, v1, v2, v3, v4} SUBSET s /\ 
  q SUBSET s /\ (  ~(v = v1) /\
          ~(v1 = w) /\
          ~(v = v2) /\
          ~(v2 = w) /\
          ~(v4 = v1) /\
          ~(v3 = v4) /\
          ~(v2 = v3) /\
          ~(v1 = v2) /\ q = {v, w, v1, v2}  )  `] THEN 
REWRITE_TAC[ MESON[] ` a /\ b/\ c <=> ( a/\ b) /\ c `] THEN 
REWRITE_TAC[ MESON[]` a /\ b <=> b /\ a `] THEN 
REWRITE_TAC[ MESON[] ` (?v w v1 v2 v3 v4.
          q = {v, w, v1, v2} /\
          ~(v1 = v2) /\
          ~(v2 = v3) /\
          ~(v3 = v4) /\
          ~(v4 = v1) /\
          ~(v2 = w) /\
          ~(v = v2) /\
          ~(v1 = w) /\
          ~(v = v1) /\
          q SUBSET s /\ la v w v1 v2 v3 v4 ) <=> 
  q SUBSET s /\ (?v w v1 v2 v3 v4.
          q = {v, w, v1, v2} /\
          ~(v1 = v2) /\
          ~(v2 = v3) /\
          ~(v3 = v4) /\
          ~(v4 = v1) /\
          ~(v2 = w) /\
          ~(v = v2) /\
          ~(v1 = w) /\
          ~(v = v1) /\
          la v w v1 v2 v3 v4 ) `] THEN SIMP_TAC[] THEN 
ONCE_REWRITE_TAC[ MESON[ REAL_ARITH ` &0 < &2 * #1.255 /\ 
( ! a b c. a < b /\ b < c ==> a < c )`; DIST_NZ ] ` &2 * #1.255 < dist (v,w)
 <=> ~(v=w) /\ &2 * #1.255 < dist (v,w) ` ] THEN PHA THEN 
REWRITE_TAC[ MESON[] ` (~(v = w) /\ &2 * #1.255 < dist (v,w) /\ v IN q /\ w IN q <=>
      &2 * #1.255 < dist (v,w) /\ v IN q /\ w IN q /\ ~(v = w)) /\
     (a /\ b /\ c <=> (a /\ b) /\ c) `] THEN 
REWRITE_TAC[ MESON[] ` ~(v = w) /\ &2 * #1.255 < dist (v,w) /\ v IN q /\ w IN q <=>
      &2 * #1.255 < dist (v,w) /\ v IN q /\ w IN q /\ ~(v = w)
     `] THEN 
REWRITE_TAC[ MESON[] ` a /\ b /\ c <=> (a/\b) /\ c `] THEN 
REWRITE_TAC [MESON[] ` aa /\  ~(v = w) <=> ~(v=w) /\ aa `] THEN PHA  THEN 
REWRITE_TAC[ MESON[]` ~(v = w) /\
          ~(v = v1) /\
          ~(v1 = w) /\
          ~(v = v2) /\
          ~(v2 = w) /\
          ~(v4 = v1) /\
          ~(v3 = v4) /\
          ~(v2 = v3) /\
          ~(v1 = v2) /\
          q = {v, w, v1, v2} /\ last <=> (~(v = w) /\
          ~(v = v1) /\
          ~(v1 = w) /\
          ~(v = v2) /\
          ~(v2 = w) /\
          ~(v4 = v1) /\
          ~(v3 = v4) /\
          ~(v2 = v3) /\
          ~(v1 = v2) /\
          q = {v, w, v1, v2}) /\ last `] THEN 
SIMP_TAC[ SET_RULE ` {v1, v2, v3, v4} = q <=> q = {v1, v2, v3, v4}`] THEN 
ONCE_REWRITE_TAC[ MESON[ SET_RULE ` ~(v = w) /\
           ~(v = v1) /\
           ~(v1 = w) /\
           ~(v = v2) /\
           ~(v2 = w) /\
           ~(v4 = v1) /\
           ~(v3 = v4) /\
           ~(v2 = v3) /\
           ~(v1 = v2) ==>
   ( {v, w} INTER {v1, v2 } = {} /\ ~(v = w \/ v1 = v2 ) )` ] `
  ~(v = w) /\
     ~(v = v1) /\
     ~(v1 = w) /\
     ~(v = v2) /\
     ~(v2 = w) /\
     ~(v4 = v1) /\
     ~(v3 = v4) /\
     ~(v2 = v3) /\
     ~(v1 = v2) /\
     q = {v, w, v1, v2} <=>
     (q = {v, w, v1, v2} /\
      {v, w} INTER {v1, v2} = {} /\
      ~(v = w \/ v1 = v2)) /\
     ~(v = w) /\
     ~(v = v1) /\
     ~(v1 = w) /\
     ~(v = v2) /\
     ~(v2 = w) /\
     ~(v4 = v1) /\
     ~(v3 = v4) /\
     ~(v2 = v3) /\
     ~(v1 = v2) `] THEN 
PHA THEN ONCE_REWRITE_TAC[MESON[]` (?v w v1 v2 v3 v4.
          q = {v, w, v1, v2} /\
          {v, w} INTER {v1, v2} = {} /\
          ~(v = w \/ v1 = v2) /\
          last v w v1 v2 v3 v4) <=>
     (?v w v1 v2.
          q = {v, w, v1, v2} /\
          {v, w} INTER {v1, v2} = {} /\
          ~(v = w \/ v1 = v2)) /\
     (?v w v1 v2 v3 v4.
          q = {v, w, v1, v2} /\
          {v, w} INTER {v1, v2} = {} /\
          ~(v = w \/ v1 = v2) /\
          last v w v1 v2 v3 v4) `] THEN SIMP_TAC[] THEN PHA THEN 
MATCH_MP_TAC (MESON[] `(! q s. gi q s ==> cc q s ) ==> 
   ( ! q s. a q /\ gi q s /\ b s ==> cc q s ) `) THEN 
REWRITE_TAC[ MESON[] ` {v, w, v1, v2, v3, v4} SUBSET s /\ a <=> a /\
 {v, w, v1, v2, v3, v4} SUBSET s `] THEN 
REWRITE_TAC[ MESON[]` q = {v, w, v1, v2} /\ a <=> a /\ q = {v, w, v1, v2} `] THEN PHA THEN 
ONCE_REWRITE_TAC[SET_RULE ` {v, w, v1, v2, v3, v4} SUBSET s /\ q = {v, w, v1, v2} <=>
     {v, w, v1, v2, v3, v4} SUBSET s /\ q = {v, w, v1, v2} /\ q SUBSET s `] THEN 
NGOAC THEN ONCE_REWRITE_TAC[MESON[] ` (?v w v1 v2 v3 v4. aaa v w v1 v2 v3 v4 /\ 
  q SUBSET s ) <=> q SUBSET s /\ (?v w v1 v2 v3 v4. aaa v w v1 v2 v3 v4)`] THEN PHA THEN 
SIMP_TAC[] THEN 
REWRITE_TAC[ MESON[]` dist (v1,v2) <= &2 * #1.255 /\
     &0 < dist (v1,v2) /\
     &2 <= dist (v1,v2) /\
     dist (v2,w) <= &2 * #1.255 /\
     dist (v2,v) <= &2 * #1.255 /\
     dist (v1,w) <= &2 * #1.255 /\
     dist (v1,v) <= &2 * #1.255 /\
     last <=>
     &0 < dist (v1,v2) /\
     &2 <= dist (v1,v2) /\
     last /\
     dist (v1,v2) <= &2 * #1.255 /\
     dist (v2,w) <= &2 * #1.255 /\
     dist (v2,v) <= &2 * #1.255 /\
     dist (v1,w) <= &2 * #1.255 /\
     dist (v1,v) <= &2 * #1.255 `] THEN PHA  THEN 
ONCE_REWRITE_TAC[ SET_RULE ` q = {v, w, v1, v2} <=>
     q = {v, w, v1, v2} /\
     (!x y.
          ~({x, y} = {v, w}) /\ x IN q /\ y IN q
          ==> (x = v \/ x = w \/ x = v1 \/ x = v2) /\
              (y = v \/ y = w \/ y = v1 \/ y = v2) /\
              ~(x = v /\ y = w \/ x = w /\ y = v)) `] THEN 
REWRITE_TAC[ MESON[] ` ~( a\/ b ) <=> ~ a /\ ~ b `] THEN 
NGOAC THEN REWRITE_TAC[ MESON[] ` a /\ ( b \/ c ) <=> a /\ b \/ a /\ c `] THEN 

PHA THEN REWRITE_TAC[ MESON[]` day /\ ~(x = v /\ y = w) /\
                   ~(x = w /\ y = v) <=> 
  ~(x = v /\ y = w) /\
                   ~(x = w /\ y = v) /\ day `] THEN 
PHA THEN REWRITE_TAC[ MESON[] ` ( a \/ b ) /\c <=> a /\ c \/ b /\ c `] THEN PHA THEN 
REWRITE_TAC[ MESON[] ` (a\/b) \/ c <=> a \/ b\/ c`] THEN 
REWRITE_TAC[ MESON[] ` ~(x = v /\ y = w) /\
     ~(x = w /\ y = v) /\
     (x = v /\ y = v \/
      x = w /\ y = v \/
      x = v1 /\ y = v \/
      x = v2 /\ y = v \/
      x = v /\ y = w \/
      last) <=>
     ~(x = v /\ y = w) /\
     ~(x = w /\ y = v) /\
     (x = v /\ y = v \/ x = v1 /\ y = v \/ x = v2 /\ y = v \/ last) `] THEN 
REWRITE_TAC[ MESON[ SET_RULE ` ~({x, y} = {v, w}) <=> ~(x = v /\ y = w) /\ ~(x = w /\ y = v)`]
  ` (!x y.
          ~({x, y} = {v, w}) /\ x IN q /\ y IN q
          ==> ~(x = v /\ y = w) /\ ~(x = w /\ y = v) /\ last x y)
     <=> (!x y. ~({x, y} = {v, w}) /\ x IN q /\ y IN q ==> last x y) `] THEN 
ONCE_REWRITE_TAC[ MESON[DIST_REFL; REAL_ARITH ` a = &0 ==> a <= &2 * #1.255 `]
 ` x = v /\ y = v <=> x = v /\ y = v /\ dist(x,y) <= &2 * #1.255 `] THEN 
REWRITE_TAC[ MESON[]` ( ! x y. P x y ) /\ last <=> last /\ ( ! x y. P x y)`] THEN PHA THEN 
ONCE_REWRITE_TAC[MESON[]` dist (v1,v2) <= &2 * #1.255 /\
     dist (v2,w) <= &2 * #1.255 /\
     dist (v2,v) <= &2 * #1.255 /\
     dist (v1,w) <= &2 * #1.255 /\
     dist (v1,v) <= &2 * #1.255 /\
     (!x y. ~({x, y} = {v, w}) /\ x IN q /\ y IN q ==> last x y) <=>
     dist (v1,v2) <= &2 * #1.255 /\
     dist (v2,w) <= &2 * #1.255 /\
     dist (v2,v) <= &2 * #1.255 /\
     dist (v1,w) <= &2 * #1.255 /\
     dist (v1,v) <= &2 * #1.255 /\
     (!x y.
          ~({x, y} = {v, w}) /\ x IN q /\ y IN q
          ==> 
              dist (v1,v2) <= &2 * #1.255 /\
              dist (v2,w) <= &2 * #1.255 /\
              dist (v2,v) <= &2 * #1.255 /\
              dist (v1,w) <= &2 * #1.255 /\
              dist (v1,v) <= &2 * #1.255 /\ last x y) `] THEN 
REWRITE_TAC[ MESON[ DIST_SYM]`dist (v1,v2) <= &2 * #1.255 /\
     dist (v2,w) <= &2 * #1.255 /\
     dist (v2,v) <= &2 * #1.255 /\
     dist (v1,w) <= &2 * #1.255 /\
     dist (v1,v) <= &2 * #1.255 /\
     (x = v /\ y = v /\ dist (x,y) <= &2 * #1.255 \/
      x = v1 /\ y = v \/
      x = v2 /\ y = v \/
      last) <=>
     dist (v1,v2) <= &2 * #1.255 /\
     dist (v2,w) <= &2 * #1.255 /\
     dist (v2,v) <= &2 * #1.255 /\
     dist (v1,w) <= &2 * #1.255 /\
     dist (v1,v) <= &2 * #1.255 /\
     (x = v /\ y = v /\ dist (x,y) <= &2 * #1.255 \/
      x = v1 /\ y = v /\ dist (x,y) <= &2 * #1.255 \/
      x = v2 /\ y = v /\ dist (x,y) <= &2 * #1.255 \/
      last) `] THEN 
REWRITE_TAC[ MESON[]` a \/ b \/ c <=> (a \/ b ) \/ c `] THEN 
REWRITE_TAC[ MESON[] ` ((((a \/ x = v2 /\ y = v1) \/ x = v /\ y = v2) \/ x = w /\ y = v2) \/
      x = v1 /\ y = v2) \/
     x = v2 /\ y = v2 /\ dist (x,y) <= &2 * #1.255 <=>
     (((x = v2 /\ y = v1 \/ x = v /\ y = v2) \/ x = w /\ y = v2) \/
      x = v1 /\ y = v2) \/
     x = v2 /\ y = v2 /\ dist (x,y) <= &2 * #1.255 \/
     a `] THEN 
REWRITE_TAC[ GSYM (MESON[]` a \/ b \/ c <=> (a \/ b ) \/ c `)] THEN 
REWRITE_TAC[MESON[DIST_SYM ]` dist (v1,v2) <= &2 * #1.255 /\
                   dist (v2,w) <= &2 * #1.255 /\
                   dist (v2,v) <= &2 * #1.255 /\
                   dist (v1,w) <= &2 * #1.255 /\
                   dist (v1,v) <= &2 * #1.255 /\
                   (x = v2 /\ y = v1 \/
                    x = v /\ y = v2 \/
                    x = w /\ y = v2 \/
                    x = v1 /\ y = v2 \/ last ) 
  <=> dist (v1,v2) <= &2 * #1.255 /\
                   dist (v2,w) <= &2 * #1.255 /\
                   dist (v2,v) <= &2 * #1.255 /\
                   dist (v1,w) <= &2 * #1.255 /\
                   dist (v1,v) <= &2 * #1.255 /\
                   ((x = v2 /\ y = v1 \/ 
                    x = v /\ y = v2 \/
                    x = w /\ y = v2 \/
                    x = v1 /\ y = v2 ) /\ dist( x,y) <= &2 * #1.255 \/ last ) `] THEN 
REWRITE_TAC[ MESON[]` a \/ b \/ c <=> (a \/ b ) \/ c `] THEN 
REWRITE_TAC[ MESON[]` ((((a \/ x = v1 /\ y = w) \/
                       x = v2 /\ y = w) \/
                      x = v /\ y = v1) \/
                     x = w /\ y = v1) \/
                    x = v1 /\ y = v1 /\ dist (x,y) <= &2 * #1.255 <=>
  (((x = v1 /\ y = w \/
                       x = v2 /\ y = w) \/
                      x = v /\ y = v1) \/
                     x = w /\ y = v1) \/
                    x = v1 /\ y = v1 /\ dist (x,y) <= &2 * #1.255 \/ a `] THEN 
REWRITE_TAC[ GSYM (MESON[]` a \/ b \/ c <=> (a \/ b ) \/ c `)] THEN 
REWRITE_TAC[ MESON[ DIST_SYM ] ` 
  dist (v1,v2) <= &2 * #1.255 /\
     dist (v2,w) <= &2 * #1.255 /\
     dist (v2,v) <= &2 * #1.255 /\
     dist (v1,w) <= &2 * #1.255 /\
     dist (v1,v) <= &2 * #1.255 /\
     (x = v1 /\ y = w \/
      x = v2 /\ y = w \/
      x = v /\ y = v1 \/
      x = w /\ y = v1 \/
      last) <=>
     dist (v1,v2) <= &2 * #1.255 /\
     dist (v2,w) <= &2 * #1.255 /\
     dist (v2,v) <= &2 * #1.255 /\
     dist (v1,w) <= &2 * #1.255 /\
     dist (v1,v) <= &2 * #1.255 /\
     ((x = v1 /\ y = w \/
       x = v2 /\ y = w \/
       x = v /\ y = v1 \/
       x = w /\ y = v1) /\
      dist (x,y) <= &2 * #1.255 \/
      last) `] THEN 
REWRITE_TAC[ MESON[] ` x = v1 /\ y = v2 /\ dist (x,y) <= &2 * #1.255 
  <=> (x = v1 /\ y = v2) /\ dist (x,y) <= &2 * #1.255 `] THEN 
REWRITE_TAC[ GSYM (MESON[]` a \/ b \/ c <=> (a \/ b ) \/ c `)] THEN 
REWRITE_TAC[ MESON[]` a /\ c \/ b /\ c <=> ( a\/ b) /\ c `] THEN NGOAC THEN 
ONCE_REWRITE_TAC[ MESON[] ` ( ! x y. P x y ==> L x y /\ TT x y ) <=>
  ( ! x y. P x y ==> L x y /\ TT x y ) /\ ( ! x y. P x y ==> TT x y ) `] THEN 
NGOAC THEN 
REWRITE_TAC[ MESON[]` a /\ (!x y.
               (~({x, y} = {v, w}) /\ x IN q) /\ y IN q
               ==> dist (x,y) <= &2 * #1.255) <=> (!x y.
               (~({x, y} = {v, w}) /\ x IN q) /\ y IN q
               ==> dist (x,y) <= &2 * #1.255) /\ a `] THEN 
REWRITE_TAC[ MESON[]` ((( a /\dist (v,w) < sqrt (&8)) /\
                    &2 * #1.255 < dist (v,w)) /\
                   v IN q) /\
                  w IN q
  <=> (((dist (v,w) < sqrt (&8)) /\
                    &2 * #1.255 < dist (v,w)) /\
                   v IN q) /\
                  w IN q /\ a `] THEN PHA THEN 
ONCE_REWRITE_TAC[MESON[ REAL_ARITH ` a < b ==> a <= b `]` (?v w v1 v2 v3 v4.
          (!x y.
               ~({x, y} = {v, w}) /\ x IN q /\ y IN q
               ==> dist (x,y) <= &2 * #1.255) /\
          dist (v,w) < sqrt (&8) /\
          &2 * #1.255 < dist (v,w) /\
          v IN q /\
          w IN q /\ last v w v1 v2 v3 v4 )
  <=> (?v w.
              (!x y.
                   ~({x, y} = {v, w}) /\ x IN q /\ y IN q
                   ==> dist (x,y) <= &2 * #1.255) /\
              dist (v,w) <= sqrt (&8) /\
              &2 * #1.255 <= dist (v,w) /\
              v IN q /\
              w IN q) /\ (?v w v1 v2 v3 v4.
          (!x y.
               ~({x, y} = {v, w}) /\ x IN q /\ y IN q
               ==> dist (x,y) <= &2 * #1.255) /\
          dist (v,w) < sqrt (&8) /\
          &2 * #1.255 < dist (v,w) /\
          v IN q /\
          w IN q /\ last v w v1 v2 v3 v4 )`] THEN PHA THEN 
REPEAT GEN_TAC THEN MATCH_MP_TAC (MESON[] ` ( b ==> d ) ==> (a /\ b /\ c ==> d) `) THEN 
MESON_TAC[]);;

(* ======== *)

let WHEN_IN_Q_SYS = prove (`! q s. q IN Q_SYS s ==> quasi_reg_tet q s \/ strict_qua q s \/ 
(?v v1 v3 v2 v4.
                   (q = {v, v1, v2, v3} \/ q = {v, v1, v3, v4}) /\
                   interior_pos v v1 v3 v2 v4 s /\
                   anchor_points v1 v3 s = {v, v2, v4} /\
                   anchor_points v2 v4 s = {v, v1, v3})`,
REWRITE_TAC[ Q_SYS; IN_ELIM_THM] THEN MESON_TAC[strict_qua_in_oct] );; 

(* ====== *)


let CASES_OF_Q_SYS = prove (`!q s. q IN Q_SYS s ==> quasi_reg_tet q s \/ strict_qua q s`,
NHANH (MATCH_MP (MESON[]` ( ! a b. P a b) ==> P a b` ) WHEN_IN_Q_SYS) THEN 
REPEAT GEN_TAC THEN MATCH_MP_TAC (MESON[]` ( c ==> b) ==>  aa /\ ( a \/ b\/ c )
  ==> a \/ b `) THEN REWRITE_TAC[ RELATE_Q_SYS]);;

(* ======= *)


let simplex_interior_pos = prove(`!s v v1 v2 v3 v4.
     interior_pos v v1 v3 v2 v4 s
     ==> simplex {v, v1, v3, v2} s /\
         simplex {v, v1, v3, v4} s /\
         simplex {v, v2, v4, v1} s /\
         simplex {v, v2, v4, v3} s`,
ONCE_REWRITE_TAC[ MESON[strict_qua2_interior_pos]` 
interior_pos v v1 v3 v2 v4 s <=>
  interior_pos v v1 v3 v2 v4 s /\ strict_qua2 {v, v1, v3, v2} {v1, v3} s /\
             strict_qua2 {v, v1, v3, v4} {v1, v3} s /\
             strict_qua2 {v, v2, v4, v1} {v2, v4} s /\
             strict_qua2 {v, v2, v4, v3} {v2, v4} s `] THEN 
REWRITE_TAC[ strict_qua2 ] THEN 
NGOAC THEN REWRITE_TAC[ MESON[]` a /\  quarter {v, v1, v2, v3} s <=> 
  quarter {v, v1, v2, v3} s /\ a `] THEN PHA THEN 
REPEAT GEN_TAC THEN MATCH_MP_TAC (MESON[] ` (a /\ b/\c /\ d ==> las )
  ==> ( a/\ b/\ c/\ d /\ dd ==> las ) `) THEN 
NGOAC THEN REWRITE_TAC[ MESON[] `(( a /\ packing s ) /\
    simplex {v, v1, v2, v3} s) <=> simplex {v, v1, v2, v3} s /\ packing s /\ a`] THEN 
REWRITE_TAC[MESON[]`  packing s /\ a <=> a /\ packing s`] THEN PHA THEN 
MESON_TAC[quarter]);;

(* =========== *)


let QUA_TET_IMPLY_QUA_TRI = prove(` ! s v0 v1 v2 . (?v4. quasi_reg_tet ({v0, v1, v2} UNION {v4}) s)
 ==> quasi_tri {v0, v1, v2} s`, REWRITE_TAC[ quasi_reg_tet; quasi_tri] THEN 
REWRITE_TAC[ SET_RULE ` {a,b,c} UNION {d} = {a,b,c,d} `; def_simplex; set_3elements] THEN 
MESON_TAC[SET_RULE ` {a,b,c} SUBSET {a,b,c,d} ` ; SUBSET; SUBSET_TRANS]);;


let PAIR_D3 = prove(` ! i j u w. {u,w} = {i,j} ==> d3 i j = d3 u w `, 
REWRITE_TAC[ SET_RULE ` {u, w} = {i, j} <=>  u= i /\ w = j \/ u = j /\ w = i `] THEN 
MESON_TAC[ trg_d3_sym]);;


let PAIR_DIST = prove(` ! i j u w. {u,w} = {i,j} ==> dist(i,j) = dist(u,w) `, 
REWRITE_TAC[ SET_RULE ` {u, w} = {i, j} <=>  u= i /\ w = j \/ u = j /\ w = i `] THEN 
MESON_TAC[ DIST_SYM]);;



(* ============== *)

let DIAGONAL_QUA = prove(`!a b q s.
     a IN q /\
     b IN q /\
     &2 * t0 < d3 a b /\
     quarter q s 
     ==> diagonal a b q s `,
REWRITE_TAC[diagonal; SET_RULE ` a IN q /\ b IN q /\ &2 * t0 < d3 a b /\ quarter q s
     ==> quarter q s /\  {a, b} SUBSET q /\ l <=>  a IN q /\ b IN q /\ &2 * t0 < d3 a b 
   /\ quarter q s ==> l`] THEN REWRITE_TAC[quarter] THEN NGOAC THEN 
REWRITE_TAC[ MESON[] ` a /\ (? u v. P u v ) <=> (? u v. a /\ P u v ) `] THEN 
REWRITE_TAC[ REAL_ARITH ` a < b <=> ~( b <= a ) `] THEN 
PHA THEN REWRITE_TAC[ MESON[]` a IN q /\  b IN q /\ ~(d3 a b <= &2 * t0)  /\ las <=> 
las /\ a IN q /\  b IN q /\ ~(d3 a b <= &2 * t0) `] THEN PHA THEN 
NHANH (MESON[]` (!x y.
               x IN q /\ y IN q /\ ~({x, y} = {v, w}) ==> d3 x y <= &2 * t0) /\
          a IN q /\
          b IN q /\
          ~(d3 a b <= &2 * t0) ==> {a,b} = {v,w} `) THEN 
NHANH (MESON[ PAIR_D3] ` aa /\ {a, b} = {v, w} ==> d3 a b = d3 v w `) THEN 
MESON_TAC[ PAIR_D3; REAL_ARITH` (a <= a) /\ ( a <= b /\ b <= c ==> a <= c ) `]);;




let NOV2 = prove( `!a b c v4.
     (?i j. i IN {a, b, c} /\ j IN {a, b, c} /\ ~(i = j) /\ #2.51 < d3 i j) /\
     (?v w.
          v IN {a, b, c, v4} /\
          w IN {a, b, c, v4} /\
          #2.51 <= d3 v w /\
          d3 v w <= sqrt (&8) /\
          (!x y.
               x IN {a, b, c, v4} /\ y IN {a, b, c, v4} /\ ~({x, y} = {v, w})
               ==> d3 x y <= #2.51))
     ==> (?i j.
              i IN {a, b, c} /\
              j IN {a, b, c} /\
              #2.51 < d3 i j /\
              (!x y.
                   x IN {a, b, c} /\ y IN {a, b, c} /\ ~({x, y} = {i, j})
                   ==> d3 x y <= #2.51))`,
REWRITE_TAC[ MESON[] ` (? i j. P i j ) /\ (? v w. Q v w ) <=> ( ? i j u w. P i j /\ Q u w ) `] THEN 
REWRITE_TAC[ MESON[] ` (i IN {a, b, c} /\ j IN {a, b, c} /\ ~(i = j) /\ #2.51 < d3 i j) /\ aa <=>
  aa /\ (i IN {a, b, c} /\ j IN {a, b, c} /\ ~(i = j) /\ #2.51 < d3 i j)`] THEN 
PHA THEN 
REWRITE_TAC[ REAL_ARITH ` a < b <=> ~( b <= a ) `] THEN 
NHANH (MESON[ SET_RULE ` x IN {a,b,c} ==> x IN {a,b,c,d} ` ] ` (!x y.
               x IN {a, b, c, v4} /\ y IN {a, b, c, v4} /\ ~({x, y} = {u, w})
               ==> d3 x y <= #2.51) /\
          i IN {a, b, c} /\
          j IN {a, b, c} /\
          ~(i = j) /\
          ~(d3 i j <= #2.51)
  ==> {i,j} = {u,w} `) THEN PHA THEN 
NHANH ( MESON[ PAIR_D3] ` ~(d3 i j <= #2.51) /\
          {i, j} = {u, w} ==> d3 i j = d3 u w `) THEN 
PHA THEN REWRITE_TAC[ MESON[]` {i, j} = {u, w} /\ a <=> a /\ {i, j} = {u, w}`] THEN 
REWRITE_TAC[ MESON[] ` (! x y. P x y ) /\ a <=> a /\ (! x y. P x y) `] THEN PHA THEN 
NHANH ( MESON[  SET_RULE ` x IN {a,b,c} ==> x IN {a,b,c,d} `] ` {i, j} = {u, w} /\
          (!x y.
               x IN {a, b, c, v4} /\ y IN {a, b, c, v4} /\ ~({x, y} = {u, w})
               ==> d3 x y <= #2.51)
  ==> (!x y.
               x IN {a, b, c} /\ y IN {a, b, c} /\ ~({x, y} = {i, j})
               ==> d3 x y <= #2.51)`) THEN MESON_TAC[]);;



let TRIANGLE_IN_STRICT_QUA = prove( `!s a b c.
     (?v4. strict_qua ( {a,b,c} UNION {v4}) s)
     ==> quasi_tri {a,b,c} s \/
         (?aa bb.
              {aa, bb} SUBSET {a,b,c} /\
              #2.51 < dist (aa,bb) /\
              (!x y.
                   ~({x, y} = {aa, bb}) /\ {x, y} SUBSET {a,b,c}
                   ==> dist (x,y) <= #2.51))`,
REWRITE_TAC[ strict_qua; quarter; simplex] THEN 
REWRITE_TAC[SET_RULE `{a, b, c} UNION {d} = {a,b,c,d}`;MESON[]` {v1, v2, v3, v4'} = 
 {a, b, c, v4} <=> {a, b, c, v4} = {v1, v2, v3, v4'} `;  SET_OF_4] THEN 
REWRITE_TAC[ quasi_tri] THEN 
NHANH (MESON[] ` {a, b, c, v4} SUBSET s ==> ((!i j.
           i IN {a, b, c} /\ j IN {a, b, c} /\ ~(i = j)
           ==> d3 i j <= &2 * t0) \/
      (?i j.
           i IN {a, b, c} /\ j IN {a, b, c} /\ ~(i = j)
           /\ ~(d3 i j <= &2 * t0))) `) THEN PHA THEN 
NHANH (SET_RULE ` {a, b, c, v4} SUBSET s ==> {a, b, c} SUBSET s `) THEN 
REPEAT GEN_TAC THEN KHANANG THEN 
MATCH_MP_TAC (MESON[] ` ((? a. P a) ==> l) /\ ((?a. Q a ) ==> l ) ==> 
  (?a . P a \/ Q a ) ==> l `) THEN 
REWRITE_TAC[ MESON[]` (?v4. packing s /\
           packing s /\
           {a, b, c, v4} SUBSET s /\
           {a, b, c} SUBSET s /\
           (!i j.
                i IN {a, b, c} /\ j IN {a, b, c} /\ ~(i = j)
                ==> d3 i j <= &2 * t0) /\
           ~(a = b \/ a = c \/ a = v4 \/ b = c \/ b = v4 \/ c = v4) /\
           (?v w.
                v IN {a, b, c, v4} /\
                w IN {a, b, c, v4} /\
                &2 * t0 <= d3 v w /\
                d3 v w <= sqrt (&8) /\
                (!x y.
                     x IN {a, b, c, v4} /\
                     y IN {a, b, c, v4} /\
                     ~({x, y} = {v, w})
                     ==> d3 x y <= &2 * t0)) /\
           (?x y.
                x IN {a, b, c, v4} /\
                y IN {a, b, c, v4} /\
                &2 * t0 < d3 x y /\
                d3 x y < sqrt (&8)))
     ==> packing s /\
         {a, b, c} SUBSET s /\
         (?a' b' c'.
              ~(a' = b' \/ b' = c' \/ c' = a') /\ {a', b', c'} = {a, b, c}) /\
         (!x y.
              x IN {a, b, c} /\ y IN {a, b, c} /\ ~(x = y)
              ==> d3 x y <= &2 * t0) \/
         (?aa bb.
              {aa, bb} SUBSET {a, b, c} /\
              #2.51 < dist (aa,bb) /\
              (!x y.
                   ~({x, y} = {aa, bb}) /\ {x, y} SUBSET {a, b, c}
                   ==> dist (x,y) <= #2.51))`] THEN 
REWRITE_TAC[ GSYM d3; REAL_ARITH ` ~( a <= b ) <=> b < a `] THEN 
REWRITE_TAC[ t0; REAL_ARITH` &2 * #1.255 = #2.51 `] THEN 
REWRITE_TAC[ SET_RULE ` {aa, bb} SUBSET s <=> aa IN s /\ bb IN s `] THEN 
ONCE_REWRITE_TAC[ MESON[]`(? x y. P x y ) /\ a <=> a /\ (? x y. P x y )`] THEN PHA THEN 
ONCE_REWRITE_TAC[ MESON[] ` (? x y . P x y ) /\ a /\ b <=> a /\ b /\ (? x y. P x y)`] THEN 
NHANH (CUTHE4 NOV2 ) THEN MESON_TAC[]);;

(* ================== *)


let A_LEMMA = prove(`!s v0 v1 v2.
     quasi_tri {v0, v1, v2} s
     ==> (!xx yy.
              ~(xx = yy) /\ {xx, yy} SUBSET {v1, v2, v0}
              ==> &2 <= dist (xx,yy) /\ dist (xx,yy) <= sqrt (&8)) /\
         ((!aa bb.
               aa IN {v1, v2, v0} /\ bb IN {v1, v2, v0}
               ==> dist (aa,bb) <= #2.51) \/
          (?aa bb.
               {aa, bb} SUBSET {v1, v2, v0} /\
               #2.51 < dist (aa,bb) /\
               (!x y.
                    ~({x, y} = {aa, bb}) /\ {x, y} SUBSET {v1, v2, v0}
                    ==> dist (x,y) <= #2.51)))`,
REWRITE_TAC[ MESON[]` a /\ {v0, v1, v2} SUBSET s /\ c <=> ( a /\ {v0, v1, v2} 
   SUBSET s) /\ c ` ] THEN NHANH (MESON[SET_RULE ` {x,y} SUBSET b /\ b SUBSET s ==> 
  s x /\ s y `]` (!u v. s u /\ s v /\ ~(u = v) ==> &2 <= dist (u,v)) /\
     {v0, v1, v2} SUBSET s ==> (!xx yy.
              ~(xx = yy) /\ {xx, yy} SUBSET {v0, v1, v2}
              ==> &2 <= dist (xx,yy) ) `) THEN 
REWRITE_TAC[ quasi_tri; set_3elements; packing; MESON[] ` a /\ {v0, v1, v2} SUBSET s /\ c <=>
   ( a /\ {v0, v1, v2} SUBSET s)/\c` ] THEN 
NHANH (MESON[ SET_RULE ` x IN a /\ a SUBSET s ==> s x ` ] ` (!u v. s u /\ s v /\
   ~(u = v) ==> &2 <= dist (u,v)) /\ {v0, v1, v2} SUBSET s ==> (!x y.
          x IN {v0, v1, v2} /\ y IN {v0, v1, v2} /\ ~(x = y)
          ==> &2 <= dist (x,y))`) THEN PHA THEN 
REWRITE_TAC[ SET_RULE ` x IN {v0, v1, v2} /\ y IN {v0, v1, v2} /\ ~(x = y) <=> 
  ~(x = y) /\ {x, y } SUBSET {v0, v1, v2}`] THEN 
REWRITE_TAC[ t0] THEN 
ONCE_REWRITE_TAC[ MESON[ MATCH_MP REAL_LT_RSQRT (REAL_ARITH ` (&2 * #1.255) pow 2 < &8 `); REAL_ARITH` a <= b /\ b < c ==> a <= c ` ]`
  d3 x y <= &2 * #1.255 <=> d3 x y <= &2 * #1.255 /\ d3 x y <= sqrt( &8 ) `] THEN 
REWRITE_TAC[ REAL_ARITH ` &2 * #1.255 = #2.51`] THEN 
NHANH ( MESON[d3; DIST_SYM; DIST_REFL; REAL_ARITH ` &0 <= #2.51 `]` (!x y.
          ~(x = y) /\ {x, y} SUBSET {v0, v1, v2}
          ==> d3 x y <= #2.51 /\ d3 x y <= sqrt (&8))
  ==> (!x y.
          {x, y} SUBSET {v0, v1, v2}
          ==> d3 x y <= #2.51 )`) THEN 
REWRITE_TAC[ GSYM d3] THEN REWRITE_TAC[ SET_RULE ` a IN s /\ b IN s <=>
   {a,b} SUBSET s `] THEN 
MESON_TAC[ SET_RULE` {v0, v1, v2} = {v1, v2, v0}`]);;



let NOV1 = prove(` ! s v0 v1 v2 . (?v4. quasi_reg_tet ({v0, v1, v2} UNION {v4}) s)
 ==> (!xx yy.
          ~(xx = yy) /\ {xx, yy} SUBSET {v1, v2, v0}
          ==> &2 <= dist (xx,yy) /\ dist (xx,yy) <= sqrt (&8)) /\
     ((!aa bb.
           aa IN {v1, v2, v0} /\ bb IN {v1, v2, v0} ==> dist (aa,bb) <= #2.51) \/
      (?aa bb.
           {aa, bb} SUBSET {v1, v2, v0} /\
           #2.51 < dist (aa,bb) /\
           (!x y.
                ~({x, y} = {aa, bb}) /\ {x, y} SUBSET {v1, v2, v0}
                ==> dist (x,y) <= #2.51)))`, NHANH (CUTHE4 QUA_TET_IMPLY_QUA_TRI) THEN 
REPEAT GEN_TAC THEN MATCH_MP_TAC (MESON[]` (b ==> c) ==> a /\ b ==> c `) THEN 
 REWRITE_TAC[ A_LEMMA]);;


let TRIANGLE_IN_BARRIER = prove(` ! s v0 v1 v2 . {v0, v1, v2} IN barrier s
 ==> (!xx yy.
          ~(xx = yy) /\ {xx, yy} SUBSET {v1, v2, v0}
          ==> &2 <= dist (xx,yy) /\ dist (xx,yy) <= sqrt (&8)) /\
     ((!aa bb.
           aa IN {v1, v2, v0} /\ bb IN {v1, v2, v0} ==> dist (aa,bb) <= #2.51) \/
      (?aa bb.
           {aa, bb} SUBSET {v1, v2, v0} /\
           #2.51 < dist (aa,bb) /\
           (!x y.
                ~({x, y} = {aa, bb}) /\ {x, y} SUBSET {v1, v2, v0}
                ==> dist (x,y) <= #2.51)))`,
REWRITE_TAC[ barrier; IN_ELIM_THM] THEN 
REWRITE_TAC[ GSYM (MESON[]` P {x, y, z} <=> 
       (?a b c. P {a, b, c} /\ {x, y, z} = {a, b, c})`)] THEN 
MP_TAC A_LEMMA THEN 
REWRITE_TAC[ MESON[]` (! a b c d. P a b c d ==> las a b c d ) ==> (! a b c d .
  P a b c d \/ Q a b c d ==> las a b c d) <=> 
  (! a b c d. P a b c d ==> las a b c d ) ==> (! a b c d .
  Q a b c d ==> las a b c d)`] THEN DISCH_TAC THEN 
NHANH (CUTHE2 CASES_OF_Q_SYS) THEN 
REPEAT GEN_TAC THEN 
MATCH_MP_TAC (MESON[]` ((? a. Q a) ==> l) /\ ((?a. R a ) ==> l) ==> 
  (? a. P a /\ ( Q a \/ R a )) ==> l `) THEN 
REWRITE_TAC[ NOV1] THEN 
NHANH (CUTHE4 TRIANGLE_IN_STRICT_QUA) THEN 
MATCH_MP_TAC (MESON[]` (b ==> l) /\ ( a /\ c ==> l) ==> a /\ ( b \/ c ) ==> l`) THEN 
ASM_REWRITE_TAC[] THEN 
REWRITE_TAC[ strict_qua; quarter; SET_RULE `{a,b,c} UNION {d} = {a,b,c,d}`;  def_simplex] THEN 
PHA THEN 
REWRITE_TAC[ MESON[]` a /\ a /\ l <=> a /\ l `; packing ] THEN 
MATCH_MP_TAC (MESON[] `(a ==> aa) /\ (b ==> bb) ==> a /\ b ==> aa /\ (cc \/ bb)`) THEN 
SIMP_TAC[ SET_RULE `{a,b,c} = {c,a,b} `] THEN 
NHANH (SET_RULE `  {v0, v1, v2, v4} SUBSET s ==> {v0,v1,v2} SUBSET s `) THEN 
NHANH ( MESON[SET_RULE ` x IN a /\ a SUBSET s ==> s x `]`(!u v. s u /\ s v /\ ~(u = v) ==> &2 <= dist (u,v)) /\
       ({v0, v1, v2, v4} SUBSET s /\ {v0, v1, v2} SUBSET s) /\ l ==>
  (!u v. u IN {v0,v1,v2} /\ v IN {v0,v1,v2} /\ ~(u = v) ==> &2 <= dist (u,v))`) THEN 
REWRITE_TAC[t0] THEN 
NHANH ( MESON[PAIR_D3] ` d3 v w <= sqrt (&8) ==> (! x y. x IN {v0, v1, v2, v4} /\
                  y IN {v0, v1, v2, v4} /\ {x,y} = {v,w} ==> d3 x y <= sqrt (&8) )`) THEN 
REWRITE_TAC[ SET_RULE ` {a,b} SUBSET s <=> a IN s /\ b IN s `] THEN 
SIMP_TAC[ SET_RULE ` {a,b,c} = {c,a,b} `] THEN 
REWRITE_TAC[ GSYM d3 ] THEN 
MESON_TAC[ MATCH_MP REAL_LE_RSQRT (REAL_ARITH ` (&2 * #1.255 ) pow 2 <= &8 `);
  SET_RULE ` x IN {a,b,c} ==> x IN {a,b,c,d} `; REAL_ARITH ` a <= b /\ b <= c ==> a <= c `]);;

(* ============== *)

let DIA_OF_QUARTER = prove(`! a b q s. diagonal a b q s ==> &2 * t0 <= d3 a b /\ d3 a b 
   <= sqrt (&8) `,
REWRITE_TAC[ diagonal; quarter] THEN 
REWRITE_TAC[ SET_RULE ` {a,b} SUBSET s <=> a IN s /\ b IN s `] THEN 
REWRITE_TAC[ SET_RULE ` {a,b} SUBSET s <=> a IN s /\ b IN s `; t0] THEN 
MESON_TAC[PAIR_D3; MATCH_MP REAL_LE_RSQRT (REAL_ARITH ` (&2 * #1.255) pow 2 <= &8 `);
  REAL_ARITH ` a <= b /\ b <= c ==> a <= c `]);;

let D3_REFL = prove(` !x. d3 x x = &0 ` , MESON_TAC[d3; DIST_REFL]);;

let db_t0_sq8 = MATCH_MP REAL_LT_RSQRT (REAL_ARITH ` #2.51 pow 2 < &8 `);;

let def_obstructed = prove(`!s x y.
     obstructed x y s <=>
     (?bar. bar IN barrier s /\ ~(conv0 {x, y} INTER conv bar = {}))`,
  REWRITE_TAC[ obstructed; conv0_2] THEN REWRITE_TAC[ simp_def]);;

let SUB_PACKING = prove(`!sub s.
     packing s /\ sub SUBSET s
     ==> (!x y. x IN sub /\ y IN sub /\ ~(x = y) ==> &2 <= d3 x y)`,
REWRITE_TAC[ packing; GSYM d3] THEN SET_TAC[]);;


let PAIR_EQ_EXPAND =
 SET_RULE `{a,b} = {c,d} <=> a = c /\ b = d \/ a = d /\ b = c`;;

let IN_SET3 = SET_RULE ` x IN {a,b,c} <=> x = a \/ x = b \/ x = c `;;
let IN_SET4 = SET_RULE ` x IN {a,b,c,d} <=> x = a \/ x = b \/ x = c \/ x = d `;;

let SHORT_EDGES = prove(` ! a b c w. d3 c a <= &2 * t0 /\
 d3 c b <= &2 * t0 /\
 (!aa. aa IN {a, b, c} ==> d3 aa w <= &2 * t0)
 ==> (!x y.
          x IN {a, b, c, w} /\ y IN {a, b, c, w} /\ ~({x, y} = {a, b})
          ==> d3 x y <= &2 * t0)`,
REPEAT GEN_TAC THEN 
REWRITE_TAC[ IN_SET3; IN_SET4; PAIR_EQ_EXPAND; t0] THEN 
MESON_TAC[ D3_REFL; trg_d3_sym; REAL_ARITH ` &0 <= &2 * #1.255`]);;



(* == CARD ASSERTIONN == *)
(* changing truong *)

let OBS_SYM = prove(` ! a b s. obstructed a b s <=> obstructed b a s `, 
 REWRITE_TAC[ def_obstructed] THEN SIMP_TAC[ SET_RULE` {a,b} = {b,a}`]);;

(* need VC *)
let OBS_IMP_NOT_IN_VC = prove(`!x w s. obstructed x w s ==> ~(x IN VC w s \/ w IN VC x s)`,
REWRITE_TAC[VC; lambda_x; IN_ELIM_THM] THEN MESON_TAC[ OBS_SYM]);;


let IN_Q_IMP_BAR = 
prove(` {v0, v1, v2, w} IN Q_SYS s ==> {v0,v1,v2} IN barrier s `, 
REWRITE_TAC[ barrier; SET_RULE` {a,b,c} UNION {d} = {a,b,c,d} `; IN_ELIM_THM]
 THEN MESON_TAC[]);;


let v_near2t0_v = MESON[near2t0; t0; DIST_REFL; SET_RULE ` x IN { x | P x} <=> P x ` ;
 REAL_ARITH ` &0 < &2 * #1.255 `] ` w IN s  ==>  w IN near2t0 w s  `;;

(* need VC *)
let in_VC = prove( 
`!w s x.
     w IN s /\
     dist (w,x) < &2 /\
     (!w'. s w' /\ ~(w' = w) ==> dist (x,w) < dist (x,w')) /\
     ~obstructed w x s
     ==> x IN VC w s`, REWRITE_TAC[ VC; lambda_x ; d3; IN_ELIM_THM] THEN 
  MESON_TAC[ DIST_SYM; SET_RULE ` i IN x <=> x i `]);;


let MEETING_CONDITION = prove(` ! x y v1 v2 v3. ~(conv0 {x, y} INTER conv_trg {v1, v2, v3} = {}) /\ dist (x,y) < t0
 ==> ~(normball x #1.255 INTER conv {v1, v2, v3} = {})`,
REWRITE_TAC[ GSYM conv0_2; simp_def] THEN 
REWRITE_TAC[ SET_RULE ` ~( a INTER b = {} ) <=> (? d. d IN   a /\ d IN b )`;
  IN_ELIM_THM] THEN 
NHANH (MESON[ VECTOR_ARITH ` x = &1 % x ` ]` d = t % x + (&1 - t) % y ==> 
  x = &1 % x `) THEN 
NHANH (VECTOR_ARITH ` d = t % x + (&1 - t) % y /\ x = &1 % x
     ==> d - x = (t - &1) % ( x - y)`) THEN 
NHANH ( MESON[NORM_MUL]` d - x = (t - &1) % (x - y) ==> norm ( d - x ) = 
  abs ( t- &1 ) * norm ( x-y)`) THEN 
REWRITE_TAC[ GSYM dist] THEN 
NHANH (REAL_ARITH `&0 < t /\ t < &1 /\ aa ==> abs (t - &1) < &1`) THEN 
NHANH (MESON[DIST_POS_LE]` dist (d,x) = abs (t - &1) * dist (x,y) ==> &0 <= dist(x,y)`) THEN 
PHA THEN 
REWRITE_TAC[ REAL_ARITH ` abs (t - &1) < &1 <=> &0 < &1 - abs (t - &1) `] THEN 
NHANH (MESON[REAL_LE_MUL_EQ] ` &0 <= dist (x,y) /\
               &0 < &1 - abs (t - &1) ==>  &0 <= dist (x,y) * (&1 - abs (t - &1))`) THEN 
REWRITE_TAC[ REAL_ARITH ` a * (  b - c ) = a * b - a * c `] THEN 
REWRITE_TAC[ REAL_ARITH ` &0 <= a - b <=> b <= a `] THEN 
NHANH (REAL_ARITH ` dist (d,x) = abs (t - &1) * dist (x,y) /\
               (&0 <= dist (x,y) /\ &0 < &1 - abs (t - &1)) /\
               dist (x,y) * abs (t - &1) <= dist (x,y) * &1
  ==> dist(d,x) <= dist(x,y)`) THEN 
NGOAC THEN NHANH (MESON[]`(? d . ( ? t. PP t d /\ dist (d,x) <= dist (x,y)) /\ aa d )  ==> (? d. dist (d,x)
   <= dist (x,y) /\ aa d ) `) THEN 
PHA THEN REPEAT GEN_TAC THEN 
MATCH_MP_TAC (MESON[] ` (b /\ c ==> d) ==> ( a/\ b/\ c )==> d `) THEN 
REWRITE_TAC[normball; IN_ELIM_THM; GSYM t0] THEN 
REWRITE_TAC[ MESON[]` (? a . P a ) /\ aa <=> (? a. aa /\ P a ) `] THEN 
MESON_TAC[ REAL_ARITH ` a < b /\ c <= a ==> c < b `]);;


(* needs VC *)
let VC_DISJOINT = prove ( `! s a b. ( ~( a = b ) ==> VC a s INTER VC b s = {}) /\ 
                                                     VC a s INTER VC_INFI s = {} `, 
REWRITE_TAC[ VC_INFI; SET_RULE ` VC a s INTER {z | !x. ~(z IN VC x s)} = {} `] THEN 
REWRITE_TAC[ VC; lambda_x ] THEN 
REWRITE_TAC[ SET_RULE` a INTER b = {} <=> (! x. ~( x IN a /\ x IN b ))`] THEN 
REWRITE_TAC[ SET_RULE ` x IN { x | p x } <=> p x `] THEN 
REWRITE_TAC[ MESON[] ` ! a P. a ==> (!x. ~P x) <=> a ==> (!x. ~a \/ ~P x) `] THEN 
REWRITE_TAC[ MESON[] ` a = b \/
     ~(((a IN s /\ d3 a x < &2 /\ ~obstructed a x s) /\
        (!w. (w IN s /\ d3 w x < &2 /\ ~obstructed w x s) /\ ~(w = a)
             ==> d3 x a < d3 x w)) /\
       (b IN s /\ d3 b x < &2 /\ ~obstructed b x s) /\
       (!w. (w IN s /\ d3 w x < &2 /\ ~obstructed w x s) /\ ~(w = b)
            ==> d3 x b < d3 x w)) <=>
     ~(~(a = b) /\
       ((a IN s /\ d3 a x < &2 /\ ~obstructed a x s) /\
        (!w. (w IN s /\ d3 w x < &2 /\ ~obstructed w x s) /\ ~(w = a)
             ==> d3 x a < d3 x w)) /\
       (b IN s /\ d3 b x < &2 /\ ~obstructed b x s) /\
       (!w. (w IN s /\ d3 w x < &2 /\ ~obstructed w x s) /\ ~(w = b)
            ==> d3 x b < d3 x w)) `] THEN PHA THEN 
MESON_TAC[ REAL_ARITH ` ! a b. ~( a < b /\ b < a ) `]);;


let DIAGONAL_STRICT_QUA = prove(` !a b q s.
     a IN q /\ b IN q /\ &2 * t0 < d3 a b /\ strict_qua q s
     ==> diagonal a b q s`,
REWRITE_TAC[ SET_RULE ` a IN q /\ b IN q /\ l ==> aa /\ {a,b} SUBSET q /\ bb
  <=> a IN q /\ b IN q /\ l ==> aa /\ bb `] THEN 
REWRITE_TAC[ MESON[]` a /\ b/\ c /\ d /\ e ==> d /\ f <=> a /\ b/\ c /\ d /\ e ==> f `] THEN 
MESON_TAC[strict_qua; DIAGONAL_QUA]);;

(* ========== *) 

let DIAGONAL_BARRIER = prove(` ! s v1 v2 bar .v1 IN bar /\ v2 IN bar /\ bar IN barrier s /\ &2 * t0 < d3 v1 v2 
  ==> (? w. diagonal v1 v2 ( w INSERT bar ) s )`,
REWRITE_TAC[ barrier; IN_ELIM_THM] THEN 
PHA THEN REWRITE_TAC[ MESON[] ` a /\ b /\ (? u v w. P u v w ) /\ d <=>
  (? u v w. P u v w /\ a /\ b /\ d ) `] THEN 
KHANANG THEN 
REWRITE_TAC[ MESON[]` (? a b c. P a b c) /\ l <=> (?a b c. P a b c /\ l)`] THEN 
REWRITE_TAC[ quasi_tri; t0] THEN 
NHANH ( REAL_ARITH ` &2 * #1.255 < a ==> ~( a = &0 ) `) THEN 
REWRITE_TAC[d3; DIST_EQ_0] THEN 
NGOAC THEN 
PURE_ONCE_REWRITE_TAC[ MESON[]` P {a,b,c} /\ bar = {a,b,c} <=> P bar /\ bar 
  = {a,b,c} `] THEN 
REWRITE_TAC[quasi_tri; REAL_ARITH ` a <= b <=> ~( b < a ) `] THEN PHA THEN 
REWRITE_TAC[ MESON[]` ~((!x y.
            x IN bar /\ y IN bar /\ ~(x = y) ==> ~(&2 * #1.255 < dist (x,y))) /\
       aaa /\
       v1 IN bar /\
       v2 IN bar /\
       &2 * #1.255 < dist (v1,v2) /\
       ~(v1 = v2))`] THEN 
NHANH (CUTHE2 CASES_OF_Q_SYS) THEN 
REWRITE_TAC[ MESON[]` (? a . P a ) /\ l <=> (? a. P a /\ l ) `] THEN 
KHANANG THEN 
PURE_ONCE_REWRITE_TAC[ MESON[]` P bar /\ bar = s /\ l <=> P s /\ bar = s /\ l`] THEN 
NHANH (MESON[QUA_TET_IMPLY_QUA_TRI] ` quasi_reg_tet ({v0, v1, v2} UNION {v4}) s ==>
  quasi_tri {v0, v1, v2} s`) THEN 
REWRITE_TAC[ quasi_tri] THEN 
REWRITE_TAC[d3;t0; REAL_ARITH ` a <= &2 * #1.255 <=> ~(&2 * #1.255 < a ) `] THEN PHA THEN 
REWRITE_TAC[ MESON[]` ~((!x y.
            x IN {v1', v2', v3} /\ y IN {v1', v2', v3} /\ ~(x = y)
            ==> ~(&2 * #1.255 < dist (x,y))) /\
       bar = {v1', v2', v3} /\
       v1 IN bar /\
       v2 IN bar /\
       &2 * #1.255 < dist (v1,v2) /\
       ~(v1 = v2))`] THEN 
REWRITE_TAC[ GSYM d3; GSYM t0] THEN 
REWRITE_TAC[ MESON[]` strict_qua ({v1', v2', v3} UNION {v4}) s /\ bar = {v1', v2', v3} /\ l <=>
     strict_qua (bar UNION {v4}) s /\ bar = {v1', v2', v3} /\ l`] THEN 
ONCE_REWRITE_TAC[ SET_RULE ` bar UNION {v4} = v4 INSERT bar `] THEN 
MESON_TAC[ DIAGONAL_STRICT_QUA; SET_RULE ` x IN bar ==> x IN ( a INSERT bar)`]);;


(* ======= end simplizee.ml =========== *)

(* ======= im_le_82.ml ================ *)

let quasi_tri_case = prove( ` ! s x y. (?v1 v2 v3.
      ~(x IN {v1, v2, v3}) /\
      quasi_tri {v1, v2, v3} s /\
      ~(conv0 {x, y} INTER conv_trg {v1, v2, v3} = {}) /\
      dist (x,y) < t0)
 ==> (?v1 v2 v3.
          packing s /\
          ~(v1 = v2 \/ v2 = v3 \/ v3 = v1) /\
          dist (v1,v2) <= #2.51 /\
          dist (v2,v3) <= #2.51 /\
          dist (v3,v1) < sqrt (&8) /\
          {v1, v2, v3} SUBSET s /\
          ~(x IN {v1, v2, v3}) /\
          ~(conv0 {x, y} INTER conv_trg {v1, v2, v3} = {}) /\
          dist (x,y) < t0)`,
REWRITE_TAC[ quasi_tri; set_3elements] THEN PHA THEN 
 REWRITE_TAC[ d3; MESON[t0; REAL_ARITH ` &2 * #1.255 = #2.51 `] ` &2 * t0 = #2.51 `] THEN 
REWRITE_TAC[ MESON[]` a /\ b /\ c /\ d /\e /\ f <=> a /\ b /\ c /\ (d /\e) /\ f`] THEN 
ONCE_REWRITE_TAC[ SET_RULE ` ~(v1 = v2 \/ v2 = v3 \/ v3 = v1) /\
          (!x y.
               x IN {v1, v2, v3} /\ y IN {v1, v2, v3} /\ ~(x = y)
               ==> dist (x,y) <= #2.51)
  <=> ~(v1 = v2 \/ v2 = v3 \/ v3 = v1) /\
          (!x y.
               x IN {v1, v2, v3} /\ y IN {v1, v2, v3} /\ ~(x = y)
               ==> dist (x,y) <= #2.51) /\
   dist (v1,v2) <= #2.51 /\
              dist (v2,v3) <= #2.51 /\
              dist (v3,v1) <= #2.51 `] THEN 
ONCE_REWRITE_TAC[MESON[ REAL_ARITH ` &2 * #1.255 = #2.51 `; MATCH_MP REAL_LT_RSQRT (REAL_ARITH `(&2 * #1.255) pow 2 < &8`); 
  REAL_ARITH` a <= b /\ b < c ==> a < c `] `
  a /\ dist (v3,v1) <= #2.51 <=> a /\ dist (v3,v1) < sqrt ( &8 ) /\ dist (v3,v1) <= #2.51`] THEN 
 MESON_TAC[]);;



(* ----------- have added to database_more --------------*)



let OCT23 = prove(`! s v1 v2 v3 v4.
     {v1, v2, v3} UNION {v4} IN Q_SYS s
     ==> packing s /\
         ~(v1 = v2 \/ v2 = v3 \/ v3 = v1) /\
         {v1, v2, v3} SUBSET s` ,
REPEAT GEN_TAC THEN MP_TAC (prove(`! q s. q IN Q_SYS s ==> quasi_reg_tet q s \/ strict_qua q s \/ 
(?v v1 v3 v2 v4.
                   (q = {v, v1, v2, v3} \/ q = {v, v1, v3, v4}) /\
                   interior_pos v v1 v3 v2 v4 s /\
                   anchor_points v1 v3 s = {v, v2, v4} /\
                   anchor_points v2 v4 s = {v, v1, v3})`,
REWRITE_TAC[ Q_SYS; IN_ELIM_THM] THEN MESON_TAC[strict_qua_in_oct] )) THEN 
MATCH_MP_TAC (MESON[]`((!q s. q IN Q_SYS s ==> R q s)
      ==> R ({v1, v2, v3} UNION {v4}) s
      ==> last v1 v2 v3 s)
     ==> (!q s. q IN Q_SYS s ==> R q s)
     ==> {v1, v2, v3} UNION {v4} IN Q_SYS s
     ==> last v1 v2 v3 s`) THEN 
DISCH_TAC THEN 
REWRITE_TAC[ quasi_reg_tet; strict_qua ] THEN 
 PHA THEN KHANANG  THEN 
REWRITE_TAC[ quarter] THEN 
PHA THEN 
REWRITE_TAC[ MESON[]` packing s /\simplex ({v1, v2, v3} UNION {v4}) s /\ last <=> 
   simplex ({v1, v2, v3} UNION {v4}) s /\ packing s /\ last`] THEN 
REWRITE_TAC[ SET_RULE ` {v1, v2, v3} UNION {v4} = { v1, v2, v3, v4} `] THEN 
MP_TAC (MESON[ def_simplex; SET_RULE ` {a, b, c, d} SUBSET s ==> {a, b, c} SUBSET s `] `
  simplex {v1, v2, v3, v4} s ==> packing s /\ ~(v1 = v2 \/ v2 = v3 \/ v3 = v1) /\ {v1, v2, v3} SUBSET s `) THEN 
MATCH_MP_TAC (MESON[]` (cc ==> last)
     ==> (aa ==> last)
     ==> aa /\ la1 \/ aa /\ la2 \/ cc
     ==> last`) THEN 
REWRITE_TAC[ MESON[]` a = b /\ (aa /\ bb b s) /\ last <=> bb a s /\ aa /\ a = b /\ last`] THEN 
REWRITE_TAC[def_simplex] THEN 
ONCE_REWRITE_TAC[ MESON[simplex_interior_pos]` interior_pos v v1 v3 v2 v4 s <=> interior_pos v v1 v3 v2 v4 s
              /\ simplex {v, v1, v3, v2} s /\
               simplex {v, v1, v3, v4} s /\
               simplex {v, v2, v4, v1} s /\
               simplex {v, v2, v4, v3} s `] THEN PHA THEN 
REWRITE_TAC[ MESON[]` {v1, v2, v3, v4} = {v, v1', v2', v3'} /\
      aa /\  simplex {v, v1', v3', v2'} s /\ ss
  <=> ( simplex {v, v1', v3', v2'} s /\ {v1, v2, v3, v4} = {v, v1', v2', v3'}) /\ aa /\ ss `] THEN 
REWRITE_TAC[ MESON[SET_RULE ` {v, v1, v2 , v3} = {v, v1, v3, v2} ` ] ` 
  (simplex {v, v1', v3', v2'} s /\ {v1, v2, v3, v4} = {v, v1', v2', v3'}) /\ ff <=>
  simplex {v1, v2, v3, v4} s /\ {v1, v2, v3, v4} = {v, v1', v2', v3'} /\ ff`] THEN 
MESON_TAC[ def_simplex; SET_RULE ` {v1, v2, v3, v4} SUBSET s ==> {v1, v2, v3} SUBSET s`]);;


(* ================== *)


let OCT24 = prove(`! s x y.  (?v1 v2 v3.
      ~(x IN {v1, v2, v3}) /\
      (?v4. (!vv1 vv2 vv3.
                 {vv1, vv2, vv3} = {v1, v2, v3} ==> ~(#2.51 < dist (vv3,vv1))) /\
            {v1, v2, v3} UNION {v4} IN Q_SYS s) /\
      ~(conv0 {x, y} INTER conv_trg {v1, v2, v3} = {}) /\
      dist (x,y) < t0) ==>
(?v1 v2 v3.
          packing s /\
          ~(v1 = v2 \/ v2 = v3 \/ v3 = v1) /\
          dist (v1,v2) <= #2.51 /\
          dist (v2,v3) <= #2.51 /\
          dist (v3,v1) < sqrt (&8) /\
          {v1, v2, v3} SUBSET s /\
          ~(x IN {v1, v2, v3}) /\
          ~(conv0 {x, y} INTER conv_trg {v1, v2, v3} = {}) /\
          dist (x,y) < t0)`,
ONCE_REWRITE_TAC[ MESON[OCT23] ` {v1, v2, v3} UNION {v4} IN Q_SYS s <=>
  {v1, v2, v3} UNION {v4} IN Q_SYS s /\ packing s /\
             ~(v1 = v2 \/ v2 = v3 \/ v3 = v1) /\
             {v1, v2, v3} SUBSET s `] THEN 
ONCE_REWRITE_TAC[ MESON[ SET_RULE` {v1, v3 , v2 } = { v1, v2 , v3} /\ { v2, v1, v3 } = { v1, v2, v3 }`]`
  (!vv1 vv2 vv3.
          {vv1, vv2, vv3} = {v1, v2, v3} ==> ~(#2.51 < dist (vv3,vv1)))
     <=> (!vv1 vv2 vv3.
          {vv1, vv2, vv3} = {v1, v2, v3} ==> ~(#2.51 < dist (vv3,vv1))) /\ ~(#2.51 < dist (v3,v1)) /\
         ~(#2.51 < dist (v2,v1)) /\
         ~(#2.51 < dist (v3,v2)) `] THEN 
REWRITE_TAC[ REAL_ARITH ` ~( a < b ) <=> b <= a`] THEN SIMP_TAC[ DIST_SYM] THEN 
MESON_TAC[MESON[ MATCH_MP REAL_LT_RSQRT (REAL_ARITH `(&2 * #1.255) pow 2 < &8`);
  REAL_ARITH ` &2 * #1.255 = #2.51 /\ ( a <= b /\ b < c ==> a < c ) `]` dist (v1,v3) <= #2.51
  <=> dist (v1,v3) <= #2.51 /\ dist (v1,v3) < sqrt (&8) `]);;



(* ============= *)


let quasi_reg_tet_case = prove (`! s x y. (?v1 v2 v3.
       (?v4 vv1 vv2 vv3.
            {vv1, vv2, vv3} = {v1, v2, v3} /\
            #2.51 < dist (vv3,vv1) /\
            {v1, v2, v3} UNION {v4} IN Q_SYS s /\
            quasi_reg_tet ({v1, v2, v3} UNION {v4}) s) /\
       ~(x IN {v1, v2, v3}) /\
       ~(conv0 {x, y} INTER conv_trg {v1, v2, v3} = {}))
  ==> (?v1 v2 v3.
           packing s /\
           ~(v1 = v2 \/ v2 = v3 \/ v3 = v1) /\
           dist (v1,v2) <= #2.51 /\
           dist (v2,v3) <= #2.51 /\
           dist (v3,v1) < sqrt (&8) /\
           {v1, v2, v3} SUBSET s /\
           ~(x IN {v1, v2, v3}) /\
           ~(conv0 {x, y} INTER conv_trg {v1, v2, v3} = {}))`,
REWRITE_TAC[quasi_reg_tet; SET_RULE ` {v1, v2, v3} UNION {v4} = {v1, v2, v3, v4} `; def_simplex] THEN 
REWRITE_TAC[ MESON[]` (packing s /\
           {v1, v2, v3, v4} SUBSET s /\
           ~(v1 = v2 \/ v1 = v3 \/ v1 = v4 \/ v2 = v3 \/ v2 = v4 \/ v3 = v4)) /\ a <=>
  a /\  ~(v1 = v2 \/ v1 = v3 \/ v1 = v4 \/ v2 = v3 \/ v2 = v4 \/ v3 = v4) /\ (packing s /\
           {v1, v2, v3, v4} SUBSET s
          ) `] THEN 
ONCE_REWRITE_TAC[ ATTACH (MESON[ SET_RULE` v1 IN {v1, v2, v3, v4} /\ v2 IN { v1, v2, v3, v4} /\ v3 IN { v1, v2, v3, v4} `] `
  (!v w.
               v IN {v1, v2, v3, v4} /\ w IN {v1, v2, v3, v4} /\ ~(v = w)
               ==> d3 v w <= &2 * t0) /\
          ~(v1 = v2 \/ v1 = v3 \/ v1 = v4 \/ v2 = v3 \/ v2 = v4 \/ v3 = v4) /\last
  ==> d3 v1 v2 <= &2 * t0 /\ d3 v2 v3 <= &2 * t0 /\ d3 v3 v1 <= &2 * t0 `)] THEN 
REWRITE_TAC[ t0; GSYM d3;  REAL_ARITH ` &2 * #1.255  = #2.51 `] THEN 
ONCE_REWRITE_TAC[ ATTACH (MESON[ MATCH_MP REAL_LT_RSQRT (REAL_ARITH `(&2 * #1.255) pow 2 < &8`) ; REAL_ARITH ` &2 * #1.255 = #2.51 /\ ( a <= b /\ b < c ==> a < c ) `]
  ` d3 v1 v2 <= #2.51 /\
          d3 v2 v3 <= #2.51 /\
          d3 v3 v1 <= #2.51 ==> d3 v3 v1 < sqrt (&8) `)] THEN 
MESON_TAC[ SET_RULE ` {v1, v2, v3, v4} SUBSET s ==> {v1, v2, v3} SUBSET s`]);;

let DIST_PAIR_LEMMA = prove
 (`{a,b} = {c,d} ==> dist(a,b) = dist(c,d)`,
 REWRITE_TAC[PAIR_EQ_EXPAND] THEN MESON_TAC[DIST_SYM]);;

let OTHER_LEMMA = prove
 (`!a:real^3 b c d.
         (?v w.
              v IN {a, b, c, d} /\
              w IN {a, b, c, d} /\
              &2 * t0 <= d3 v w /\
              d3 v w <= sqrt (&8) /\
              (!x y.
                   x IN {a, b, c, d} /\
                   y IN {a, b, c, d} /\
                   ~(x = v /\ y = w \/ x = w /\ y = v)
                   ==> d3 x y <= &2 * t0)) /\
         (?x y.
              x IN {a, b, c, d} /\
              y IN {a, b, c, d} /\
              &2 * t0 < d3 x y /\
              d3 x y < sqrt (&8)) /\
         &2 * t0 < d3 d b
         ==> &2 * t0 < d3 d b /\
             d3 d b < sqrt (&8) /\
             (!x y.
                  x IN {a, b, c, d} /\
                  y IN {a, b, c, d} /\
                  ~({x, y} = {d, b})
                  ==> d3 x y <= &2 * t0)`, REWRITE_TAC [d3] THEN 
 REPEAT GEN_TAC THEN REWRITE_TAC[t0; CONJ_ASSOC] THEN
 DISCH_THEN(CONJUNCTS_THEN2 MP_TAC ASSUME_TAC) THEN
 REWRITE_TAC[GSYM CONJ_ASSOC; GSYM PAIR_EQ_EXPAND] THEN
 REWRITE_TAC[LEFT_AND_EXISTS_THM; LEFT_IMP_EXISTS_THM] THEN
 MAP_EVERY X_GEN_TAC [`v:real^3`; `w:real^3`] THEN
 DISCH_THEN(CONJUNCTS_THEN2 STRIP_ASSUME_TAC MP_TAC) THEN
 ASM_CASES_TAC `{v,w} = {d,b:real^3}` THENL
  [FIRST_ASSUM(SUBST_ALL_TAC o MATCH_MP DIST_PAIR_LEMMA) THEN
   FIRST_X_ASSUM SUBST_ALL_TAC;
   FIRST_X_ASSUM(MP_TAC o SPECL [`d:real^3`; `b:real^3`]) THEN
   ASM_REWRITE_TAC[GSYM REAL_NOT_LT; IN_INSERT]] THEN
 ASM_REWRITE_TAC[LEFT_IMP_EXISTS_THM] THEN
 MAP_EVERY X_GEN_TAC [`x:real^3`; `y:real^3`] THEN STRIP_TAC THEN
 FIRST_X_ASSUM(MP_TAC o SPECL [`x:real^3`; `y:real^3`]) THEN
 ASM_REWRITE_TAC[GSYM REAL_NOT_LT] THEN ASM_MESON_TAC[DIST_PAIR_LEMMA]);;


(* ======OCT 23====== *)

let hard_case = prove(`! s x y.  (?v1 v2 v3.
       (?v4 vv1 vv2 vv3.
            {vv1, vv2, vv3} = {v1, v2, v3} /\
            #2.51 < dist (vv3,vv1) /\
            {v1, v2, v3} UNION {v4} IN Q_SYS s /\
            strict_qua ({v1, v2, v3} UNION {v4}) s) /\
       ~(x IN {v1, v2, v3}) /\
       ~(conv0 {x, y} INTER conv_trg {v1, v2, v3} = {}))
  ==> (?v1 v2 v3.
           packing s /\
           ~(v1 = v2 \/ v2 = v3 \/ v3 = v1) /\
           dist (v1,v2) <= #2.51 /\
           dist (v2,v3) <= #2.51 /\
           dist (v3,v1) < sqrt (&8) /\
           {v1, v2, v3} SUBSET s /\
           ~(x IN {v1, v2, v3}) /\
           ~(conv0 {x, y} INTER conv_trg {v1, v2, v3} = {}))`,
REWRITE_TAC[ SET_RULE ` {v1, v2, v3} UNION { v4} = { v1, v2, v3 , v4} `;
  strict_qua] THEN 
REWRITE_TAC [ REAL_ARITH ` #2.51 = &2 * #1.255`] THEN 
PURE_ONCE_REWRITE_TAC[ MESON[]` (?v4 v1 v2 v3. P v4 v1 v2 v3) <=> (?a b c d. P a b c d)`] THEN 
ONCE_REWRITE_TAC[MESON[SET_RULE ` {b, c, d} = {v1, v2, v3} ==> {v1, v2, v3, a} = { a, b, c ,d }`]
  ` (? a b c d. {b, c, d} = {v1, v2, v3} /\ P a b c d v1 v2 v3 {v1, v2, v3, a} )
  <=> (? a b c d. {b, c, d} = {v1, v2, v3} /\ P a b c d v1 v2 v3 { a, b, c ,d })`] THEN 
REWRITE_TAC[quarter] THEN 
REWRITE_TAC[quarter;def_simplex] THEN PHA THEN 
REWRITE_TAC[MESON[]`&2 * #1.255 < dist (d,b) /\ a <=> a /\ &2 * #1.255 < dist (d,b)`] THEN PHA THEN 
REWRITE_TAC[ GSYM t0; GSYM d3] THEN 
REWRITE_TAC[ SET_RULE ` ~({a, b} = {c, d}) <=> ~(a = c /\ b = d \/ a = d /\ b = c)`] THEN 
NHANH (MATCH_MP (MESON[]` (! a b c d. P a b c d ) ==> P a b c d`) OTHER_LEMMA ) THEN PHA THEN 
PURE_ONCE_REWRITE_TAC[ MESON[]` ~(a = b \/ a = c \/ a = d \/ b = c \/ b = d \/ c = d)
  /\ aa <=> aa /\ ~(a = b \/ a = c \/ a = d \/ b = c \/ b = d \/ c = d)`] THEN PHA THEN 
NHANH (SET_RULE ` ~(a = b \/ a = c \/ a = d \/ b = c \/ b = d \/ c = d)
  ==> ~({b, c} = {d,b} ) /\ ~({c,d} = {d,b})`) THEN 
NHANH (SET_RULE` ~({b, c} = {d, b}) /\
               ~({c, d} = {d, b}) ==> b IN {a, b, c, d} /\
  c IN {a, b, c, d} /\ d IN {a, b, c, d} `) THEN PHA THEN 
NHANH (MESON[]` (!x y.
          x IN {a, b, c, d} /\ y IN {a, b, c, d} /\ ~({x, y} = {d, b})
          ==> d3 x y <= &2 * t0) /\
     aaa /\
     ~({b, c} = {d, b}) /\
     ~({c, d} = {d, b}) /\
     b IN {a, b, c, d} /\
     c IN {a, b, c, d} /\
     d IN {a, b, c, d}
     ==> d3 b c <= &2 * t0 /\ d3 c d <= &2 * t0`) THEN 
REWRITE_TAC[ MESON[]`{b, c, d} = {v1, v2, v3} /\ a <=> a /\ {b, c, d} = {v1, v2, v3} `] THEN 
PHA THEN REWRITE_TAC[ MESON[]`{a, b, c, d} SUBSET s /\ aa <=> aa /\ {a, b, c, d} SUBSET s`] THEN 
REWRITE_TAC[ MESON[]` ~(a = b \/ a = c \/ a = d \/ b = c \/ b = d \/ c = d) /\ aa
  <=> aa /\ ~(a = b \/ a = c \/ a = d \/ b = c \/ b = d \/ c = d) `] THEN 
REWRITE_TAC[ MESON[]` (?a b c d. aa a b c d /\ packing s /\ P a b c d )
  <=> packing s /\ (? a b c d. aa a b c d /\ P a b c d)`] THEN 
SIMP_TAC[] THEN PHA THEN 
REWRITE_TAC[ MESON[]` d3 d b < sqrt (&8)/\ a<=> a /\ d3 d b < sqrt (&8)`] THEN 
PHA THEN NHANH (SET_RULE ` {b, c, d} = {v1, v2, v3} /\
               ~(a = b \/ a = c \/ a = d \/ b = c \/ b = d \/ c = d) /\
               {a, b, c, d} SUBSET s /\ last
  ==> {v1, v2, v3} SUBSET s /\ ~( b = c \/ c= d \/ d= b )`) THEN PHA THEN 
REWRITE_TAC[ MESON[]` d3 b c <= &2 * t0 /\
               d3 c d <= &2 * t0  /\ a <=> a /\ d3 b c <= &2 * t0 /\
               d3 c d <= &2 * t0  `] THEN 
MESON_TAC[]);;


(* =========== *)

let OCTOR23 = prove(`(?v1 v2 v3.
      ~(x IN {v1, v2, v3}) /\
      (?v4 vv1 vv2 vv3.
           {vv1, vv2, vv3} = {v1, v2, v3} /\
           #2.51 < dist (vv3,vv1) /\
           {v1, v2, v3} UNION {v4} IN Q_SYS s) /\
      ~(conv0 {x, y} INTER conv_trg {v1, v2, v3} = {}) /\
      dist (x,y) < t0)
==> (?v1 v2 v3.
          packing s /\
          ~(v1 = v2 \/ v2 = v3 \/ v3 = v1) /\
          dist (v1,v2) <= #2.51 /\
          dist (v2,v3) <= #2.51 /\
          dist (v3,v1) < sqrt (&8) /\
          {v1, v2, v3} SUBSET s /\
          ~(x IN {v1, v2, v3}) /\
          ~(conv0 {x, y} INTER conv_trg {v1, v2, v3} = {}) /\
          dist (x,y) < t0)`,
REWRITE_TAC[ MESON[]` a /\ (?v4 vv1 vv2 vv3.
           {vv1, vv2, vv3} = {v1, v2, v3} /\
           #2.51 < dist (vv3,vv1) /\
           {v1, v2, v3} UNION {v4} IN Q_SYS s) /\ b <=> (?v4 vv1 vv2 vv3.
           {vv1, vv2, vv3} = {v1, v2, v3} /\
           #2.51 < dist (vv3,vv1) /\
           {v1, v2, v3} UNION {v4} IN Q_SYS s) /\ a /\ b `] THEN 
NGOAC THEN REWRITE_TAC[ MESON[]` (( a /\ ~(x IN {v1, v2, v3})) /\
           ~(conv0 {x, y} INTER conv_trg {v1, v2, v3} = {})) /\
          dist (x,y) < t0 <=> a /\ ( ~(x IN {v1, v2, v3}) /\
           ~(conv0 {x, y} INTER conv_trg {v1, v2, v3} = {}) /\
          dist (x,y) < t0)`] THEN 
NGOAC THEN MATCH_MP_TAC (MESON[]` ((? a b c. P a b c ) ==> (? a b c. Q a b c) )
  ==> (? a b c. P a b c /\ d ) ==> ( ? a b c. Q a b c /\ d )`) THEN 
ONCE_REWRITE_TAC[ prove (`!q s.
     q IN Q_SYS s <=>
     q IN Q_SYS s /\
     (quasi_reg_tet q s \/
      strict_qua q s \/
      (?v v1 v3 v2 v4.
           (q = {v, v1, v2, v3} \/ q = {v, v1, v3, v4}) /\
           interior_pos v v1 v3 v2 v4 s /\
           anchor_points v1 v3 s = {v, v2, v4} /\
           anchor_points v2 v4 s = {v, v1, v3}))`, MP_TAC WHEN_IN_Q_SYS THEN 
  REWRITE_TAC[ MESON[]` (! q s. P q s ==> R q s ) ==> ( ! q s. P q s <=> P q s
 /\ R q s ) `])] THEN 
KHANANG THEN 
MATCH_MP_TAC (MESON[]` ((?v1 v2 v3. (?a b c d. P v1 v2 v3 a b c d) /\ cc v1 v2 v3) ==> las) /\
     ((?v1 v2 v3. (?a b c d. Q v1 v2 v3 a b c d) /\ cc v1 v2 v3) ==> las) /\
     ((?v1 v2 v3. (?a b c d. R v1 v2 v3 a b c d) /\ cc v1 v2 v3) ==> las)
     ==> (?v1 v2 v3.
              (?a b c d.
                   P v1 v2 v3 a b c d \/
                   Q v1 v2 v3 a b c d \/
                   R v1 v2 v3 a b c d) /\
              cc v1 v2 v3)
     ==> las`) THEN 
SIMP_TAC[quasi_reg_tet_case; hard_case] THEN 
REWRITE_TAC[ MESON[]` a /\ as \/ b /\ as <=> ( a \/ b ) /\ as `] THEN 
NHANH (MATCH_MP (MESON[]` (! q s. P q s) ==> P q s`) RELATE_Q_SYS) THEN 

MATCH_MP_TAC (MESON[]` ((? v1 v2 v3 . (? a b c d. aa a b c d v1 v2 v3 /\ bb a b c d v1 v2 v3
  /\ cc a b c d v1 v2 v3 /\ ee a b c d v1 v2 v3 )
  /\ las v1 v2 v3 ) ==> last )
  ==> (? v1 v2 v3 . (? a b c d. aa a b c d v1 v2 v3 /\ bb a b c d v1 v2 v3
  /\ cc a b c d v1 v2 v3 /\ dd a b c d v1 v2 v3 /\ ee a b c d v1 v2 v3 )
  /\ las v1 v2 v3 ) ==> last `) THEN 
REWRITE_TAC[ hard_case]);;

(* ============ *)


let OCTO23 = prove (` ! s x y. (?v1 v2 v3.
      ~(x IN {v1, v2, v3}) /\
      (quasi_tri {v1, v2, v3} s \/ (?v4. {v1, v2, v3} UNION {v4} IN Q_SYS s)) /\
      ~(conv0 {x, y} INTER conv_trg {v1, v2, v3} = {}) /\
      dist (x,y) < t0)
 ==> (?v1 v2 v3.
          packing s /\
          ~(v1 = v2 \/ v2 = v3 \/ v3 = v1) /\
          dist (v1,v2) <= #2.51 /\
          dist (v2,v3) <= #2.51 /\
          dist (v3,v1) < sqrt (&8) /\
          {v1, v2, v3} SUBSET s /\
          ~(x IN {v1, v2, v3}) /\
          ~(conv0 {x, y} INTER conv_trg {v1, v2, v3} = {}) /\
          dist (x,y) < t0) `,
REWRITE_TAC[MESON[]`  (?v4. {v1, v2, v3} UNION {v4} IN Q_SYS s) <=>
     (?v4 vv1 vv2 vv3.
          ({vv1, vv2, vv3} = {v1, v2, v3} /\ #2.51 < dist (vv3,vv1)) /\
          {v1, v2, v3} UNION {v4} IN Q_SYS s) \/
     (?v4. (!vv1 vv2 vv3.
                {vv1, vv2, vv3} = {v1, v2, v3} ==> ~(#2.51 < dist (vv3,vv1))) /\
           {v1, v2, v3} UNION {v4} IN Q_SYS s) `] THEN KHANANG THEN REPEAT GEN_TAC THEN 
REWRITE_TAC[ MESON[]` (?a b c. P a b c \/ Q a b c \/ R a b c) <=>
     (?a b c. P a b c) \/ (?a b c. Q a b c) \/ (?a b c. R a b c) `] THEN 
MATCH_MP_TAC (MESON[]` ( a ==> l ) /\ ( b==> l ) /\ ( c==> l ) ==> a \/ b\/ c ==> l `) THEN
REWRITE_TAC[ quasi_tri_case; OCT24; OCTOR23 ]);;




(* ===== *)

let IN_AFF_GE_CON = prove(`!x y v3 v2.
     ~(conv0 {x, y} INTER conv_trg {x, v2, v3} = {})
     ==> y IN aff_ge {x} {v2, v3}`,
REWRITE_TAC[ GSYM conv0_2; simpl_conv3; simp_def; SET_RULE` ~( a INTER b = {}) <=> 
  (? x . x IN a /\ x IN b )`; IN_ELIM_THM] THEN 
NGOAC THEN 
REWRITE_TAC[ MESON[]` (?x'. (?t. P t /\ x' = t % x + (&1 - t) % y) /\
           (?a b c. Q a b c /\ x' = a % x + b % v2 + c % v3)) <=>
     (?a b c t. P t /\ Q a b c /\ t % x + (&1 - t) % y = a % x + b % v2 + c % v3)`] THEN 
REWRITE_TAC[ VECTOR_ARITH ` t % x + (&1 - t) % y = a % x + b % v2 + c % v3 
  <=> (&1 - t ) % y = ( a - t ) % x + b % v2 + c % v3 `] THEN 
REWRITE_TAC[ MESON[]` t < &1 /\ a <=> a /\ t < &1 `] THEN PHA THEN 
NHANH (REAL_ARITH` t < &1 ==> ~ ( &1 - t = &0 )`) THEN 
REWRITE_TAC[ MESON[]` (t < &1 /\ ~(&1 - t = &0)) /\ aa <=> aa /\ ~(&1 - t = &0) /\
  t < &1 `] THEN 
REWRITE_TAC[ MESON[]` (t < &1 /\ ~(&1 - t = &0)) /\ aa <=> t < &1 /\ aa /\ ~(&1 - t = &0)
  `] THEN PHA THEN 
ONCE_REWRITE_TAC[ MESON[REAL_FIELD `! a b. ~ ( b = &0 ) <=> a = b * a / b /\ ~ ( b = &0 ) `] `
  ~ ( b = &0 ) <=> ( ! a . a = b * a / b ) /\ ~ ( b = &0 )`] THEN 
PHA THEN REWRITE_TAC[ MESON[ VECTOR_MUL_RCANCEL ] ` (&1 - t) % y = (a - t) % x + b % v2 + c % v3 /\
          (!a. a = (&1 - t) * a / (&1 - t)) /\ las 
  <=> (&1 - t) % y = ((&1 - t) * (a - t ) / (&1 - t)) % x + ((&1 - t) * b / (&1 - t)) % v2 + ((&1 - t) * c / (&1 - t)) % v3 /\
          (!a. a = (&1 - t) * a / (&1 - t)) /\ las `] THEN 
REWRITE_TAC[ VECTOR_ARITH ` ( a * b ) % v1 + ( a * c ) % v2 + ( a * d ) % v3 = a % ( b % v1 + c % v2 + d % v3 ) `] THEN 
REWRITE_TAC[ MESON[ VECTOR_MUL_LCANCEL_IMP; VECTOR_MUL_RCANCEL ] ` (&1 - t) % y =
          (&1 - t) %
          ((a - t) / (&1 - t) % x + b / (&1 - t) % v2 + c / (&1 - t) % v3) /\
          tttt /\
          ~(&1 - t = &0) /\ l <=>  y =
          
          ((a - t) / (&1 - t) % x + b / (&1 - t) % v2 + c / (&1 - t) % v3) /\
          tttt /\
          ~(&1 - t = &0) /\ l  `] THEN 
REWRITE_TAC[ REAL_ARITH ` t < &1 <=> &0 < &1 - t `] THEN 
REWRITE_TAC[ MESON[]`&0 <= a /\ &0 <= b /\
          &0 <= c /\ las <=> &0 <= a /\ las /\ &0 <= b /\
          &0 <= c `] THEN PHA THEN 
REWRITE_TAC[ MESON[REAL_ARITH ` &0 < a ==> &0 <= a `; REAL_LE_DIV ]`
  &0 < &1 - t /\ &0 <= a /\ &0 <= b <=>
     &0 < &1 - t /\
     &0 <= a /\
     &0 <= b /\
     &0 <= a / (&1 - t) /\
     &0 <= b / (&1 - t) `] THEN 
MESON_TAC[MESON[REAL_FIELD `~(&1 - t = &0) /\ a + b + c = &1
     ==> (a - t) / (&1 - t) + b / (&1 - t) + c / (&1 - t) = &1 `]` 
  a + b + c = &1 /\
          y = (a - t) / (&1 - t) % x + b / (&1 - t) % v2 + c / (&1 - t) % v3 /\
          cccc  /\
          ~(&1 - t = &0) /\ las
  <=> a + b + c = &1 /\ cccc  /\ ~(&1 - t = &0) /\ las /\ y = (a - t) / (&1 - t) % x + b / (&1 - t) % v2 + c / (&1 - t) % v3
  /\ (a - t) / (&1 - t) + b / (&1 - t) + c / (&1 - t) = &1  `]);;


(* ============= *)

let xxii = MATCH_MP REAL_LT_RSQRT (REAL_ARITH `(&2 * #1.255) pow 2 < &8`);;


let import_le = prove( `!x y s.
     x IN s /\
     dist (x,y) < t0 /\
     ~(y IN UNIONS {aff_ge {x} {w1, w2} | w1,w2 | {x, w1, w2} IN barrier s})
     ==> ~obstructed x y s`,
REWRITE_TAC[ MESON[]` a /\ b /\ ~c ==> ~d <=> a /\ b /\ d ==> c`] THEN 
REWRITE_TAC[ obstructed ; barrier] THEN 
REWRITE_TAC[ IN_ELIM_THM] THEN 
ONCE_REWRITE_TAC[ MESON[]` (? a . P a ) <=> ( ? a. ( x IN a \/ ~( x IN a )) /\ P a)`] THEN  
REWRITE_TAC[ MESON[] ` (?b. aa b /\ (?u v w. P u v w /\ b = {u, v, w}) /\ cc b) <=>
     (?u v w. aa {u, v, w} /\ P u v w /\ cc {u, v, w}) `] THEN 
REWRITE_TAC[ MESON[]` (x IN {v1, v2, v3} \/ ~(x IN {v1, v2, v3})) /\ a <=>
  x IN {v1, v2, v3} /\ a \/ ~(x IN {v1, v2, v3}) /\ a `] THEN 
ONCE_REWRITE_TAC[ MESON[]`(? a c b. P a b c \/ Q a b c ) 
  <=> ( ? a b c. Q a b c \/ P a b c) `] THEN 
ONCE_REWRITE_TAC[ MESON[]` aa /\ (?a c b. P a b c \/ Q a b c) <=>
     aa /\ (?a b c. P a b c /\ aa \/ Q a b c) `] THEN PHA THEN 
REWRITE_TAC[conv0_2] THEN 
REWRITE_TAC[ MESON[]` (?a. P a \/ Q a) <=> (?a. P a) \/ (?a. Q a)`] THEN 
NHANH (MATCH_MP (MESON[]` (! a b c. P a b c) ==> P a b c `) OCTO23) THEN 
NHANH (MATCH_MP (MESON[]` (! x y a b c. P x y a b c ) ==> P x y a b c `)
  MEETING_CONDITION) THEN 
ONCE_REWRITE_TAC[MESON[]` v1 /\ v2/\ v3 /\ v4 /\ v5/\ v6 /\ v7 /\ las
  <=> ( v1 /\ v2/\ v3 /\ v4 /\ v5/\ v6 /\ v7)  /\ las`] THEN 
NHANH (MATCH_MP (MESON[]` (! a b c d e. P a b c d e ) ==> P a b c  d e`) tarski_FFSXOWD ) THEN 
PHA THEN 
REWRITE_TAC[ MESON[]` normball x #1.255 INTER conv {v1, v2, v3} = {} /\ a 
  <=> a /\ normball x #1.255 INTER conv {v1, v2, v3} = {} `] THEN 
PHA THEN SIMP_TAC[ MESON[]` ~ a /\ a <=> F `] THEN 
REPEAT GEN_TAC THEN MATCH_MP_TAC (MESON[]` (c ==> l) ==> a /\ b/\ c==> l`) THEN 
REWRITE_TAC[SET_RULE ` x IN {a, b, c} <=> x = a \/ x = b \/ x = c `] THEN 
MATCH_MP_TAC (MESON[]` (!a b c. P a b c <=> P b a c) /\
     ((?a b c. (x = a \/ x = c) /\ P a b c) ==> las)
     ==> (?a b c. (x = a \/ x = b \/ x = c) /\ P a b c)
     ==> las`) THEN 
SIMP_TAC[ MESON[SET_RULE ` { a, b, c} = { b , a, c} ` ]` !v1 v2 v3.
         (quasi_tri {v1, v2, v3} s \/
          (?v4. {v1, v2, v3} UNION {v4} IN Q_SYS s)) /\
         ~(conv0 {x, y} INTER conv_trg {v1, v2, v3} = {}) <=>
         (quasi_tri {v2, v1, v3} s \/
          (?v4. {v2, v1, v3} UNION {v4} IN Q_SYS s)) /\
         ~(conv0 {x, y} INTER conv_trg {v2, v1, v3} = {})`] THEN 
MATCH_MP_TAC (MESON[]` (!a b c. P a b c <=> P c b a ) /\
     ((?a b c. (x = a ) /\ P a b c) ==> las)
     ==> (?a b c. (x = a \/ x = c) /\ P a b c)
     ==> las`) THEN 
SIMP_TAC[ MESON[SET_RULE ` { a, b, c} = {c ,  b , a} ` ]` !v1 v2 v3.
      (quasi_tri {v1, v2, v3} s \/ (?v4. {v1, v2, v3} UNION {v4} IN Q_SYS s)) /\
      ~(conv0 {x, y} INTER conv_trg {v1, v2, v3} = {}) <=>
      (quasi_tri {v3, v2, v1} s \/ (?v4. {v3, v2, v1} UNION {v4} IN Q_SYS s)) /\
      ~(conv0 {x, y} INTER conv_trg {v3, v2, v1} = {})`] THEN 
PURE_ONCE_REWRITE_TAC[ MESON[]` (?v1 v2 v3. x = v1 /\ P x v1 v2 v3) <=>
     (?v1 v2 v3. x = v1 /\ P x x v2 v3) `] THEN 
NHANH (MATCH_MP (MESON[]` (! a b c d. P a b c d) ==> P a b c d`) IN_AFF_GE_CON) THEN 
MATCH_MP_TAC (MESON[]` ((? v1 v2 v3.  P v1 v2 v3 /\ PP v1 v2 v3 ) 
  ==> last )
  ==> (? v1 v2 v3. a v1 /\ P v1 v2 v3 /\ b v2 v3 /\ PP v1 v2 v3 ) 
  ==> last `) THEN 
REWRITE_TAC[ IN_UNIONS; IN_ELIM_THM] THEN 
MESON_TAC[]);;






(* ======================== end im_le_82.ml =============================== *)

let lemma_of_lemma82 = prove (` ! (x:real^3) (v0:real^3) s Z. centered_pac s v0 /\ Z = UNIONS {e_plane u v | u IN near2t0 v0 s /\ v IN near2t0 v0 s} /\
 x IN normball v0 t0 DIFF Z
 ==> (?w. w IN near2t0 v0 s /\ x IN voronoi w s)`, REPEAT GEN_TAC THEN REWRITE_TAC[centered_pac] THEN 
REWRITE_TAC[ SET_RULE `packing s /\ v0 IN s <=> packing s /\ v0 IN s /\ ~(s={})`] THEN 
REWRITE_TAC[MESON[exists_min_dist] ` (packing s /\ v0 IN s /\ ~(s = {})) /\
 Z = UNIONS {e_plane u v | u IN near2t0 v0 s /\ v IN near2t0 v0 s} /\
 x IN normball v0 t0 DIFF Z  <=>(packing s /\ v0 IN s /\ ~(s = {})) /\
 Z = UNIONS {e_plane u v | u IN near2t0 v0 s /\ v IN near2t0 v0 s} /\
 x IN normball v0 t0 DIFF Z /\ min_dist x s `] THEN 
SIMP_TAC[normball; min_dist] THEN 
REWRITE_TAC[SET_RULE` x IN a DIFF b <=> x IN a /\ ~( x IN b )`] THEN 
REWRITE_TAC[SET_RULE ` x IN { x | P x } <=> P x `] THEN PHA THEN 
REWRITE_TAC[MESON[]` dist (x,v0) < t0 /\
 ~(x IN Z) /\
 ((?u. u IN s /\ (!w. w IN s /\ ~(u = w) ==> dist (u,x) < dist (w,x))) \/
  (?u v.
       u IN s /\
       v IN s /\
       ~(u = v) /\
       dist (u,x) = dist (v,x) /\
       (!w. w IN s ==> dist (u,x) <= dist (w,x)))) <=>
  dist (x,v0) < t0 /\
 ~(x IN Z) /\
 ((?u. u IN s /\ (!w. w IN s /\ ~(u = w) ==> dist (u,x) < dist (w,x))) \/
  ( ~(x IN Z) /\ (?u v.
       u IN s /\
       v IN s /\
       ~(u = v) /\
       dist (u,x) = dist (v,x) /\
       (!w. w IN s ==> dist (u,x) <= dist (w,x)) /\ dist (x,v0) < t0 ))) `] THEN 
REWRITE_TAC[MESON[DIST_TRIANGLE] ` v0 IN s /\
     ~(s = {}) /\
     Z = UNIONS {e_plane u v | u IN near2t0 v0 s /\ v IN near2t0 v0 s} /\
     dist (x,v0) < t0 /\
     ~(x IN Z) /\
     ((?u. u IN s /\ (!w. w IN s /\ ~(u = w) ==> dist (u,x) < dist (w,x))) \/
      ~(x IN Z) /\
      (?u v.
           u IN s /\
           v IN s /\
           ~(u = v) /\
           dist (u,x) = dist (v,x) /\
           (!w. w IN s ==> dist (u,x) <= dist (w,x)) /\
           dist (x,v0) < t0)) <=>
     v0 IN s /\
     ~(s = {}) /\
     Z = UNIONS {e_plane u v | u IN near2t0 v0 s /\ v IN near2t0 v0 s} /\
     dist (x,v0) < t0 /\
     ~(x IN Z) /\
     ((?u. u IN s /\ (!w. w IN s /\ ~(u = w) ==> dist (u,x) < dist (w,x))) \/
      ~(x IN Z) /\
      (?u v.
           u IN s /\
           dist (u,v0) <= dist (u,x) + dist (x,v0) /\
           dist (u,x) <= dist (v0,x) /\
           v IN s /\
           dist (v,v0) <= dist (v,x) + dist (x,v0) /\
           dist (v,x) <= dist (v0,x) /\
           ~(u = v) /\
           dist (u,x) = dist (v,x) /\
           (!w. w IN s ==> dist (u,x) <= dist (w,x)) /\
           dist (x,v0) < t0)) `] THEN 
REWRITE_TAC[MESON[] ` u IN s /\
     dist (u,v0) <= dist (u,x) + dist (x,v0) /\
     dist (u,x) <= dist (v0,x) /\
     v IN s /\
     dist (v,v0) <= dist (v,x) + dist (x,v0) /\
     dist (v,x) <= dist (v0,x) /\
     ~(u = v) /\
     dist (u,x) = dist (v,x) /\
     (!w. w IN s ==> dist (u,x) <= dist (w,x)) /\
     dist (x,v0) < t0 <=>
     u IN s /\
     (dist (u,v0) <= dist (u,x) + dist (x,v0) /\
      dist (u,x) <= dist (v0,x) /\
      dist (x,v0) < t0) /\
     v IN s /\
     (dist (v,v0) <= dist (v,x) + dist (x,v0) /\
      dist (v,x) <= dist (v0,x) /\
      dist (x,v0) < t0) /\
     ~(u = v) /\
     dist (u,x) = dist (v,x) /\
     (!w. w IN s ==> dist (u,x) <= dist (w,x))`] THEN 
SIMP_TAC[DIST_SYM] THEN 
REWRITE_TAC[REAL_ARITH ` dist (u,v0) <= dist (u,x) + dist (v0,x) /\
        dist (u,x) <= dist (v0,x) /\
        dist (v0,x) < t0
  <=> dist (u,v0) <= dist (u,x) + dist (v0,x) /\
        dist (u,x) <= dist (v0,x) /\
        dist (v0,x) < t0 /\ dist(u, v0) < &2 * t0 `] THEN 
REWRITE_TAC[ MESON[] ` a /\ b /\c/\ d /\ e ==> f <=> a/\b/\c/\d ==> e ==> f `] THEN SIMP_TAC[] THEN 
REWRITE_TAC[ IN_UNIONS; e_plane; near2t0] THEN 
REWRITE_TAC[SET_RULE ` x IN { x | P x } <=> P x `] THEN 
REWRITE_TAC[IN_ELIM_THM] THEN REWRITE_TAC[ MESON[] ` (?t. (?u v.
                 ((u IN s /\ dist (v0,u) < &2 * t0) /\
                  v IN s /\
                  dist (v0,v) < &2 * t0) /\
                 t = e_plane u v) /\
            x IN t ) 
  <=> (?u v.
                 ((u IN s /\ dist (v0,u) < &2 * t0) /\
                  v IN s /\
                  dist (v0,v) < &2 * t0) /\
                 x IN e_plane u v) `] THEN 
REWRITE_TAC[ SET_RULE ` x IN e_plane u v <=> e_plane u v x `; e_plane] THEN 
PHA THEN SIMP_TAC[ MESON[DIST_SYM] ` ~(?u v.
            u IN s /\
            dist (v0,u) < &2 * t0 /\
            v IN s /\
            dist (v0,v) < &2 * t0 /\
            ~(u = v) /\
            dist (u,x) = dist (v,x)) /\
      (?u v.
           u IN s /\
           dist (u,v0) <= dist (u,x) + dist (v0,x) /\
           dist (u,x) <= dist (v0,x) /\
           dist (v0,x) < t0 /\
           dist (u,v0) < &2 * t0 /\
           v IN s /\
           dist (v,v0) <= dist (v,x) + dist (v0,x) /\
           dist (v,x) <= dist (v0,x) /\
           dist (v0,x) < t0 /\
           dist (v,v0) < &2 * t0 /\
           ~(u = v) /\
           dist (u,x) = dist (v,x) /\
           (!w. w IN s ==> dist (u,x) <= dist (w,x))) <=> F `] THEN 
REWRITE_TAC[voronoi] THEN REWRITE_TAC[ SET_RULE ` x IN { x | P x } <=> P x `] THEN 
REWRITE_TAC[ MESON[] ` dist (v0,x) < t0 /\
     ~(?u v.
           u IN s /\
           dist (v0,u) < &2 * t0 /\
           v IN s /\
           dist (v0,v) < &2 * t0 /\
           ~(u = v) /\
           dist (u,x) = dist (v,x)) /\
     (?u. u IN s /\ (!w. w IN s /\ ~(u = w) ==> dist (u,x) < dist (w,x)))
  <=> dist (v0,x) < t0 /\
     ~(?u v.
           u IN s /\
           dist (v0,u) < &2 * t0 /\
           v IN s /\
           dist (v0,v) < &2 * t0 /\
           ~(u = v) /\
           dist (u,x) = dist (v,x)) /\
     (?u. u IN s /\dist (v0,x) < t0  /\  (!w. w IN s /\ ~(u = w) ==> dist (u,x) < dist (w,x)))`] THEN 
REWRITE_TAC[ MESON[DIST_TRIANGLE] `(?u. u IN s /\
          dist (v0,x) < t0 /\
          (!w. w IN s /\ ~(u = w) ==> dist (u,x) < dist (w,x))) <=>
     (?u. u IN s /\
          dist (v0,x) < t0 /\
          dist (u,v0) <= dist (u,x) + dist (x,v0) /\
          (!w. w IN s /\ ~(u = w) ==> dist (u,x) < dist (w,x))) `] THEN 
REWRITE_TAC[ MESON[] ` ( a ==> b==> c <=> a/\b ==> c ) `] THEN PHA THEN 
ONCE_REWRITE_TAC[ MESON[] ` a /\ b /\ c ==> d <=> a/\c /\b ==> d `] THEN PHA THEN 
ONCE_REWRITE_TAC[MESON[] ` !P. (?u. P u) /\ v0 IN s <=>
         ((?u. u = v0 /\ P u) \/ (?u. ~(u = v0) /\ P u)) /\ v0 IN s`] THEN 
REWRITE_TAC[t0] THEN ONCE_REWRITE_TAC[MESON[ DIST_REFL; REAL_ARITH ` &0 < &2 * #1.255 ` ] ` u = v0 /\ las  <=> u = v0  /\ dist(u,v0 ) < &2 * #1.255 /\ las `] THEN 
REWRITE_TAC[ MESON[] ` ((?u. u = v0 /\
           dist (u,v0) < &2 * #1.255 /\
           u IN s /\
           dist (v0,x) < #1.255 /\
           dist (u,v0) <= dist (u,x) + dist (x,v0) /\
           (!w. w IN s /\ ~(u = w) ==> dist (u,x) < dist (w,x))) \/
      (?u. ~(u = v0) /\
           u IN s /\
           dist (v0,x) < #1.255 /\
           dist (u,v0) <= dist (u,x) + dist (x,v0) /\
           (!w. w IN s /\ ~(u = w) ==> dist (u,x) < dist (w,x)))) /\
     v0 IN s <=>
     ((?u. u = v0 /\
           dist (u,v0) < &2 * #1.255 /\
           u IN s /\
           v0 IN s /\
           dist (v0,x) < #1.255 /\
           dist (u,v0) <= dist (u,x) + dist (x,v0) /\
           (!w. w IN s /\ ~(u = w) ==> dist (u,x) < dist (w,x))) \/
      (?u. ~(u = v0) /\
           u IN s /\
           v0 IN s /\
           dist (v0,x) < #1.255 /\
           dist (u,v0) <= dist (u,x) + dist (x,v0) /\
           (!w. w IN s /\ ~(u = w) ==> dist (u,x) < dist (w,x)))) /\
     v0 IN s `] THEN REWRITE_TAC[ MESON[] ` ~(u = v0) /\
     u IN s /\
     v0 IN s /\
     dist (v0,x) < #1.255 /\
     dist (u,v0) <= dist (u,x) + dist (x,v0) /\
     (!w. w IN s /\ ~(u = w) ==> dist (u,x) < dist (w,x)) <=>
     ~(u = v0) /\
    
     u IN s /\
     v0 IN s /\ (  dist (u,x) < dist (v0,x) /\
     dist (v0,x) < #1.255 /\
     dist (u,v0) <= dist (u,x) + dist (x,v0) ) /\
     (!w. w IN s /\ ~(u = w) ==> dist (u,x) < dist (w,x)) `] THEN SIMP_TAC[DIST_SYM] THEN 
PURE_ONCE_REWRITE_TAC[ REAL_ARITH `  ( dist (u,x) < dist (v0,x) /\
     dist (v0,x) < #1.255 /\
     dist (u,v0) <= dist (u,x) + dist (v0,x))  <=>
     (dist (u,x) < dist (v0,x) /\
      dist (v0,x) < #1.255 /\
      dist (u,v0) <= dist (u,x) + dist (v0,x)) /\
     dist (u,v0) < &2 * #1.255 ` ] THEN 
MATCH_MP_TAC (MESON[] `((?u. u = v0 /\
           dist (u,v0) < &2 * #1.255 /\
           u IN s /\
           v0 IN s /\
           dist (v0,x) < #1.255 /\
           dist (u,v0) <= dist (u,x) + dist (v0,x) /\
           (!w. w IN s /\ ~(u = w) ==> dist (u,x) < dist (w,x))) \/
      (?u. ~(u = v0) /\
           u IN s /\
           v0 IN s /\
           ((dist (u,x) < dist (v0,x) /\
             dist (v0,x) < #1.255 /\
             dist (u,v0) <= dist (u,x) + dist (v0,x)) /\
            dist (u,v0) < &2 * #1.255) /\
           (!w. w IN s /\ ~(u = w) ==> dist (u,x) < dist (w,x)))
      ==> (?w. w IN s /\
               dist (v0,w) < &2 * #1.255 /\
               (!w'. s w' /\ ~(w' = w) ==> dist (w,x) < dist (w',x))))
     ==> packing s /\
         ~(s = {}) /\
         Z =
         UNIONS
         {e_plane u v | u IN s /\
                        dist (u,v0) < &2 * #1.255 /\
                        v IN s /\
                        dist (v,v0) < &2 * #1.255} /\
         dist (v0,x) < #1.255 /\
         ~(?u v.
               u IN s /\
               dist (u,v0) < &2 * #1.255 /\
               v IN s /\
               dist (v,v0) < &2 * #1.255 /\
               ~(u = v) /\
               dist (u,x) = dist (v,x)) /\
         ((?u. u = v0 /\
               dist (u,v0) < &2 * #1.255 /\
               u IN s /\
               v0 IN s /\
               dist (v0,x) < #1.255 /\
               dist (u,v0) <= dist (u,x) + dist (v0,x) /\
               (!w. w IN s /\ ~(u = w) ==> dist (u,x) < dist (w,x))) \/
          (?u. ~(u = v0) /\
               u IN s /\
               v0 IN s /\
               ((dist (u,x) < dist (v0,x) /\
                 dist (v0,x) < #1.255 /\
                 dist (u,v0) <= dist (u,x) + dist (v0,x)) /\
                dist (u,v0) < &2 * #1.255) /\
               (!w. w IN s /\ ~(u = w) ==> dist (u,x) < dist (w,x)))) /\
         v0 IN s
     ==> (?w. w IN s /\
              dist (v0,w) < &2 * #1.255 /\
              (!w'. s w' /\ ~(w' = w) ==> dist (w,x) < dist (w',x))) `) THEN 
MESON_TAC [DIST_SYM; SET_RULE ` ! x s. s x <=> x IN s ` ]);;




(* lemma 8.2 *)





let le1_82 = prove (`!s v0 Y.
     centered_pac s v0 /\
     w IN near2t0 v0 s /\
     Y =
     UNIONS
     {aff_ge {w} {w1, w2} | w IN near2t0 v0 s /\ {w, w1, w2} IN barrier s}
     ==> UNIONS {aff_ge {w} {w1, w2} | w1,w2 | {w, w1, w2} IN barrier s} SUBSET
         Y`, SIMP_TAC[] THEN SET_TAC[]);;



let rhand_subset_lhand = prove (` ! (s:real^3 -> bool) (v0:real^3) Z Y.
     centered_pac s v0 /\
     Y =
     UNIONS
     {aff_ge {w} {w1, w2} | w IN near2t0 v0 s /\ {w, w1, w2} IN barrier s} /\
     Z = UNIONS {e_plane u v | u IN near2t0 v0 s /\ v IN near2t0 v0 s}
     ==> 
         normball v0 t0 INTER voronoi v0 s DIFF (Y UNION Z) SUBSET 
 normball v0 t0 INTER VC v0 s DIFF (Y UNION Z)`, REWRITE_TAC[ SET_RULE ` a INTER b DIFF c SUBSET a INTER d DIFF c <=>
     (!x. x IN a INTER b DIFF c ==> x IN d) ` ] THEN 
REWRITE_TAC[ GSYM (     MESON[centered_pac; le1_82; prove (` ! x s. centered_pac s x ==> x IN near2t0 x s `, REWRITE_TAC[ 
  centered_pac; near2t0] THEN REWRITE_TAC[ MESON [DIST_REFL; t0; REAL_ARITH ` &0 < &2 * #1.255 `] `
  packing s /\ v0 IN s <=> packing s /\ v0 IN s /\ dist (v0,v0) < &2 * t0`] THEN 
  SET_TAC[] ) ] ` !s v0 Z Y.
   centered_pac s v0 /\
     Y =
     UNIONS
     {aff_ge {w} {w1, w2} | w IN near2t0 v0 s /\ {w, w1, w2} IN barrier s} /\
     Z = UNIONS {e_plane u v | u IN near2t0 v0 s /\ v IN near2t0 v0 s} /\
     UNIONS {aff_ge {v0} {w1, w2} | w1,w2 | {v0, w1, w2} IN barrier s} SUBSET
     Y
     ==> last <=>
     centered_pac s v0 /\
     Y =
     UNIONS
     {aff_ge {w} {w1, w2} | w IN near2t0 v0 s /\ {w, w1, w2} IN barrier s} /\
     Z = UNIONS {e_plane u v | u IN near2t0 v0 s /\ v IN near2t0 v0 s}
     ==> last `)] THEN 
REWRITE_TAC[SET_RULE ` x IN a INTER b DIFF c <=> x IN a /\ x IN b /\ ~( x IN c )`] THEN 
REWRITE_TAC[ MESON[] ` centered_pac s v0 /\
     Y =
     UNIONS
     {aff_ge {w} {w1, w2} | w IN near2t0 v0 s /\ {w, w1, w2} IN barrier s} /\
     Z = UNIONS {e_plane u v | u IN near2t0 v0 s /\ v IN near2t0 v0 s} /\
     UNIONS {aff_ge {v0} {w1, w2} | w1,w2 | {v0, w1, w2} IN barrier s} SUBSET
     Y
     ==> (!x. x IN normball v0 t0 /\ x IN voronoi v0 s /\ ~(x IN Y UNION Z)
              ==> x IN VC v0 s) <=>
     centered_pac s v0 /\
     Y =
     UNIONS
     {aff_ge {w} {w1, w2} | w IN near2t0 v0 s /\ {w, w1, w2} IN barrier s} /\
     Z = UNIONS {e_plane u v | u IN near2t0 v0 s /\ v IN near2t0 v0 s} /\
     UNIONS {aff_ge {v0} {w1, w2} | w1,w2 | {v0, w1, w2} IN barrier s} SUBSET
     Y
     ==> (!x. x IN normball v0 t0 /\
              x IN voronoi v0 s /\
              ~(x IN Y UNION Z) /\
              UNIONS
              {aff_ge {v0} {w1, w2} | w1,w2 | {v0, w1, w2} IN barrier s} SUBSET
              Y
              ==> x IN VC v0 s) `] THEN 
ONCE_REWRITE_TAC[ SET_RULE ` ~(x IN Y UNION Z) /\
     UNIONS {aff_ge {v0} {w1, w2} | w1,w2 | {v0, w1, w2} IN barrier s} SUBSET
     Y <=>
     ~(x IN
       UNIONS {aff_ge {v0} {w1, w2} | w1,w2 | {v0, w1, w2} IN barrier s}) /\
     ~(x IN Y UNION Z) /\
     UNIONS {aff_ge {v0} {w1, w2} | w1,w2 | {v0, w1, w2} IN barrier s} SUBSET
     Y `] THEN REWRITE_TAC[ centered_pac ] THEN 
REWRITE_TAC[ MESON[] ` (packing s /\ v0 IN s) /\
     Y =
     UNIONS
     {aff_ge {w} {w1, w2} | w IN near2t0 v0 s /\ {w, w1, w2} IN barrier s} /\
     Z = UNIONS {e_plane u v | u IN near2t0 v0 s /\ v IN near2t0 v0 s} /\
     UNIONS {aff_ge {v0} {w1, w2} | w1,w2 | {v0, w1, w2} IN barrier s} SUBSET
     Y
     ==> (!x. x IN normball v0 t0 /\
              x IN voronoi v0 s /\
              ~(x IN
                UNIONS
                {aff_ge {v0} {w1, w2} | w1,w2 | {v0, w1, w2} IN barrier s}) /\
              ~(x IN Y UNION Z) /\
              UNIONS
              {aff_ge {v0} {w1, w2} | w1,w2 | {v0, w1, w2} IN barrier s} SUBSET
              Y
              ==> x IN VC v0 s) <=>
     (packing s /\ v0 IN s) /\
     Y =
     UNIONS
     {aff_ge {w} {w1, w2} | w IN near2t0 v0 s /\ {w, w1, w2} IN barrier s} /\
     Z = UNIONS {e_plane u v | u IN near2t0 v0 s /\ v IN near2t0 v0 s} /\
     UNIONS {aff_ge {v0} {w1, w2} | w1,w2 | {v0, w1, w2} IN barrier s} SUBSET
     Y
     ==> (!x. v0 IN s /\
              x IN normball v0 t0 /\
              x IN voronoi v0 s /\
              ~(x IN
                UNIONS
                {aff_ge {v0} {w1, w2} | w1,w2 | {v0, w1, w2} IN barrier s}) /\
              ~(x IN Y UNION Z) /\
              UNIONS
              {aff_ge {v0} {w1, w2} | w1,w2 | {v0, w1, w2} IN barrier s} SUBSET
              Y
              ==> x IN VC v0 s) `] THEN 
REPEAT GEN_TAC THEN DISCH_TAC THEN REWRITE_TAC[normball] THEN 
REWRITE_TAC[ SET_RULE ` z IN { x | P x } <=> P z `] THEN 
REWRITE_TAC[ voronoi; VC; lambda_x; d3 ] THEN 
REWRITE_TAC[ SET_RULE ` x IN { x | P x } <=> P x `] THEN 
REWRITE_TAC[MESON[DIST_SYM ; import_le ] ` v0 IN s /\
     dist (x,v0) < t0 /\
     (!w. s w /\ ~(w = v0) ==> dist (x,v0) < dist (x,w)) /\
     ~(x IN
       UNIONS {aff_ge {v0} {w1, w2} | w1,w2 | {v0, w1, w2} IN barrier s}) /\
     ~(x IN Y UNION Z) /\
     UNIONS {aff_ge {v0} {w1, w2} | w1,w2 | {v0, w1, w2} IN barrier s} SUBSET
     Y <=>
     v0 IN s /\
     dist (x,v0) < t0 /\
     (!w. s w /\ ~(w = v0) ==> dist (x,v0) < dist (x,w)) /\
     ~(x IN
       UNIONS {aff_ge {v0} {w1, w2} | w1,w2 | {v0, w1, w2} IN barrier s}) /\
     ~(x IN Y UNION Z) /\
     UNIONS {aff_ge {v0} {w1, w2} | w1,w2 | {v0, w1, w2} IN barrier s} SUBSET
     Y /\
     ~obstructed v0 x s `] THEN 
ONCE_REWRITE_TAC[MESON[t0; REAL_ARITH ` #1.255 < &2 /\ (! a b (c:real). a < b 
/\ b < c ==> a < c ) `; DIST_SYM ]` dist ( x, v0 ) < t0 <=> dist ( x, v0 ) < t0 /\
 dist ( v0, x) < &2 `] THEN 
SIMP_TAC[ DIST_SYM ] THEN 
MESON_TAC[ SET_RULE ` ! s x. s x <=> x IN s `]);;



(* ++++++++++++++++++++++++++++ *)




let lhand_subset_rhand = prove(`  ! (s:real^3 -> bool) (v0:real^3) Z Y.
     centered_pac s v0 /\
     Y =
     UNIONS
     {aff_ge {w} {w1, w2} | w IN near2t0 v0 s /\ {w, w1, w2} IN barrier s} /\
     Z = UNIONS {e_plane u v | u IN near2t0 v0 s /\ v IN near2t0 v0 s}
     ==> normball v0 t0 INTER VC v0 s DIFF (Y UNION Z) SUBSET 
         normball v0 t0 INTER voronoi v0 s DIFF (Y UNION Z)`,
REWRITE_TAC[ SET_RULE ` a INTER b DIFF c SUBSET a INTER d DIFF c <=>
     a INTER b DIFF c DIFF d = {} `] THEN 
REWRITE_TAC[ SET_RULE ` a = {} <=> (! x. ~ (x IN a))`] THEN 
REWRITE_TAC[ SET_RULE` x IN a DIFF b <=> x IN a /\ ~( x IN b ) `] THEN 
REWRITE_TAC[ SET_RULE ` x IN a INTER b <=> x IN a /\ x IN b `] THEN PHA THEN 
REWRITE_TAC[ SET_RULE ` x IN normball v0 t0 /\ x IN VC v0 s /\ ~(x IN Y UNION Z) /\ P x  <=>
     x IN normball v0 t0 DIFF Z /\ x IN VC v0 s /\ ~(x IN Y UNION Z) /\ P x  `] THEN 
REWRITE_TAC[MESON[lemma_of_lemma82]`
  centered_pac s v0 /\
     Y =
     UNIONS
     {aff_ge {w} {w1, w2} | w IN near2t0 v0 s /\ {w, w1, w2} IN barrier s} /\
     Z = UNIONS {e_plane u v | u IN near2t0 v0 s /\ v IN near2t0 v0 s}
     ==> (!x. ~(x IN normball v0 t0 DIFF Z /\
                x IN VC v0 s /\
                ~(x IN Y UNION Z) /\
                ~(x IN voronoi v0 s))) <=>
     centered_pac s v0 /\
     Y =
     UNIONS
     {aff_ge {w} {w1, w2} | w IN near2t0 v0 s /\ {w, w1, w2} IN barrier s} /\
     Z = UNIONS {e_plane u v | u IN near2t0 v0 s /\ v IN near2t0 v0 s}
     ==> (!x. ~(x IN normball v0 t0 DIFF Z /\
                (?w. w IN near2t0 v0 s /\ x IN voronoi w s) /\
                x IN VC v0 s /\
                ~(x IN Y UNION Z) /\
                ~(x IN voronoi v0 s))) `] THEN 
REWRITE_TAC[ MESON[] ` 
  (?w. w IN near2t0 v0 s /\ x IN voronoi w s) /\
     x IN VC v0 s /\
     ~(x IN Y UNION Z) /\
     ~(x IN voronoi v0 s) <=>
     (?w. w IN near2t0 v0 s /\ x IN voronoi w s /\ ~(w = v0)) /\
     x IN VC v0 s /\
     ~(x IN Y UNION Z) /\
     ~(x IN voronoi v0 s) `] THEN 
REWRITE_TAC[ MESON[near2t0] ` 
  (?w. w IN near2t0 v0 s /\ x IN voronoi w s /\ ~(w = v0)) <=>
     (?w. w IN {x | x IN s /\ dist (v0,x) < &2 * t0} /\
          x IN voronoi w s /\
          ~(w = v0)) `] THEN 
REWRITE_TAC[ SET_RULE` a IN { a | p a } <=> p a `] THEN 
REWRITE_TAC[ voronoi; lambda_x] THEN 
REWRITE_TAC[ SET_RULE ` x IN { v | P v } <=> P x `] THEN PHA THEN 
REWRITE_TAC[ MESON[] ` a /\ b /\ d ==> c <=> b /\ d ==> a ==> c `] THEN 
REPEAT GEN_TAC THEN DISCH_TAC THEN 
REWRITE_TAC[centered_pac] THEN 
MATCH_MP_TAC (MESON[]` (a /\ b ==> (!x. ~b \/ P x)) ==> a /\ b ==> (!x. P x)`) THEN 
REWRITE_TAC[ MESON[] ` ~(v0 IN s) \/ ~(x IN normball v0 t0 DIFF Z /\ last) <=>
     ~(v0 IN s /\ x IN normball v0 t0 DIFF Z /\ last)`] THEN 
REWRITE_TAC[ MESON[]` 
  v0 IN s /\
     x IN normball v0 t0 DIFF Z /\
     (?w. w IN s /\
          dist (v0,w) < &2 * t0 /\
          (!w'. s w' /\ ~(w' = w) ==> dist (x,w) < dist (x,w')) /\
          ~(w = v0)) /\
     last <=>
     x IN normball v0 t0 DIFF Z /\
     (?w. w IN s /\
          v0 IN s /\
          dist (v0,w) < &2 * t0 /\
          (!w'. s w' /\ ~(w' = w) ==> dist (x,w) < dist (x,w')) /\
          ~(w = v0)) /\
     last`] THEN 
REWRITE_TAC[ MESON[ SET_RULE` x IN s <=> s x `] `
  (?w. w IN s /\
          v0 IN s /\
          dist (v0,w) < &2 * t0 /\
          (!w'. s w' /\ ~(w' = w) ==> dist (x,w) < dist (x,w')) /\
          ~(w = v0)) <=>
     (?w. w IN s /\
          v0 IN s /\
          dist (x,w) < dist (x,v0) /\
          dist (v0,w) < &2 * t0 /\
          (!w'. s w' /\ ~(w' = w) ==> dist (x,w) < dist (x,w')) /\
          ~(w = v0)) `] THEN 
REWRITE_TAC[ SET_RULE ` x IN a DIFF b <=> x IN a /\ ~ ( x IN b ) `] THEN 
REWRITE_TAC[ MESON[normball ; SET_RULE `x IN { x | p x } <=> p x `] ` x IN normball v0 t0 
  <=> dist (x,v0) < t0 `] THEN 
REWRITE_TAC[ MESON[REAL_ARITH ` a < b /\ b < c ==> a < c `]`
  (dist (x,v0) < t0 /\ ~(x IN Z)) /\
            (?w. w IN s /\
                 v0 IN s /\
                 dist (x,w) < dist (x,v0) /\
                 dist (v0,w) < &2 * t0 /\
                 (!w'. s w' /\ ~(w' = w) ==> dist (x,w) < dist (x,w')) /\
                 ~(w = v0)) /\ las 
  <=> (dist (x,v0) < t0 /\ ~(x IN Z)) /\
            (?w. w IN s /\
                 v0 IN s /\ dist(x,w) < t0 /\
                 dist (x,w) < dist (x,v0) /\
                 dist (v0,w) < &2 * t0 /\
                 (!w'. s w' /\ ~(w' = w) ==> dist (x,w) < dist (x,w')) /\
                 ~(w = v0)) /\ las  `] THEN 
ASM_SIMP_TAC[] THEN PHA THEN 
REWRITE_TAC[ MESON[] ` a /\ b /\ c /\ d /\ las <=> (a /\ d ) /\ b /\ c /\ las `] THEN 
ONCE_REWRITE_TAC[ MESON[near2t0; SET_RULE ` x IN { x | p x } <=> p x ` ]` (w IN s /\ dist (v0,w) < &2 * t0) <=>
  w IN near2t0 v0 s /\ (w IN s /\ dist (v0,w) < &2 * t0) `] THEN 
REWRITE_TAC[ SET_RULE ` ~ ( x IN a UNION b) <=> ~( x IN a ) /\ ~ (x IN b)`] THEN PHA THEN 
 SIMP_TAC[MESON[] ` a /\ a /\ b <=> a /\ b `] THEN 
REWRITE_TAC[ MESON[] ` a/\ b /\ ( ? w. P w ) /\ la <=> b /\ ( ? w. a /\ P w ) /\ la `] THEN 
ONCE_REWRITE_TAC[  MESON[ SET_RULE ` w IN near2t0 v0 s
     ==> UNIONS {aff_ge {w} {w1, w2} | w1,w2 | {w, w1, w2} IN barrier s} SUBSET
         UNIONS
         {aff_ge {w} {w1, w2} | w IN near2t0 v0 s /\ {w, w1, w2} IN barrier s} `]
  `  w IN near2t0 v0 s /\
                 w IN s /\ last 
  <=> UNIONS {aff_ge {w} {w1, w2} | w1,w2 | {w, w1, w2} IN barrier s} SUBSET
         UNIONS
         {aff_ge {w} {w1, w2} | w IN near2t0 v0 s /\ {w, w1, w2} IN barrier s} /\
  w IN near2t0 v0 s /\
                 w IN s /\ last `] THEN 
REWRITE_TAC[ MESON[] ` a /\ b /\ c /\ d /\ last <=> a /\ b /\ ( c/\ d ) /\ last `] THEN 
REWRITE_TAC[ SET_RULE ` ~ ( x IN a ) /\ b SUBSET a <=> ~ ( x IN a )/\ ~( x IN b ) /\ b SUBSET a`] THEN PHA THEN 
REWRITE_TAC[ MESON[DIST_SYM; import_le ] ` dist (x,v0) < t0 /\
                 x IN VC v0 s /\
                 ~(x IN
                   UNIONS
                   {aff_ge {w} {w1, w2} | w IN near2t0 v0 s /\
                                          {w, w1, w2} IN barrier s}) /\
                 ~(x IN
                   UNIONS
                   {aff_ge {w} {w1, w2} | w1,w2 | {w, w1, w2} IN barrier s}) /\
                 UNIONS
                 {aff_ge {w} {w1, w2} | w1,w2 | {w, w1, w2} IN barrier s} SUBSET
                 UNIONS
                 {aff_ge {w} {w1, w2} | w IN near2t0 v0 s /\
                                        {w, w1, w2} IN barrier s} /\
                 w IN near2t0 v0 s /\
                 w IN s /\
                 dist (v0,w) < &2 * t0 /\
                 (!w'. s w' /\ ~(w' = w) ==> dist (x,w) < dist (x,w')) /\
                 dist (x,w) < t0 /\
                 dist (x,w) < dist (x,v0) /\
                 ~(w = v0)
  <=> dist (x,v0) < t0 /\
                 x IN VC v0 s /\
                 ~(x IN
                   UNIONS
                   {aff_ge {w} {w1, w2} | w IN near2t0 v0 s /\
                                          {w, w1, w2} IN barrier s}) /\
                 ~(x IN
                   UNIONS
                   {aff_ge {w} {w1, w2} | w1,w2 | {w, w1, w2} IN barrier s}) /\
                 UNIONS
                 {aff_ge {w} {w1, w2} | w1,w2 | {w, w1, w2} IN barrier s} SUBSET
                 UNIONS
                 {aff_ge {w} {w1, w2} | w IN near2t0 v0 s /\
                                        {w, w1, w2} IN barrier s} /\
                 w IN near2t0 v0 s /\
                 w IN s /\
                 dist (v0,w) < &2 * t0 /\
                 (!w'. s w' /\ ~(w' = w) ==> dist (x,w) < dist (x,w')) /\
                 dist (x,w) < t0 /\
                 dist (x,w) < dist (x,v0) /\
                 ~(w = v0) /\ ~obstructed w x s `] THEN 
ONCE_REWRITE_TAC[ MESON[t0; REAL_ARITH ` #1.255 < &2 /\ (! a b c. a < b /\ b < c ==> a < c )` ] `
  dist (x,w) < t0 /\ dist (x,w) < dist (x,v0) /\ last <=>
     dist (x,w) < &2 /\ dist (x,w) < t0 /\ dist (x,w) < dist (x,v0) /\ last`] THEN 
REWRITE_TAC[ MESON[ in_VC; DIST_SYM ] `w IN s /\
     dist (v0,w) < &2 * t0 /\
     (!w'. s w' /\ ~(w' = w) ==> dist (x,w) < dist (x,w')) /\
     dist (x,w) < &2 /\
     dist (x,w) < t0 /\
     dist (x,w) < dist (x,v0) /\
     ~(w = v0) /\
     ~obstructed w x s <=>
     dist (v0,w) < &2 * t0 /\
     dist (x,w) < t0 /\
     ~(w = v0) /\
     dist (x,w) < dist (x,v0) /\
     w IN s /\
     (!w'. s w' /\ ~(w' = w) ==> dist (x,w) < dist (x,w')) /\
     dist (x,w) < &2 /\
     ~obstructed w x s` ]  THEN 
REWRITE_TAC[ MESON[DIST_SYM] ` dist(x,w) < &2 <=> dist (w,x) < &2 `] THEN 
REWRITE_TAC[MESON[in_VC]` w IN s /\
                 (!w'. s w' /\ ~(w' = w) ==> dist (x,w) < dist (x,w')) /\
                 dist (w,x) < &2 /\
                 ~obstructed w x s
  <=> w IN s /\
                 (!w'. s w' /\ ~(w' = w) ==> dist (x,w) < dist (x,w')) /\
                 dist (w,x) < &2 /\
                 ~obstructed w x s /\ x IN VC w s ` ] THEN 
REWRITE_TAC[ MESON[]`  ~(w = v0) /\
                 dist (x,w) < dist (x,v0) /\
                 w IN s /\
                 (!w'. s w' /\ ~(w' = w) ==> dist (x,w) < dist (x,w')) /\
                 dist (w,x) < &2 /\
                 ~obstructed w x s /\
                 x IN VC w s <=> 
   
                 dist (x,w) < dist (x,v0) /\
                 w IN s /\
                 (!w'. s w' /\ ~(w' = w) ==> dist (x,w) < dist (x,w')) /\
                 dist (w,x) < &2 /\
                 ~obstructed w x s /\
               ~(w = v0) /\  x IN VC w s `] THEN 
ONCE_REWRITE_TAC[ MESON[]` dist (x,v0) < t0 /\
                 x IN VC v0 s /\ last <=> dist (x,v0) < t0  /\ last /\ x IN VC v0 s `]
THEN PHA THEN
ONCE_REWRITE_TAC[SET_RULE ` x IN a /\ x IN b <=> ~ ( a INTER b = {} ) /\ x IN a /\ x IN b `] THEN 
SIMP_TAC[ MESON[VC_DISJOINT ] `  ~(w = v0) /\
                 ~(VC w s INTER VC v0 s = {}) /\
                 x IN VC w s /\
                 x IN VC v0 s <=> F `]);;


(* +++++++++++++++++++++++++ *)

let lemma82_FOCUDTG = prove (`! (s:real^3 -> bool) (v0:real^3) Z Y.
     centered_pac s v0 /\
     Y =
     UNIONS
     {aff_ge {w} {w1, w2} | w IN near2t0 v0 s /\ {w, w1, w2} IN barrier s} /\
     Z = UNIONS {e_plane u v | u IN near2t0 v0 s /\ v IN near2t0 v0 s}
     ==> normball v0 t0 INTER VC v0 s DIFF (Y UNION Z) =
         normball v0 t0 INTER voronoi v0 s DIFF (Y UNION Z)`,
  REWRITE_TAC[ SET_RULE ` a ==> (b = c) <=> a ==>( b SUBSET c /\ c SUBSET b ) `]
  THEN MESON_TAC[ lhand_subset_rhand; rhand_subset_lhand] );;

(* ========= END LEMMA 8.2 ======== *)

let a_le_sub = SET_RULE ` w IN near2t0 v0 s
     ==> UNIONS {aff_ge {w} {w1, w2} | w1,w2 | {w, w1, w2} IN barrier s} SUBSET
         UNIONS
         {aff_ge {w} {w1, w2} | w IN near2t0 v0 s /\ {w, w1, w2} IN barrier s} `;;






















(* ============= BEGIN LEMMA 8.3 =========== *)


let barrier' = new_definition ` barrier' v0 s =
         {{a, b, c} | {a, b, c} IN barrier s /\ v0 IN {a, b, c} \/
                      (?q. diagonal a b q s /\ q IN Q_SYS s /\ c IN anchor_points a b s)} `;;


let lemma7_7_CXRHOVG = new_axiom `!s q1 q2 v w.
         {v, w} SUBSET q1 INTER q2 /\ quarter q2 s /\  diagonal v w q1 s /\ q1 IN Q_SYS s
         ==> q2 IN Q_SYS s `;;


let tarski_UMMNOJN = new_axiom` !x w v0 v1 v2.
         ~(conv {x, w} INTER cone v0 {v1, v2} = {}) /\
         dist (x,v0) < dist (x,v1) /\
         dist (x,v0) < dist (x,v2) /\
         dist (x,w) < dist (x,v0) /\
         (!xx yy.
              ~(xx = yy) /\ {xx, yy} SUBSET {v1, v2, v0}
              ==> &2 <= dist (xx,yy) /\ dist (xx,yy) <= sqrt (&8)) /\
         ((!aa bb.
               aa IN {v1, v2, v0} /\ bb IN {v1, v2, v0}
               ==> dist (aa,bb) <= #2.51) \/
          (?aa bb.
               {aa, bb} SUBSET {v1, v2, v0} /\
               #2.51 < dist (aa,bb) /\
               (!x y.
                    ~({x, y} = {aa, bb}) /\ {x, y} SUBSET {v1, v2, v0}
                    ==> dist (x,y) <= #2.51)))
         ==> (!a. a IN {v1, v2, v0} ==> dist (w,a) <= #2.51) /\
             ~(conv {v0, v1, v2} INTER conv0 {x, w} = {}) `;;

(* ================ *)


let TRIANGLE_IN_BARRIER' = prove( 
`!s v0 v1 v2.
     {v0, v1, v2} IN barrier' v0 s
     ==> (!xx yy.
              ~(xx = yy) /\ {xx, yy} SUBSET {v1, v2, v0}
              ==> &2 <= dist (xx,yy) /\ dist (xx,yy) <= sqrt (&8)) /\
  ((!aa bb.
               aa IN {v1, v2, v0} /\ bb IN {v1, v2, v0}
               ==> dist (aa,bb) <= #2.51) \/
          (?aa bb.
               {aa, bb} SUBSET {v1, v2, v0} /\
               #2.51 < dist (aa,bb) /\
               (!x y.
                    ~({x, y} = {aa, bb}) /\ {x, y} SUBSET {v1, v2, v0}
                    ==> dist (x,y) <= #2.51))) `,
REWRITE_TAC[ barrier'; IN_ELIM_THM] THEN MATCH_MP_TAC (MESON[] ` (!s v0 v1 v2.
          (?a b c.
               ({a, b, c} IN barrier s /\ v0 IN {a, b, c} \/
                (?q. diagonal a b q s /\ c IN anchor_points a b s)) /\
               {v0, v1, v2} = {a, b, c})
          ==> las s v0 v1 v2 )
     ==> (!s v0 v1 v2.
              (?a b c.
                   ({a, b, c} IN barrier s /\ v0 IN {a, b, c} \/
                    (?q. diagonal a b q s /\
                         q IN Q_SYS s /\
                         c IN anchor_points a b s)) /\
                   {v0, v1, v2} = {a, b, c})
              ==> las s v0 v1 v2 )`) THEN 
REWRITE_TAC[ MESON[]` ( ? a b c. ( P {a,b,c} \/ Q a b c ) /\ {v0, v1, v2} = {a, b, c} ) <=>
  P {v0, v1, v2} \/ ( ? a b c. Q a b c  /\ {v0, v1, v2} = {a, b, c} ) `] THEN 
REPEAT GEN_TAC THEN 
MATCH_MP_TAC (MESON[]` (a ==> l) /\ (c ==> l) ==> a /\ b \/ c ==> l`) THEN 
REWRITE_TAC[ TRIANGLE_IN_BARRIER] THEN 
NHANH (CUTHE4 DIA_OF_QUARTER) THEN 
REWRITE_TAC[ anchor_points; IN_ELIM_THM; anchor] THEN 
NHANH (MESON[diagonal; quarter] ` diagonal a b q s ==> packing s `) THEN PHA THEN 
REWRITE_TAC[ MESON[] ` packing s /\ aa /\ bb /\ cc /\ {c, a, b} SUBSET s /\ l 
  <=> ( packing s /\ {c, a, b} SUBSET s ) /\ aa /\ bb /\ cc /\ l `] THEN 
NHANH (CUTHE2 SUB_PACKING ) THEN 
REWRITE_TAC[GSYM d3] THEN 
REWRITE_TAC[ REAL_ARITH ` &2 * t0 <= d3 a b <=> d3 a b <= &2 * t0 /\ &2 * t0 = d3 a b  \/ &2 * t0 
  < d3 a b `; t0; REAL_ARITH ` &2 * #1.255 = #2.51 ` ] THEN 
REWRITE_TAC[ SET_RULE ` {x,y} SUBSET s <=> x IN s /\ y IN s`] THEN 
SIMP_TAC[ SET_RULE `!a b c.  {c, a, b} = {a, b, c}`] THEN PHA THEN 
REWRITE_TAC[ MESON[]` a /\ b /\ a /\ l <=> a /\ b /\ l `] THEN 
KHANANG THEN 
REWRITE_TAC[ MESON[]` (?q. P q /\ l1 \/ P q /\ l2) <=> (?q. P q) /\ (l1 \/ l2)`] THEN 
PHA THEN 
MATCH_MP_TAC (MESON[] ` ((? a b c. Q a b c) ==> l) ==> (? a b c. P a b c /\ Q a b c ) ==> l `) THEN 
REWRITE_TAC[ MESON[]` ( a \/ b ) /\ c <=> a /\ c \/ b /\ c `] THEN 
ONCE_REWRITE_TAC[ MESON[]` (d3 a b <= #2.51 /\ l <=> l /\ d3 a b <= #2.51) /\
  (#2.51 < d3 a b /\ l <=> l /\ #2.51 < d3 a b) `] THEN PHA THEN 
REWRITE_TAC[ MESON[]` d3 c a <= #2.51 /\
      d3 c b <= #2.51 /\
      d3 a b <= #2.51 /\ l <=> ( d3 a b <= #2.51 /\
      d3 c a <= #2.51 /\
      d3 c b <= #2.51 ) /\ l `] THEN  
NHANH ( CUTHE3 (
prove(`! a b c. d3 a b <= #2.51 /\ d3 c a <= #2.51 /\
       d3 c b <= #2.51 ==> (!aa bb. aa IN {a,b,c} /\ bb IN {a,b,c} ==> d3 aa bb <= #2.51)`,
REWRITE_TAC[ SET_RULE ` x IN {a,b,c} <=> x = a \/ x= b \/  x= c `] THEN 
MESON_TAC[ D3_REFL; trg_d3_sym; REAL_ARITH ` &0 <= #2.51 `]))) THEN 
REWRITE_TAC[ MESON[] ` d3 a b <= sqrt (&8) /\
     d3 a b >= #2.51 /\
     d3 c a <= #2.51 /\
     d3 c b <= #2.51 /\
     #2.51 < d3 a b /\
     l <=>
     d3 a b >= #2.51 /\
     l /\
     #2.51 < d3 a b /\
     d3 a b <= sqrt (&8) /\
     d3 c a <= #2.51 /\
     d3 c b <= #2.51 `] THEN 
NHANH (CUTHE3 (
prove(`!a b c.
     #2.51 < d3 a b /\
     d3 a b <= sqrt (&8) /\
     d3 c a <= #2.51 /\
     d3 c b <= #2.51
     ==> (?aa bb.
              aa IN {a, b, c} /\
              bb IN {a, b, c} /\
              #2.51 < d3 aa bb /\
              (!x y.
                   ~({x, y} = {aa, bb}) /\ x IN {a, b, c} /\ y IN {a, b, c}
                   ==> d3 x y <= #2.51)) /\
         (!xx yy.
              ~(xx = yy) /\ xx IN {a,b,c} /\ yy IN {a,b,c}
              ==> d3 xx yy <= sqrt (&8))`,
REWRITE_TAC[ MESON[]` (? a b. P a b ) /\ l <=> (? a b. P a b /\ l ) `] THEN 
REWRITE_TAC[ SET_RULE ` x IN {a,b,c} <=> x = a \/ x = b \/ x = c `] THEN 
REPEAT GEN_TAC THEN DISCH_TAC THEN EXISTS_TAC `a:real^3` THEN EXISTS_TAC `b:real^3`
THEN FIRST_X_ASSUM MP_TAC THEN 
REWRITE_TAC[ SET_RULE `{a,b} ={x,y} <=> a = x /\ b = y \/ a = y /\ b = x `] THEN 
MESON_TAC[trg_d3_sym; db_t0_sq8; D3_REFL; REAL_ARITH ` &0 <= #2.51 /\ (! a b c. a <= b /\ b < c ==> a <= c )`]))) THEN 
PHA THEN 
ONCE_REWRITE_TAC[ MESON[] `(! x y. P x y ) /\ l <=> l /\ (! x y. P x y) `] THEN 
PHA THEN 
ONCE_REWRITE_TAC[ SET_RULE ` {v0, v1, v2} = {a, b, c} <=> {v1, v2, v0} = {a, b, c}`] THEN 
NHANH ( MESON[db_t0_sq8 ; REAL_ARITH ` a <= b /\ b < c ==> a <= c `]` (!aa bb. aa IN {a, b, c} /\ bb IN {a, b, c} ==> d3 aa bb <= #2.51) /\
      {v1, v2, v0} = {a, b, c} /\
      (!x y. x IN {a, b, c} /\ y IN {a, b, c} /\ ~(x = y) ==> &2 <= d3 x y)
  ==> (! x y. ~(x=y) /\ x IN {v1,v2,v0} /\ y IN {v1,v2,v0}==> &2 <= d3 x y /\
  d3 x y <= sqrt (&8)) `) THEN 
PHA THEN REWRITE_TAC[ MESON[]` {v1, v2, v0} = {a, b, c} /\ l <=> l /\ {v1, v2, v0} = {a, b, c}`] THEN PHA THEN 
PURE_ONCE_REWRITE_TAC[ MESON[]` P {a,b,c} /\ Q {a,b,c} /\ R {a,b,c} /\ {v1,v2,v0} = {a,b,c} <=> P {v1,v2,v0} /\
  Q {v1,v2,v0} /\ R {v1,v2,v0} /\ {v1,v2,v0} = {a,b,c} ` ] THEN 
MESON_TAC[]);;

(* -----------
-------------- *) 


let NOV6 = prove(` ! s v0 v1 v2 w. packing s /\ 
  CARD {v0, v1, v2, w} = 4 /\
 (!a. a IN {v1, v2, v0} ==> dist (w,a) <= #2.51) /\
 {v0, v1, v2, w} SUBSET s /\
 (?a b c.
      {a, b, c} = {v0, v1, v2} /\
      &2 * t0 <= d3 a b /\
      d3 a b <= sqrt (&8) /\
      c IN anchor_points a b s)
 ==> quarter {v0, v1, v2, w} s`,
REWRITE_TAC[ quarter; def_simplex] THEN 
REWRITE_TAC[ prove(`! v0 v1 v2 w. CARD {v0, v1, v2, w} = 4  <=> ~(v0 = v1 \/ v0 = v2 \/ v0 = w \/ v1 = v2 \/ v1 = w \/ v2 = w)`,
  REWRITE_TAC[ CARD4] THEN SET_TAC[])] THEN 
SIMP_TAC[] THEN 
NHANH ( SET_RULE ` {a, b, c} = {v0, v1, v2} ==> a IN {v0,v1,v2,w} /\
  b IN {v0,v1,v2,w} `) THEN 
REWRITE_TAC[ MESON[]` (!a . P a ) /\ a /\ (? a b c. Q a b c) <=>
  a /\ (?a b c. Q a b c /\ (!a . P a ))`] THEN 
REWRITE_TAC[ anchor_points; anchor; IN_ELIM_THM] THEN PHA THEN 
SIMP_TAC[ SET_RULE ` {v1, v2, v0} = {v0, v1, v2}`] THEN 
PURE_ONCE_REWRITE_TAC[ MESON []`  {a, b, c} = {v0, v1, v2} /\ P {v0, v1, v2}
  <=> {a, b, c} = {v0, v1, v2} /\ P {a, b, c}`] THEN 
ONCE_REWRITE_TAC[ DIST_SYM] THEN 
REWRITE_TAC[ GSYM d3 ] THEN 
REWRITE_TAC[ MESON[t0; REAL_ARITH ` #2.51 = &2 * #1.255 `] ` #2.51 = &2 * t0 `] THEN 
NHANH (CUTHE4 SHORT_EDGES) THEN 
PURE_ONCE_REWRITE_TAC[ SET_RULE ` {a, b, c, w} = w INSERT {a,b,c} `] THEN 
PURE_ONCE_REWRITE_TAC[ GSYM (MESON []`  {a, b, c} = {v0, v1, v2} /\ P {v0, v1, v2}
  <=> {a, b, c} = {v0, v1, v2} /\ P {a, b, c}`)] THEN MESON_TAC[]);;

(* ============ *)

let NOV7 = prove(`!s v0 v1 v2 w x . CARD {v0, v1, v2, w, x} = 5 /\ 
     (!a. a IN {v1, v2, v0} ==> dist (w,a) <= #2.51) /\
     {v0, v1, v2, w} SUBSET s /\
     (?a b c.
          (?q. diagonal a b q s /\ q IN Q_SYS s /\ c IN anchor_points a b s) /\
          {v0, v1, v2} = {a, b, c})
     ==> {v0, v1, v2, w} IN Q_SYS s`, 
ONCE_REWRITE_TAC[ SET_RULE ` {v0, v1, v2, w, x} = {x,v0, v1, v2, w}`] THEN 
REWRITE_TAC[CARD5; GSYM CARD4] THEN 
NHANH (CUTHE4 DIA_OF_QUARTER) THEN 
NHANH (MESON[diagonal; quarter] `diagonal a b q s ==> packing s `) THEN 
PHA THEN REWRITE_TAC[ MESON[]` (?q. diagonal a b q s /\ a1 /\ a2 /\ a3 /\ q IN Q_SYS s /\ a4) <=>
     a1 /\ a2 /\ a3 /\ a4 /\ (?q. diagonal a b q s /\ q IN Q_SYS s) `] THEN 
NHANH ( MESON[NOV6]` CARD {v0, v1, v2, w} = 4 /\
     (!a. a IN {v1, v2, v0} ==> dist (w,a) <= #2.51) /\
     {v0, v1, v2, w} SUBSET s /\
     (?a b c.
          (packing s /\
           &2 * t0 <= d3 a b /\
           d3 a b <= sqrt (&8) /\
           c IN anchor_points a b s /\
           (?q. diagonal a b q s /\ q IN Q_SYS s)) /\
          {v0, v1, v2} = {a, b, c})
     ==> quarter {v0, v1, v2, w} s`) THEN 
PHA THEN REWRITE_TAC[ MESON[]` (? a. P a) /\ aa <=> (? a . P a /\ aa )`] THEN 
NHANH (MESON[diagonal] ` diagonal a b q s ==> {a,b} SUBSET q `) THEN 
PHA THEN REWRITE_TAC[ MESON[]` (? a. P a) /\ aa <=> (? a . P a /\ aa )`] THEN 
NHANH (SET_RULE ` {v0, v1, v2} = {a, b, c} ==> {a,b} SUBSET {v0,v1,v2,w} `) THEN 
REWRITE_TAC[ SET_RULE ` {a, b} SUBSET q /\ aa /\ bb /\ {a, b} SUBSET {v0, v1, v2, w} <=>
     {a, b} SUBSET q INTER {v0, v1, v2, w} /\ aa /\ bb`] THEN 
MESON_TAC[lemma7_7_CXRHOVG]);;


let lemma8_3_OVOAHCG =prove(`!s v0 v1 v2 w x. {v0, v1, v2, w} SUBSET s /\ CARD {v0,v1,v2,w,x} = 5  /\
     centered_pac s v0 /\
     ~(conv {x, w} INTER aff_ge {v0} {v1, v2} = {}) /\
     {v0, v1, v2} IN barrier' v0 s /\
     unobstructed v0 x s /\
     dist (x,v0) < dist (x,v1) /\
     dist (x,v0) < dist (x,v2)
     ==> ~(x IN VC w s)`,
REPEAT GEN_TAC THEN ONCE_REWRITE_TAC[ MESON[] ` a ==> ~b <=> a /\ b ==> ~b`] THEN 
REWRITE_TAC[IN_ELIM_THM] THEN 
NHANH (MESON[CARD5] ` CARD {x, w, v0, v1, v2} = 5 ==> ~(x IN {w,v0,v1,v2})`) THEN 
NHANH ( SET_RULE ` ~(x IN {w,v0,v1,v2}) ==> ~( x = w ) `) THEN 
PHA THEN  REWRITE_TAC[  MESON[]` unobstructed v0 x s /\ a <=> a /\ 
  unobstructed v0 x s `] THEN REWRITE_TAC[ MESON[]` ~(x = w) /\ a <=> a /\ ~(x = w) `]
   THEN PHA THEN 
NHANH (SET_RULE ` ~(v0 IN {v1, v2, w, x}) ==> ~( v0 = w )`) THEN 
NGOAC THEN MATCH_MP_TAC (MESON[] ` (a ==> c) ==> ( a /\ b ==> c ) `) THEN PHA THEN 
REWRITE_TAC[ unobstructed] THEN 
REWRITE_TAC[ MESON[] ` ~(v0 = w) /\ centered_pac s v0 /\ aa /\ bb /\ cc /\
  x IN VC w s /\  ~obstructed v0 x s /\ las <=>
  aa /\ bb /\ cc /\ las /\ ( centered_pac s v0 /\ ~(v0 = w) /\
  ~obstructed v0 x s  /\ x IN VC w s   )`] THEN 
NHANH (CUTHE4 (prove(` ! s v0 w x . centered_pac s v0 /\ ~(v0 = w) /\ ~obstructed v0 x s /\ x IN VC w s 
==> d3 w x < d3 v0 x`, REWRITE_TAC[ VC; lambda_x; IN_ELIM_THM] THEN PURE_ONCE_REWRITE_TAC
[ MESON[] `( !s v0 w x. a v0 x s w ==> b v0 x w ) <=> ( ! s v0 w x. ( d3 v0 x < &2 \/ 
~(d3 v0 x < &2)) /\ a v0 x s w ==> b v0 x w) `] THEN MESON_TAC[centered_pac; trg_d3_sym;
  REAL_ARITH` ~(d3 v0 x < &2) /\ d3 w x < &2 ==> d3 w x < d3 v0 x`]))) THEN 
NHANH (CUTHE4 TRIANGLE_IN_BARRIER') THEN 
PHA THEN 
ONCE_REWRITE_TAC[MESON[] ` a1 /\ a2 /\ a3 /\  a4 /\
~(conv {x, w} INTER aff_ge {v0} {v1, v2} = {}) /\ aa /\  bb /\  cc /\  dd /\  a5 <=> aa /\
     bb /\  cc /\   dd /\   ~(conv {x, w} INTER aff_ge {v0} {v1, v2} = {}) /\  a3 /\ a4 /\
  a5 /\   a1 /\  a2`] THEN ONCE_REWRITE_TAC[ trg_d3_sym] THEN REWRITE_TAC[d3] THEN 
REWRITE_TAC[MESON[aff_ge_def; cone]` aff_ge {v0} {v1, v2} = cone v0 {v1,v2}`] THEN 
ONCE_REWRITE_TAC[ MESON[] ` CARD {v0, v1, v2, w, x} = 5 /\ a1 /\ a2 /\ a3 /\ a4 /\ a5 /\ a6 /\ l <=>
     a1 /\ a2 /\ a3 /\ a4 /\ a5 /\ a6 /\ CARD {v0, v1, v2, w, x} = 5 /\ l`] THEN 
NHANH (CUTHE5 tarski_UMMNOJN) THEN 
PHA THEN REWRITE_TAC[ MESON[] ` ( a \/ b ) /\ c <=> c /\ ( a \/ b ) `] THEN 
REWRITE_TAC[ MESON[] `{v0, v1, v2} IN barrier' v0 s /\ a <=>  
  a /\ {v0, v1, v2} IN barrier' v0 s`] THEN 
REWRITE_TAC[ barrier'; IN_ELIM_THM] THEN 
PURE_ONCE_REWRITE_TAC[ MESON[]` (?a b c.
      ( P  {a, b, c} \/
       Q a b c ) /\
      {v0, v1, v2} = {a, b, c})
  <=> P {v0, v1, v2} \/  (? a b c. Q a b c /\ {v0, v1, v2} = {a, b, c})`] THEN PHA THEN 
ONCE_REWRITE_TAC[ MESON[] ` ~(conv {v0, v1, v2} INTER conv0 {x, w} = {}) /\ aa /\ (b \/ bb) <=>
     ~(conv {v0, v1, v2} INTER conv0 {x, w} = {}) /\
     aa /\
     (~(conv {v0, v1, v2} INTER conv0 {x, w} = {}) /\ b \/ bb)`] THEN 
REWRITE_TAC[ SET_RULE ` conv {v0, v1, v2} INTER conv0 {x, w} = 
          conv0 {x, w} INTER conv {v0, v1, v2}`] THEN 
NHANH (MESON[ def_obstructed] ` ~(conv0 {x, w} INTER conv {v0, v1, v2} = {}) /\
  {v0, v1, v2} IN barrier s /\ l ==> obstructed x w s `) THEN 
PHA THEN REWRITE_TAC[ MESON[] ` {v0, v1, v2, w} SUBSET s /\ a <=> a /\ {v0, v1, v2, w} 
   SUBSET s`] THEN 
REWRITE_TAC[ MESON[] ` (!a. a IN {v1, v2, v0} ==> dist (w,a) <= #2.51) /\ a <=> 
   a /\ (!a. a IN {v1, v2, v0} ==> dist (w,a) <= #2.51)`] THEN 
REWRITE_TAC[ MESON[]` CARD {v0, v1, v2, w, x} = 5 /\ a <=>
    a /\ CARD {v0, v1, v2, w, x} = 5 `] THEN 
PHA THEN 
ONCE_REWRITE_TAC[ MESON[] ` ( a \/ b) /\ a1 /\ a2 /\ {v0, v1, v2, w} SUBSET s <=> ( a \/ 
  a2 /\ a1 /\ {v0, v1, v2, w} SUBSET s /\ b) /\ a1 /\ a2 /\ {v0, v1, v2, w} SUBSET s`] THEN 
NHANH (CUTHE6 NOV7) THEN 
NHANH (prove(` {v0, v1, v2, w} IN Q_SYS s ==> {v0,v1,v2} IN barrier s `, 
  REWRITE_TAC[ barrier; SET_RULE` {a,b,c} UNION {d} = {a,b,c,d} `; IN_ELIM_THM]
   THEN MESON_TAC[])) THEN 
ONCE_REWRITE_TAC[ MESON[] ` ~(conv0 {x, w} INTER conv {v0, v1, v2} = {}) /\ a1 
  /\ ( a \/ b ) /\ l <=>  ~(conv0 {x, w} INTER conv {v0, v1, v2} = {}) /\ a1 
  /\ ( a \/ b /\ ~(conv0 {x, w} INTER conv {v0, v1, v2} = {}) ) /\ l`] THEN 
PHA THEN NHANH (MESON[def_obstructed] ` {v0, v1, v2} IN barrier s /\
  ~(conv0 {x, w} INTER conv {v0, v1, v2} = {}) ==> obstructed x w s`) THEN 
REWRITE_TAC[ MESON[]` (a /\ b \/ a /\ c ) <=> a /\ ( b \/ c ) `] THEN 
DAO THEN 
REWRITE_TAC[ MESON[] `( obstructed x w s /\ b \/ obstructed x w s
  /\ c ) <=>  obstructed x w s /\ ( b \/ c ) `] THEN PHA THEN 
REWRITE_TAC[MESON[ OBS_IMP_NOT_IN_VC] ` a1/\a2/\a3 /\ obstructed x w s /\ l 
  ==> ~(x IN VC w s)`]);;

let lambda_x = prove(` ! x s. lambda_x x s ={w | w IN s /\ d3 w x < &2 /\ ~obstruct w x s}`,
REWRITE_TAC[lambda_x; OBSTRUCT_EQ]);;

(* ==== end repare VC === *)


(* LEMMA 8.1 *)



let TCQPONA = new_axiom ` ! s v v1 v2 v3.
  packing s /\
 CARD {v, v1, v2, v3} = 4 /\
 {v, v1, v2, v3} SUBSET s /\
 d3 v1 v2 <= &2 * t0 /\
 d3 v2 v3 <= &2 * t0 /\
 d3 v3 v1 <= &2 * t0 /\
 ~(conv {v1, v2, v3} INTER voronoi v s = {})
 ==> (!x. x IN {v1, v2, v3} ==> &2 <= d3 x v /\ d3 x v <= &2 * t0)`;;



let CEWWWDQ = new_axiom ` !s v v1 v2 v3.
     packing s /\
     CARD {v, v1, v2, v3}  = 4 /\
     {v, v1, v2, v3}  SUBSET s /\
     d3 v1 v2 <= &2 * t0 /\
     d3 v2 v3 <= &2 * t0 /\
     d3 v1 v3 <= sqrt (&8) /\
     ~(conv {v1, v2, v3} INTER voronoi v s = {})
     ==> (!x. x IN {v1, v2, v3} ==> &2 <= d3 x v /\ d3 x v <= &2 * t0)`;;


let QHSEWMI = new_axiom ` !v1 v2 v3 w1 w2.
         ~(conv {w1, w2} INTER conv {v1, v2, v3} = {}) /\
         ~(w1 IN conv {v1,v2,v3})
         ==> w2 IN cone w1 {v1, v2, v3}`;;


(* ================ *)



(* ======= have added to database_more =========== *)



let DOT_SUB_ADD = VECTOR_ARITH `! a b. b dot b - a dot a = (b - a) dot (b + a)` ;;

let DIST_LT_HALF_PLANE = prove(`!x:real^A a:real^A b:real^A. 
    dist(x,a) < dist(x,b) <=> &0 < (a - b) dot (&2 % x - (a + b))`,
ABBREV_TAC ` an a b x = ((a:real^A) - b) dot (&2 % x - (a + b))` THEN 
REWRITE_TAC[dist; vector_norm] THEN 
REWRITE_TAC[MESON[DOT_POS_LE; SQRT_MONO_LT_EQ]` sqrt ( x dot x) < sqrt (y dot y) <=>
  x dot x < y dot y `] THEN 
REWRITE_TAC[DOT_LSUB; DOT_RSUB] THEN 
SIMP_TAC[DOT_SYM] THEN 
ONCE_REWRITE_TAC[ GSYM REAL_SUB_LT] THEN 
REWRITE_TAC[ REAL_ARITH ` x dot x -
     b dot x -
     (b dot x - b dot b) -
     (x dot x - a dot x - (a dot x - a dot a)) =
     &2 * (a dot x - b dot x) + b dot b - a dot a`] THEN 
REWRITE_TAC[GSYM DOT_LSUB; GSYM DOT_RMUL] THEN 
REWRITE_TAC[DOT_SUB_ADD; VECTOR_ARITH `(b - a) dot (b + a) = 
  ( -- ( a - b) ) dot ( a + b) `] THEN 
REWRITE_TAC[VECTOR_ARITH ` (a - b) dot &2 % x + --(a - b) dot (a + b) = 
  (a-b) dot ( &2 % x - (a+b))`] THEN 
ASM_REWRITE_TAC[REAL_ARITH ` a - &0 = a` ]);;


let OR_IMP_EX = MESON[]` ! a b c. a \/ b ==> c <=> (a ==> c) /\ ( b ==> c)` ;;


let HALF_PLANE_CONV = prove(`! a b:real^N.  convex { x| x | dist(x,a) < dist (x,b) }`,
REWRITE_TAC[DIST_LT_HALF_PLANE; convex; IN_ELIM_THM] THEN 
REWRITE_TAC[VECTOR_ARITH ` &2 % (u % x + v % y) - (a + b) 
   = u % ( &2 % x ) + v % ( &2 % y ) - &1 % (a + b )`] THEN 
ONCE_REWRITE_TAC[EQ_SYM_EQ] THEN SIMP_TAC[] THEN 
REWRITE_TAC[VECTOR_ARITH ` (a - b) dot (u % &2 % x +
   v % &2 % y - (u + v) % (a + b))  = u * (a - b) dot (&2 % x - (a + b))
   + v * (a - b) dot (&2 % y - (a + b))`] THEN 
REWRITE_TAC[REAL_ARITH` &0 <= u /\ &0 <= v /\ &1 = u + v <=>
     &0 = u /\ &1 = v \/ &0 < u /\ &0 <= v /\ &1 = u + v`] THEN 
KHANANG THEN 
REWRITE_TAC[OR_IMP_EX] THEN 
ONCE_REWRITE_TAC[ EQ_SYM_EQ] THEN SIMP_TAC[] THEN 
REWRITE_TAC[REAL_POLY_CLAUSES] THEN 
SIMP_TAC[ REAL_ARITH ` a + &0 = a `] THEN 
NHANH (MESON[REAL_LT_MUL]`  &0 < (a - b) dot (&2 % x - (a + b)) /\
     &0 < (a - b) dot (&2 % y - (a + b)) /\
     &0 < u  /\ l ==> &0 < u * ((a - b) dot (&2 % x - (a + b)))`) THEN 
NHANH (MESON[REAL_ARITH` &0 < a ==> &0 <= a `; REAL_LE_MUL]`
  &0 < (a - b) dot (&2 % y - (a + b)) /\
      &0 < u /\
      &0 <= v /\ l ==> &0 <= v * ((a - b) dot (&2 % y - (a + b)))`)
 THEN REAL_ARITH_TAC);;

let HALF_PLANE_CONV_EP = REWRITE_RULE[convex; IN_ELIM_THM] HALF_PLANE_CONV;;

let VORONOI_CONV = prove( ` ! (s:real^A -> bool) v. convex (voronoi v s )`,
REWRITE_TAC[voronoi] THEN REPEAT GEN_TAC THEN 
REWRITE_TAC[convex; IN_ELIM_THM] THEN MESON_TAC[HALF_PLANE_CONV_EP]);;

let CONVEX_IM_CONV2_SU = prove(`! s u v. convex s /\ u IN s /\ v IN s ==> conv {u,v} SUBSET s `,
REWRITE_TAC[convex; CONV_SET2] THEN SET_TAC[]);;

(* have not added *)

let U_IN_CONV2 = prove(`! u v. u IN conv {u,v} `,
REWRITE_TAC[ CONV_SET2; IN_ELIM_THM] THEN REPEAT GEN_TAC
THEN EXISTS_TAC `&1` THEN EXISTS_TAC `&0 ` THEN 
REWRITE_TAC[VECTOR_MUL_LID; VECTOR_MUL_LZERO; VECTOR_ADD_RID] THEN 
REAL_ARITH_TAC);;

let UV_IN_CONV2 = prove(` ! u v. u IN conv {u,v} /\ v IN conv {u,v} `, 
MESON_TAC[U_IN_CONV2; SET_RULE ` {u,v} = {v,u} `]);;

let CONVEX_AS_CONV2 = prove(` ! s. convex s ==> ( ! u v. u IN s /\ v IN s <=>
   conv {u,v} SUBSET s )`, REWRITE_TAC[ EQ_EXPAND] THEN 
SIMP_TAC[CONVEX_IM_CONV2_SU ] THEN MESON_TAC[SUBSET; UV_IN_CONV2]);;






let CONV0_SING = prove(`! x:real^A . conv0 {x} = {x} `,
REWRITE_TAC[conv0; FUN_EQ_THM; affsign; lin_combo] THEN 
REWRITE_TAC[UNION_EMPTY; VSUM_SING; SUM_SING; IN_ACT_SING; sgn_gt] THEN 
REWRITE_TAC[MESON[REAL_ARITH` &0 < &1 `]` (!w. x = w ==> &0 < f w) /\ 
  f x = &1 <=> f x = &1 `] THEN 
REWRITE_TAC[MESON[VECTOR_MUL_LID]` (?f. x' = f x % x /\ f x = &1) <=>
   x' = x /\ (? f. f x = &1 ) `] THEN 
MESON_TAC[prove(`!x:real^A. ? f. f x = &1`, GEN_TAC THEN EXISTS_TAC 
  `(\x:real^A. &1)` THEN MESON_TAC[])]);;


let NOV10' = prove(`! x y.      (x = y
      ==> (!x. y = x <=>
               (?a b. &0 < a /\ &0 < b /\ a + b = &1 /\ x = a % y + b % y)))`,
REWRITE_TAC[GSYM VECTOR_ADD_RDISTRIB] THEN 
REWRITE_TAC[MESON[VECTOR_MUL_LID]` a + b = &1 /\
    x = (a + b) % y <=> a + b = &1 /\ x = y `] THEN 
MESON_TAC[prove(` ?a b. &0 < a /\ &0 < b /\ a + b = &1`, REPEAT 
  (EXISTS_TAC ` &1 / &2 `) THEN REAL_ARITH_TAC)]);;


let CONV0_SET2 = prove(` ! x y:real^A. conv0 {x,y} = {w | ? a b. &0 < a /\ &0 < b /\ a + b = &1 /\
  w = a%x + b%y}`,
ONCE_REWRITE_TAC[ MESON[] ` (! a b. P a b ) <=> ( ! a b. a = b \/ ~( a= b)
  ==> P a b )`] THEN 
REWRITE_TAC[ MESON[]` a \/ b ==> c <=> ( a==> c) /\ ( b==> c)`] THEN 
SIMP_TAC[] THEN 
REWRITE_TAC[ SET_RULE ` {a,a} = {a}`; CONV0_SING; FUN_EQ_THM; IN_ELIM_THM] THEN 
REWRITE_TAC[ IN_ACT_SING; NOV10'] THEN 
REWRITE_TAC[conv0 ; sgn_gt; affsign; lin_combo] THEN 
REWRITE_TAC[UNION_EMPTY; IN_SET2] THEN 
ONCE_REWRITE_TAC[ MESON[]`  ~(x = y) ==> (!x'. (?f. P f x') <=> l x') <=>
  ~(x = y) ==> (!x'. (?f. ~(x=y) /\ P f x') <=> l x')`] THEN 
REWRITE_TAC[ MESON[VSUM_DIS2; SUM_DIS2]` ~(x = y) /\
                    x' = vsum {x, y} ff /\ l /\ sum {x, y} f = &1 <=> ~(x = y) /\
                    x' = ff x + ff y /\ l /\ f x + f y = &1 `]  THEN 
REWRITE_TAC[ MESON[]` (!w. w = x \/ w = y ==> &0 < f w) <=> &0 < f x /\ &0 < f y`] THEN 
ONCE_REWRITE_TAC[ GSYM (MESON[]`  ~(x = y) ==> (!x'. (?f. P f x') <=> l x') <=>
  ~(x = y) ==> (!x'. (?f. ~(x=y) /\ P f x') <=> l x')`)] THEN 
REPEAT GEN_TAC THEN DISCH_TAC THEN GEN_TAC THEN 
REWRITE_TAC[ EQ_EXPAND] THEN 
SIMP_TAC[ MESON[]` ((?f. x' = f x % x + f y % y /\ (&0 < f x /\ &0 < f y) /\ f x + f y = &1)
  ==> (?a b. &0 < a /\ &0 < b /\ a + b = &1 /\ x' = a % x + b % y)) `] THEN 
STRIP_TAC THEN EXISTS_TAC ` (\(d:real^A). if d = x then (a:real) else b )` THEN 
ASM_SIMP_TAC[]);;


let CONV02_SU_CONV2 = prove(` ! u v. conv0 {u,v} SUBSET conv {u,v} `,
REWRITE_TAC[ CONV_SET2; CONV0_SET2] THEN 
MP_TAC (REAL_ARITH ` ! a . &0 < a ==> &0 <= a `) THEN SET_TAC[]);;


let CONVEX_IM_CONV02_SU = prove(`! s u v. convex s /\ u IN s /\ v IN s ==> 
conv0 {u, v} SUBSET s`,
MESON_TAC[CONV02_SU_CONV2; CONVEX_IM_CONV2_SU; SUBSET_TRANS]);;


(* =================== *)

let BAR_TRI = prove(` ! b s. b IN barrier s <=> (? x y z . b = {x,y,z} /\ {x,y,z} IN barrier s)`,
REWRITE_TAC[ barrier ; IN_ELIM_THM] THEN MESON_TAC[]);;





let NOV20 = prove(` ! v0 x' y z. v0 IN {x', y, z} <=> (?yy zz. {v0, yy, zz} = {x', y, z})`, 
REPEAT GEN_TAC THEN 
REWRITE_TAC[EQ_EXPAND] THEN 
REWRITE_TAC[SET_RULE `((?yy zz. {v0, yy, zz} = {x', y, z}) 
   ==> v0 IN {x', y, z})`] THEN 
REWRITE_TAC[IN_SET3] THEN 
MESON_TAC[SET_RULE ` x = a
     ==> {x, b, c} = {a, b, c} /\
         {x, b, c} = {b, a, c} /\
         {x, b, c} = {b, c, a}`]);;



let X_IN_VOR_X = prove(` ! x:real^A s. x IN voronoi x s `,
REWRITE_TAC[voronoi; IN_ELIM_THM; DIST_REFL; DIST_POS_LT] THEN 
MESON_TAC[DIST_POS_LT]);;

let IN_VO2_EQ = prove(` ! s v0 x . x IN voro2 v0 s <=>
 (!w. s w /\ ~(w = v0) ==> d3 x v0 < d3 x w) /\ d3 x v0 < &2`,
REWRITE_TAC[voro2; voronoi; IN_ELIM_THM; d3]);;

let IN_VO_EQ = prove(`! x s v0 . x IN voronoi v0 s <=> (!w. s w /\
   ~(w = v0) ==> dist(x,v0) < dist(x,w))`, REWRITE_TAC[voronoi; IN_ELIM_THM]);;


let IN_BAR_DISTINCT = prove(` ! a b c s. {a,b,c} IN barrier s ==> 
   ~( a = b\/ b= c \/ c = a)`,
REWRITE_TAC[barrier; IN_ELIM_THM; quasi_tri;set_3elements] THEN 
KHANANG THEN REWRITE_TAC[EXISTS_OR_THM] THEN NHANH ( MESON[]` (?v1 v2 v3.
          (a1  /\  a2 v1 v2 v3  /\
           ~(v1 = v2 \/ v2 = v3 \/ v3 = v1) /\
           a3 v1 v2 v3 ) /\
          {a, b, c} = {v1, v2, v3}) ==> (?v1 v2 v3.
           ~(v1 = v2 \/ v2 = v3 \/ v3 = v1) /\
          {a, b, c} = {v1, v2, v3})`) THEN 
ONCE_REWRITE_TAC[MESON[EQ_SYM_EQ]` {a,b,c} = {x,y,z} <=> {x,y,z} = {a,b,c}` ] THEN 
REWRITE_TAC[ set_3elements] THEN MESON_TAC[OCT23]);;


let FOUR_POINTS = prove(`!a b c d s.
     {a, b, c} IN barrier s /\ ~(d IN {a, b, c}) ==> CARD {a, b, c, d} = 4`,
NHANH (CUTHE4 IN_BAR_DISTINCT) THEN ONCE_REWRITE_TAC[ 
SET_RULE ` {a,b,c,d} = {d,a,b,c} `] THEN MESON_TAC[CARD4]);;


(* ========= *)


let IN_Q_SYS_IMP4 = prove(`!q s. q IN Q_SYS s ==> 
  (?a b c d. {a, b, c} UNION {d} = q)`,
NHANH (SPEC_ALL CASES_OF_Q_SYS) THEN 
REWRITE_TAC[quasi_reg_tet; strict_qua; quarter; simplex] THEN 
REWRITE_TAC[SET_RULE` {a,b,c,d} = {a,b,c} UNION {d} `] THEN 
MESON_TAC[]);;


let SET2_SU_EX = SET_RULE` {(a:A),b} SUBSET s <=> a IN s /\ b IN s `;;
let D3_SYM = MESON[trg_d3_sym]` ! x y. d3 x y = d3 y x `;;


let EXISTS_DIA = prove(`! q s. quarter q s ==> (? a b. diagonal a b q s)`,
REWRITE_TAC[quarter; diagonal] THEN 
REWRITE_TAC[SET2_SU_EX] THEN 
SIMP_TAC[] THEN 
NHANH (MESON[REAL_LE_TRANS]`&2 * t0 <= d3 v w /\ a1 /\ (!x y. P x y ==> d3 x y <= &2 * t0)
     ==> (!x y. P x y ==> d3 x y <= d3 v w)`) THEN 
MP_TAC PAIR_D3 THEN 
REWRITE_TAC[MESON[REAL_ARITH ` a = b ==> a <= b `] ` a ==> b = c:real <=>
  a ==> ( b = c /\ b <= c )`] THEN 
MESON_TAC[]);;


let QUARTER_EQ_EX_DIA = prove(`! q s. quarter q s <=> (? a b. diagonal a b q s)`,
REWRITE_TAC[EQ_EXPAND; EXISTS_DIA; diagonal] THEN MESON_TAC[]);;


let IN_Q_IMP = prove(`!q s.
     q IN Q_SYS s ==>
     quasi_reg_tet q s \/
     (?a b q1.
          {a, b} SUBSET q INTER q1 /\ quarter q s /\ diagonal a b q1 s /\ q1 IN Q_SYS s)`,
REWRITE_TAC[MESON[CASES_OF_Q_SYS]`  (q IN Q_SYS s ==> a ) <=> q IN Q_SYS s
    /\ (quasi_reg_tet q s \/ strict_qua q s) ==> a `] THEN 
KHANANG THEN 
REWRITE_TAC[MESON[]` a \/ b ==> c <=> (a ==> c) /\ ( b==> c) `] THEN 
SIMP_TAC[] THEN 
REWRITE_TAC[strict_qua] THEN 
NHANH (SPEC_ALL EXISTS_DIA) THEN 
NHANH (MESON[diagonal]`  diagonal d1 d2 q s ==>  {d1, d2} SUBSET q `) THEN 
REWRITE_TAC[SUBSET_INTER] THEN 
MESON_TAC[]);;

let NOV21 = prove(` ! q s. quasi_reg_tet q s ==> q IN Q_SYS s`,
REWRITE_TAC[Q_SYS; IN_ELIM_THM] THEN REWRITE_TAC[ MESON[]` a ==> a \/ b `]);;


let NOVE21 = prove(` ! q s. quasi_reg_tet q s \/
     (?a b q1.
          {a, b} SUBSET q1 INTER q /\ quarter q s /\ diagonal a b q1 s /\ q1 IN Q_SYS s)
  ==> q IN Q_SYS s `,
MP_TAC NOV21 THEN REWRITE_TAC[OR_IMP_EX] THEN SIMP_TAC[] THEN 
MP_TAC lemma7_7_CXRHOVG THEN MESON_TAC[]);;


let COND_Q_SYS =prove(`!q s.
     q IN Q_SYS s <=>  quasi_reg_tet q s \/
     (?a b q1. {a, b} SUBSET q INTER q1 /\ quarter q s /\ 
     diagonal a b q1 s /\ q1 IN Q_SYS s)`, REWRITE_TAC[EQ_EXPAND] THEN 
REWRITE_TAC[IN_Q_IMP] THEN MESON_TAC[INTER_COMM; NOVE21]);;

(* ============ *)

let SET4_SUB_EX = SET_RULE ` {a,b,c,d} SUBSET s <=> 
     a IN s /\ b IN s /\ c IN s /\ (d:A) IN s `;;



let IMP_QUA_RE_TE = prove(`!s v0 x y z. v0 IN s /\ packing s /\
     {x, y, z} SUBSET s /\
     (!aa bb. aa IN {y, z, x} /\ bb IN {y, z, x} ==> dist (aa,bb) <= #2.51) /\
     ~(voronoi v0 s INTER conv {x, y, z} = {}) /\
     CARD {x, y, z, v0} = 4 ==> quasi_reg_tet {v0,x,y,z} s `,
NHANH (SET_RULE ` (! aa bb. aa IN {y, z, x} /\ bb IN {y, z, x} ==> P aa bb ) 
  ==> P x y /\ P y z /\ P z x `) THEN 
ONCE_REWRITE_TAC[ SET_RULE `{a,b,c,d} = {d,a,b,c}`] THEN 
REWRITE_TAC[ SET_RULE ` v0 IN s /\ packing s /\
     {x, y, z} SUBSET s /\ l <=> packing s /\ {v0,x,y,z} SUBSET s /\ l `] THEN 
REWRITE_TAC[ MESON[]` a /\ b/\ ( c1 /\ c2 ) /\ d /\ e <=> c1 /\ a /\ e 
   /\ b /\ c2 /\d `] THEN 
ONCE_REWRITE_TAC[INTER_COMM] THEN 
REWRITE_TAC[ GSYM db_t0; GSYM d3] THEN PHA THEN 
NHANH (SPEC_ALL TCQPONA) THEN 
REWRITE_TAC[quasi_reg_tet; def_simplex; CARD4;IN_SET3; IN_SET4; 
   DE_MORGAN_THM; SET4_SUB_EX; db_t0] THEN 
SIMP_TAC[] THEN PHA THEN DAO THEN 
REWRITE_TAC[ MESON[D3_SYM]` (!x'. x' = x \/ x' = y \/ x' = z ==> 
  d3 x' v0 <= #2.51 /\ &2 <= d3 x' v0) /\     a1 /\
     d3 z x <= #2.51 /\
     d3 y z <= #2.51 /\
     d3 x y <= #2.51 /\
     l  ==> (!v w. ~(v = w) /\
              (v = z \/ v = v0 \/ v = x \/ v = y) /\
              (w = z \/ w = v0 \/ w = x \/ w = y)
              ==> d3 v w <= #2.51)`]);;

(* =========== *)

let SET3_U_SET1 = SET_RULE ` {a,b,c} UNION {d} = {a,b,c,d} `;;


let IN_BA_IM_PA_SU = prove(`! s x y z. {x, y, z} IN barrier s ==> 
packing s /\ {x, y, z} SUBSET s`,
REWRITE_TAC[barrier; IN_ELIM_THM] THEN 
NHANH (SPEC_ALL CASES_OF_Q_SYS) THEN REPEAT GEN_TAC THEN 
REWRITE_TAC[quasi_tri] THEN KHANANG THEN 
REWRITE_TAC[MESON[]` (?a b c. P a b c \/ Q a b c) ==> l <=> 
       ((?a b c . P a b c ) ==> l) /\ ((?a b c. Q a b c) ==> l)`] THEN 
REWRITE_TAC[MESON[]` (?v1 v2 v3.  (packing s /\
        {v1, v2, v3} SUBSET s /\P v1 v2 v3 ) /\
       {x, y, z} = {v1, v2, v3}) ==> packing s /\ {x, y, z} SUBSET s`] THEN 
REWRITE_TAC[quasi_reg_tet; strict_qua; quarter; SET3_U_SET1; def_simplex] THEN 
REWRITE_TAC[SET_RULE ` {a,b,c,d} SUBSET s <=> {a,b,c} SUBSET s /\ d IN s `] THEN 
MESON_TAC[]);;


let FIRST_NOV22 = prove(` ! s v0 x y z. {x, y, z} IN barrier s /\
 (!xx yy.
      ~(xx = yy) /\ {xx, yy} SUBSET {y, z, x}
      ==> &2 <= dist (xx,yy) /\ dist (xx,yy) <= sqrt (&8)) /\
 (!aa bb. aa IN {y, z, x} /\ bb IN {y, z, x} ==> dist (aa,bb) <= #2.51) /\
 v0 IN s /\
 ~(voronoi v0 s INTER conv {x, y, z} = {}) /\
 CARD {x, y, z, v0} = 4
 ==> {v0, x, y, z} IN Q_SYS s`,
NHANH (SPEC_ALL IN_BA_IM_PA_SU ) THEN 
PHA THEN 
ONCE_REWRITE_TAC[MESON[]` a1 /\ a2 /\ a3 /\ a4 /\ a5 /\ a6 /\ a7 /\ a8 <=>
  a1 /\ a4 /\ a6 /\ a2 /\ a3 /\ a5 /\ a7 /\ a8 `] THEN 
NHANH (SPEC_ALL IMP_QUA_RE_TE) THEN 
MESON_TAC[COND_Q_SYS]);;



let QUA_TRI_EDGE = prove(` ! q s. quasi_tri q s ==> 
  (! a b. a IN q /\ b IN q ==> d3 a b <= &2 * t0 )`,REWRITE_TAC[quasi_tri; db_t0]
THEN MP_TAC D3_REFL THEN MP_TAC (REAL_ARITH ` &0 <= #2.51 `) THEN MESON_TAC[]);;


let BAR_WI_LONG_ED = prove(`!bar s.
     bar IN barrier s /\ (?a b. #2.51 < d3 a b /\ a IN bar /\ b IN bar)
     ==> (?w. w INSERT bar IN Q_SYS s /\ strict_qua (w INSERT bar) s)`,
REWRITE_TAC[barrier; IN_ELIM_THM] THEN REPEAT GEN_TAC THEN STRIP_TAC THENL 
[REPEAT (FIRST_X_ASSUM MP_TAC);REPEAT (FIRST_X_ASSUM MP_TAC)]
 THENL [NHANH (SPEC_ALL QUA_TRI_EDGE); 
ABBREV_TAC ` an w s = (w:real^3 INSERT (bar:real^3 -> bool) IN Q_SYS s)`] THENL 
[REWRITE_TAC[ GSYM db_t0]; NHANH (SPEC_ALL CASES_OF_Q_SYS)] THENL 
[MESON_TAC[REAL_ARITH ` a <= b <=> ~( b < a )`]; 
NHANH (MESON[QUA_TET_IMPLY_QUA_TRI]`quasi_reg_tet ({v0, v1, v2} UNION {v4}) s ==>
  quasi_tri {v0, v1, v2} s`)] THEN NHANH (SPEC_ALL QUA_TRI_EDGE) THEN 
STRIP_TAC THENL [ASM_MESON_TAC[db_t0; REAL_ARITH` a <= b <=> ~( b < a ) `];
ASM_MESON_TAC[SET_RULE ` s UNION {a} = a INSERT s `]]);;

(* ======= *)

let PER_SET3 = SET_RULE ` {a,b,c} = {a,c,b} /\ {a,b,c} = {b,a,c} /\
  {a,b,c} = {c,a,b} /\ {a,b,c} = {b,c,a} /\ {a,b,c} = {c,b,a} `;;

let EXI_THIRD_PO =prove( ` ! a b c x y: A. {x,y} SUBSET {a,b,c} /\ ~(x=y) 
  ==> (? z. {x,y,z} = {a,b,c} ) `, REPEAT GEN_TAC THEN 
REWRITE_TAC[SET2_SU_EX] THEN REWRITE_TAC[SET2_SU_EX; IN_SET3] THEN 
KHANANG THEN REWRITE_TAC[MESON[]`x = a /\ y = a /\ ~(x = y) <=> F`] THEN 
MESON_TAC[ PER_SET3]);;


let FOUR_IN = SET_RULE `!a b c d. a IN {a,b,c,d} /\ b IN {a,b,c,d} /\c IN {a,b,c,d} /\ d IN {a,b,c,d} ` ;;


let IMP_QUA = prove(` ! a b c s v0. packing s /\
 CARD {v0, a, b, c} = 4 /\
 {v0, a, b, c} SUBSET s /\
 d3 a b <= &2 * t0 /\
 d3 b c <= &2 * t0 /\ &2 * t0 <= d3 a c /\
 d3 a c <= sqrt (&8) /\
 (!x. x IN {a, b, c} ==> &2 <= d3 x v0 /\ d3 x v0 <= &2 * t0)
==> quarter {v0, a, b, c} s `,
REWRITE_TAC[quarter; def_simplex; CARD4; IN_SET3; DE_MORGAN_THM] THEN 
SIMP_TAC[] THEN REPEAT GEN_TAC THEN STRIP_TAC THEN 
EXISTS_TAC `a:real^3` THEN EXISTS_TAC `c:real^3` THEN 
ASM_SIMP_TAC[FOUR_IN] THEN REWRITE_TAC[IN_SET4; PAIR_EQ_EXPAND] THEN 
MP_TAC (MESON[REAL_ARITH ` &0 <= #2.51`; db_t0]` &0 <= &2*t0 `) THEN 
ASM_MESON_TAC[D3_SYM; D3_REFL]);;


let QUA_RE_TE_EDGE = prove(`! a b q s. quasi_reg_tet q s /\ a IN q /\ b IN q
 ==> d3 a b <= &2 * t0 `, REWRITE_TAC[quasi_reg_tet] THEN MP_TAC D3_REFL THEN 
REWRITE_TAC[db_t0] THEN MESON_TAC[REAL_ARITH `&0 <= #2.51 `]);;

(* ========= *)


let CONSI_OF_LE77 = prove(`!s v0 v4 w x y z.
     quarter ({x, y, z} UNION {v0}) s /\
     aa IN {x, y, z} /\
     bb IN {x, y, z} /\
     {x, y, z} UNION {v4} IN Q_SYS s /\
     diagonal aa bb ({x, y, z} UNION {v4}) s
     ==> {x, y, z} UNION {v0} IN Q_SYS s`,
REWRITE_TAC[MESON[]` quarter q s /\ a <=>a/\quarter q s `] THEN 
PHA THEN NHANH (SET_RULE `  aa IN {x, y, z} /\ bb IN {x, y, z} /\ l
     ==> (!v0 v4.
              {aa, bb} SUBSET
              ({x, y, z} UNION {v4}) INTER ({x, y, z} UNION {v0}))`) THEN 
PHA THEN NHANH (MESON[]` diagonal aa bb ({x, y, z} UNION {v4}) s /\
     quarter ({x, y, z} UNION {v0}) s /\
     (!v0 v4. P v0 v4) ==> P v0 v4 `) THEN MESON_TAC[lemma7_7_CXRHOVG]);;









let IMP_IN_Q_SYS = prove( ` ! s v0 x y z . {x, y, z} IN barrier s /\ v0 IN s /\ 
 ~(voronoi v0 s INTER conv {x, y, z} = {}) /\
 CARD {x, y, z, v0} = 4
 ==> {v0, x, y, z} IN Q_SYS s`,
NHANH (CUTHE4 TRIANGLE_IN_BARRIER) THEN 
KHANANG THEN 
REWRITE_TAC[OR_IMP_EX] THEN 
REWRITE_TAC[FIRST_NOV22] THEN 
REPEAT GEN_TAC THEN 
MATCH_MP_TAC (MESON[]`(a /\ c ==> d ) ==> a /\ b /\ c ==> d `) THEN 
NHANH (SPEC_ALL IN_BA_IM_PA_SU) THEN 
REWRITE_TAC[MESON[]` a /\ b /\ c ==> d <=> b ==> a /\ c ==> d`] THEN 
NHANH (MESON[DIST_NZ; REAL_ARITH ` &0 < #2.51 /\ ( a < b /\ b < c ==> a < c )`]`
  #2.51 < dist (aa,bb) ==> ~( aa = bb ) `) THEN 
REWRITE_TAC[ MESON[]` a /\ ( b /\ c ) /\ l <=> (a /\ c ) /\ b /\ l`] THEN 
NHANH (SPEC_ALL EXI_THIRD_PO) THEN 
REWRITE_TAC[MESON[]` a/\ b/\ c/\ d <=> c /\ a/\b/\d`] THEN 
STRIP_TAC THEN REPEAT (FIRST_X_ASSUM MP_TAC) THEN 
ONCE_REWRITE_TAC[ EQ_SYM_EQ] THEN 
REWRITE_TAC[MESON[]` a = b ==> P a <=> a = b ==> P b `] THEN 
ONCE_REWRITE_TAC[ EQ_SYM_EQ] THEN 
ONCE_REWRITE_TAC[ SET_RULE ` {x, y, z, v0} = {v0,y,z,x} `] THEN 
REWRITE_TAC[CARD4; GSYM CARD3] THEN 
ONCE_REWRITE_TAC[EQ_SYM_EQ] THEN 
REWRITE_TAC[MESON[]` a = b ==> P a <=> a = b ==> P b `] THEN 
REWRITE_TAC[IMP_IMP] THEN PHA THEN 
REWRITE_TAC[MESON[]` (! a b. P a b ) /\l <=> l/\(!a b. P a b)`] THEN 
PHA THEN 
ONCE_REWRITE_TAC[EQ_SYM_EQ] THEN 
REWRITE_TAC[CARD3] THEN 
NHANH (SET_RULE ` ~(aa = bb \/ bb = z' \/ z' = aa) /\
 (!x' y'.
      ~({x', y'} = {aa, bb}) /\ {x', y'} SUBSET {aa, bb, z'}
      ==> P x' y') ==>
  P bb z' /\ P z' aa `) THEN 
PHA THEN 
REWRITE_TAC[MESON[CARD4]` ~(v0 IN {aa, bb, z'}) /\
 ~(aa = bb \/ bb = z' \/ z' = aa) /\ l <=> CARD {v0,aa,bb,z'} = 4 /\ l `] THEN 
ONCE_REWRITE_TAC[ SET_RULE ` {v0, aa, bb, z'} = {v0,bb,z',aa}`] THEN 
SIMP_TAC[SET_RULE ` {y,z,x} = {x,y,z} `] THEN 
REWRITE_TAC[ GSYM d3; GSYM db_t0] THEN 
REWRITE_TAC[ GSYM d3; GSYM db_t0; SET2_SU_EX] THEN 
REWRITE_TAC[MESON[]` (aa IN {x, y, z} /\ bb IN {x, y, z}) /\a1 /\a2 /\
 &2 * t0 < d3 aa bb /\a3 /\ a4  /\ a5 /\ l <=> (aa IN {x, y, z} /\ bb IN {x, y, z}
  /\ a5 /\ &2 * t0 < d3 aa bb) /\ a1 /\ a2 /\ a3 /\ a4 /\ l `] THEN 
NHANH (SPEC_ALL DIAGONAL_BARRIER) THEN 
NHANH (SPEC_ALL DIA_OF_QUARTER) THEN 
REWRITE_TAC[ GSYM LEFT_AND_EXISTS_THM] THEN 
PHA THEN 
REWRITE_TAC[MESON[]` d3 aa bb <= sqrt (&8) /\ l <=>l/\d3 aa bb <= sqrt (&8)`] THEN 
REWRITE_TAC[MESON[]` a = b /\ P b <=> a = b /\ P a`] THEN 
PHA THEN REWRITE_TAC[MESON[]` ~ ( a INTER b = {}) /\ l <=> l/\ ~ ( a INTER b = {})`]
  THEN PHA THEN 
REWRITE_TAC[SET_RULE` v0 IN s /\
     a1 /\
     {aa, bb, z'} SUBSET s /\
     CARD {v0, aa, bb, z'} = 4 /\
     l /\
     las <=>
     l /\ a1 /\ CARD {v0, aa, bb, z'} = 4 /\ {v0, bb, z', aa} SUBSET s /\ las`] THEN 
ONCE_REWRITE_TAC[MESON[SET_RULE ` {v0, aa, bb, z'} = {v0,bb,z',aa}`]` CARD {v0, aa, bb, z'} =4
  <=> CARD {v0,bb,z',aa} = 4 `] THEN 
ONCE_REWRITE_TAC[INTER_COMM] THEN 
ONCE_REWRITE_TAC[MESON[SET_RULE ` {a,b,c} = {b,c,a}`]`
   conv {a,b,c} = conv {b,c,a} `] THEN 
ONCE_REWRITE_TAC[MESON[D3_SYM]` d3 aa bb <= sqrt (&8) <=> d3 bb aa <= sqrt (&8)`] THEN 
NHANH (SPEC_ALL CEWWWDQ) THEN 
NHANH (REAL_ARITH ` a < b ==> a <= b `) THEN 
ONCE_REWRITE_TAC[MESON[]` ( a/\ b ) /\ c <=> c /\ b /\ a `] THEN 
PHA THEN 
NHANH (MESON[IMP_QUA; D3_SYM]` packing s /\
 CARD {v0, bb, z', aa} = 4 /\
 {v0, bb, z', aa} SUBSET s /\
 d3 bb z' <= &2 * t0 /\
 d3 z' aa <= &2 * t0 /\
 d3 bb aa <= sqrt (&8) /\ a2 /\
 (!x. x IN {bb, z', aa} ==> &2 <= d3 x v0 /\ d3 x v0 <= &2 * t0) /\
 &2 * t0 <= d3 aa bb /\ a1 ==> quarter {v0, bb, z', aa} s`) THEN 
REWRITE_TAC[MESON[]`( ? a. P a ) /\ l <=> l /\ (?a. P a) `] THEN 
REWRITE_TAC[barrier; IN_ELIM_THM] THEN 
REWRITE_TAC[MESON[]` P b /\ a = b <=> a = b /\ P a `] THEN 
REWRITE_TAC[GSYM LEFT_AND_EXISTS_THM] THEN 
PHA THEN 
REWRITE_TAC[MESON[]`( a < b /\ l <=> l /\ a < b ) /\ 
       ( ( x \/ y ) /\ z <=> z /\ ( x \/ y ))`] THEN 
REWRITE_TAC[ MESON[]` a IN s /\ b /\ c <=> c /\ a IN s /\ b `] THEN 
NHANH (SPEC_ALL QUA_TRI_EDGE) THEN 
PHA THEN 
REWRITE_TAC[MESON[real_lt]`&2 * t0 < d3 aa bb /\
     (a1 /\ (!a b. a IN s /\ b IN s ==> d3 a b <= &2 * t0) \/ a2) /\
     aa IN s /\
     bb IN s <=>
     &2 * t0 < d3 aa bb /\ a2 /\ aa IN s /\ bb IN s`] THEN 
NHANH (SPEC_ALL CASES_OF_Q_SYS) THEN 
REWRITE_TAC[LEFT_AND_EXISTS_THM] THEN 
KHANANG THEN 
NHANH (MESON[SET_RULE ` a IN s ==> a IN ( s UNION t )`; QUA_RE_TE_EDGE]`
  quasi_reg_tet ({x, y, z} UNION {v4}) s /\
                 aa IN {x, y, z} /\
                 bb IN {x, y, z} ==> d3 aa bb <= &2 * t0 `) THEN 
DAO THEN 
REWRITE_TAC [REAL_ARITH ` a <= b <=> ~( b < a ) `] THEN 
REWRITE_TAC[MESON[]`(?v4. ~(&2 * t0 < d3 aa bb) /\ P v4 \/ Q v4) /\ a1 /\ &2 * t0 < d3 aa bb <=>
     (?v4. Q v4) /\ a1 /\ &2 * t0 < d3 aa bb`] THEN 
REWRITE_TAC[LEFT_AND_EXISTS_THM] THEN 
PHA THEN 
NHANH (MESON[SET_RULE` a IN s ==> a IN ( s UNION t ) `; DIAGONAL_STRICT_QUA]` 
  bb IN {x, y, z} /\
      aa IN {x, y, z} /\ a1 /\
      strict_qua ({x, y, z} UNION {v4}) s /\
      a2  /\
      &2 * t0 < d3 aa bb /\ l ==> diagonal aa bb ({x, y, z} UNION {v4}) s  `) THEN 
NHANH (MESON[strict_qua]` strict_qua q s /\ l ==> quarter q s `) THEN 
PHA THEN 
REWRITE_TAC[SET_RULE ` {v0, bb, z', aa} = {aa,bb,z'} UNION {v0}`] THEN 
DAO THEN 
REWRITE_TAC[MESON[]` a = b /\ l <=> l/\ a= b `] THEN 
REWRITE_TAC[MESON[]`  quarter q s /\
         &2 * t0 < d3 aa bb /\l <=> &2 * t0 < d3 aa bb /\l /\ quarter q s`] THEN 
PHA THEN 
REWRITE_TAC[MESON[]` quarter ({aa, bb, z'} UNION {v0}) s /\
     a1 /\
      {aa, bb, z'} = {x, y, z} /\ l <=> l /\ a1 /\  {aa, bb, z'} = {x, y, z}
   /\ quarter ({x, y, z} UNION {v0}) s`] THEN 
REWRITE_TAC[MESON[]` a IN Q_SYS s /\ l <=> l /\ a IN Q_SYS s`] THEN 
REWRITE_TAC[MESON[]` a IN s /\ b /\ l <=>l /\ a IN s /\b `] THEN 
REWRITE_TAC[ MESON[]` diagonal aa bb ({x, y, z} UNION {v4}) s /\ l <=>
  l /\ diagonal aa bb ({x, y, z} UNION {v4}) s`] THEN 
PHA THEN 
NHANH (MESON[CONSI_OF_LE77]` quarter ({x, y, z} UNION {v0}) s /\
      aa IN {x, y, z} /\
      bb IN {x, y, z} /\
      {x, y, z} UNION {v4} IN Q_SYS s /\a1/\
      diagonal aa bb ({x, y, z} UNION {v4}) s
  ==> {x, y, z} UNION {v0} IN Q_SYS s`) THEN 
DAO THEN 
REWRITE_TAC[GSYM RIGHT_AND_EXISTS_THM] THEN 
REWRITE_TAC[MESON[SET_RULE ` {x, y, z} UNION {v0}  =  {y, v0, x} UNION {z} `;CASES_OF_Q_SYS]`
  {x, y, z} UNION {v0} IN Q_SYS s /\ last
     ==> {y, v0, x} UNION {z} IN Q_SYS s /\
         quasi_reg_tet ({y, v0, x} UNION {z}) s \/
         {y, v0, x} UNION {z} IN Q_SYS s /\
         strict_qua ({y, v0, x} UNION {z}) s`]);;

(* ========= *)


let POS_EQ_INV_POS = prove(`!x. &0 < x <=> &0 < &1 / x`, GEN_TAC THEN EQ_TAC
THENL [REWRITE_TAC[MESON[REAL_LT_RDIV_0; REAL_ARITH ` &0 < &1 `]`! b.  &0 < b 
   ==> &0 < &1 / b `];REWRITE_TAC[] THEN 
MESON_TAC[MESON[REAL_LT_RDIV_0; REAL_ARITH ` &0 < &1 `]` &0 < b
    ==> &0 < &1 / b `; REAL_FIELD ` &1 / ( &1 / x ) = x ` ]]);;


let STRIP_TR = REPEAT STRIP_TAC THEN REPEAT (FIRST_X_ASSUM MP_TAC)
      THEN REWRITE_TAC[IMP_IMP] THEN PHA;;

let INTER_DIF_EM_EX = SET_RULE `! a b. ~(a INTER b = {}) <=> (? x. x IN a /\ x IN b ) `;;




let AFF_LE_CONE =prove(` ! a b x y z. ~( conv0 {a,b} INTER conv {x,y,z} = {}) 
  ==> ( b IN aff_le {x,y,z} {a}) /\ ( b IN cone a {x,y,z}) `,
REWRITE_TAC[CONV_SET3; CONV0_SET2; INTER_DIF_EM_EX; IN_ELIM_THM] THEN 
REPEAT GEN_TAC THEN STRIP_TAC THEN REPEAT (FIRST_X_ASSUM MP_TAC) THEN 
REWRITE_TAC[IMP_IMP] THEN PHA THEN REWRITE_TAC[MESON[]` x' = aa /\a1
 /\a2 /\a3/\a4 /\ x' = bb <=> x' = aa /\a1 /\a2 /\a3/\a4 /\ aa = bb `] 
THEN REWRITE_TAC[ VECTOR_ARITH ` a + b:real^N = c <=> b = c - a`] THEN 
NHANH (MESON[VECTOR_MUL_LCANCEL]`  b' % b = a ==> (&1 / b') % (b' % b)
  = (&1 / b') % a `) THEN REWRITE_TAC[VECTOR_MUL_ASSOC;
 VECTOR_SUB_LDISTRIB; VECTOR_ADD_LDISTRIB; simp_def] THEN 
NHANH (MESON[POS_EQ_INV_POS]` &0 < a ==> &0 < &1 / a `) THEN 
REWRITE_TAC[VECTOR_ARITH ` a - b % x = a + ( -- b ) % x `] THEN 
MP_TAC (REAL_FIELD `! b.  &0 < b ==>  &1 / b * b = &1 `) THEN 
REWRITE_TAC[IMP_IMP] THEN PHA THEN REWRITE_TAC[REAL_ARITH ` a / b * c 
= (a * c) / b`; REAL_MUL_LID; VECTOR_ARITH ` a - b % x = a + (--b) % x `] THEN 
REWRITE_TAC[REAL_ARITH ` -- ( a / b ) = ( -- a ) / b `] THEN 
NHANH (MESON[REAL_ARITH ` a / m + b / m + c / m + d / m = ( a + b + c + d ) / m `]`
  b' / b' % b = (a'' / b' % x + b'' / b' % y + c / b' % z) + --a' / b' % a
  ==> a'' / b' + b'' / b' + c / b' + -- a' / b' = ( a'' + b'' + c + -- a' ) / b' `)
 THEN NHANH (MESON[REAL_ARITH ` a' + b' = &1 /\  a'' + b'' + c = &1
  ==> a'' + b'' + c + --a' = b' `]` a' + b' = &1 /\a1 /\a2 /\a3 /\a4 /\
   a'' + b'' + c = &1 /\ l  ==> a'' + b'' + c + --a' = b'`) THEN 
MP_TAC (REAL_ARITH ` ! a. a < &0 ==> a <= &0 `) THEN REWRITE_TAC[ IN_ELIM_THM]
 THEN NHANH (MESON[]`(!b. &0 < b ==> b / b = &1) /\ --a' / b' < &0 /\
     &0 < a' /\ &0 < &1 / a' /\ &0 < b' /\ l ==>  b' / b' = &1 `) THEN 
REWRITE_TAC[MESON[] ` a /\ b' / b' = &1 ==> l <=> b' / b' = &1 ==> a ==> l`] THEN 
SIMP_TAC[VECTOR_MUL_LID] THEN PHA THEN NHANH (MESON[REAL_LT_DIV]
` &0 < a' /\ &0 < &1 / a' /\ &0 < b' /\ l ==> &0 < a' / b' `) THEN 
REWRITE_TAC[REAL_ARITH ` &0 < a' / b' <=> --a' / b' < &0 `] THEN 
REWRITE_TAC[ MESON[]` a = x / y /\ x = y <=> a = y/ y /\ x = y `] THEN 
REWRITE_TAC[ VECTOR_ARITH ` ((a:real^N) + b ) + c = a + b + c `] THEN 
STRIP_TR THENL [MESON_TAC[VECTOR_MUL_LID];
REWRITE_TAC[cone; GSYM aff_ge_def; simp_def; IN_ELIM_THM]] THEN 
MP_TAC VECTOR_MUL_LID THEN SIMP_TAC[VECTOR_ARITH ` a + b + c + (d:real^N)
 = b + c + d + a `] THEN REWRITE_TAC[MESON[]` &0 <= a /\ l <=> l /\ &0 <= a `]
 THEN SIMP_TAC[ REAL_ARITH ` a + b + c + d = b + c + d + a `] THEN 
REWRITE_TAC[ MESON[]` &0 < a /\ l <=> l /\ &0 < a `] THEN PHA THEN 
NHANH (MESON[REAL_ARITH ` &0 < b ==> &0 <= b `; REAL_LE_DIV]` &0 <= c /\
     &0 <= b'' /\ &0 <= a'' /\ &0 < b' /\ &0 < a' ==> 
&0 <= a'' / b' /\ &0 <= b''/ b' /\ &0 <= c/ b' `) THEN 
NHANH (MESON[REAL_FIELD `  &0 < b' ==> b' / b' = &1 `]`(&0 <= c /\ &0 
<= b'' /\ &0 <= a'' /\ &0 < b' /\ &0 < a') ==> b' / b' = &1 `) THEN 
REWRITE_TAC[ MESON[]` a / a = &1 /\ l <=> l /\ a / a = &1 `] THEN DAO THEN 
REWRITE_TAC[IMP_IMP] THEN  REWRITE_TAC[ MESON[]`b' / b' = &1 /\ &0 < a' /\
 &0 < b' /\ l <=> &0 < a' /\ l /\ &0 < b' /\ b' / b' = &1  `] THEN 
REWRITE_TAC[ MESON[]` a = (b:real^N) /\ l <=> l /\ b = a `] THEN 
PHA THEN REWRITE_TAC[ MESON[]` aaa = b' / b' % b /\ &0 < b' /\
     b' / b' = &1 <=> &0 < b' /\ b' / b' = &1 /\ aaa = &1 % b `] 
THEN REWRITE_TAC[ VECTOR_MUL_LID] THEN MESON_TAC[]);;


let NOVE30 = prove(`! P l. ( ! x y z i j k s. ( P x y z i j k s <=> P y x z j i k s)
 /\ ( l x y z <=> l y x z ) ) /\ (! x y z i j k s. i <= j /\ P x y z i j k s ==> 
l x y z )   ==> (! x y z i j k s. P x y z i j k s ==> l x y z ) `, 
ONCE_REWRITE_TAC[ MESON[]` a ==> (!x y z i j k s. P x y z i j k s ==> l x y z) <=>
     (a ==> (!x y z i j k s. i <= j /\ P x y z i j k s ==> l x y z)) /\(a ==>
 (!x y z i j k s. ~(i <= j) /\ P x y z i j k s ==> l x y z)) `] THEN REPEAT
GEN_TAC THEN 
CONJ_TAC THENL [MESON_TAC[]; MESON_TAC[REAL_ARITH ` ~( a <= b ) ==> b <= a `]]);;



let NOVE31 = prove(`! P l. ( ! x y z i j k s. ( P x y z i j k s <=> P z y x k j i s )
 /\ ( l x y z <=> l z y x ) ) /\ (! x y z i j k s. i <= j /\ i <= k /\ P x y z i j k s
 ==> l x y z )   ==> (! x y z i j k s. i <= j /\ P x y z i j k s ==> l x y z ) `, 
ONCE_REWRITE_TAC[ MESON[]` a ==> (!x y z i j k s. P x y z i j k s ==> l x y z) <=>
     (a ==> (!x y z i j k s. i <= k /\ P x y z i j k s ==> l x y z)) /\(a ==>
 (!x y z i j k s. ~(i <= k) /\ P x y z i j k s ==> l x y z)) `] THEN REPEAT
GEN_TAC THEN CONJ_TAC THENL [MESON_TAC[];   MESON_TAC[REAL_LE_TRANS; 
REAL_ARITH ` ~( a <= b ) ==> b <= a `]]);;




let IMP_IN_BA = prove(`! x y z a s. {x,y,z} UNION {a} IN Q_SYS s ==> {x,y,z} IN barrier s `,
REWRITE_TAC[barrier; IN_ELIM_THM] THEN MESON_TAC[]);;



let IMP_IN_AFF4  = prove(` ! s v0 xx x y z. xx IN cone v0 {x, y, z} /\
 ~(xx IN UNIONS {aff_ge {v0} {v1, v2} | v1,v2 | barrier s {v0, v1, v2}}) /\
 {v0, x, y, z} IN Q_SYS s ==> xx IN aff_gt {v0} {x, y, z}`, 
REWRITE_TAC[cone; GSYM aff_ge_def; simp_def; IN_ELIM_THM] THEN 
REPLICATE_TAC 3 GEN_TAC THEN REWRITE_TAC[MESON[]` ( ! x y z. (? s i j k.
 P s i j k x y z ) /\ Q x y z ==> l x y z) <=> ( ! x y z i j k s. 
P s i j k x y z /\ Q x y z ==> l x y z ) `] THEN MATCH_MP_TAC NOVE30 THEN 
CONJ_TAC THENL [MESON_TAC[PER_SET3; REAL_ARITH ` a + b + c = b + a + c ` ;
  VECTOR_ARITH `(a:real^N ) + b + c = b + a + c `]; MATCH_MP_TAC NOVE31 THEN 
CONJ_TAC]THENL [MESON_TAC[PER_SET3; REAL_ARITH ` a + b + c = c + b + a ` ;
 VECTOR_ARITH `(a:real^N ) + b + c = c + b + a `]; PHA] THEN 
REWRITE_TAC[MESON[REAL_ARITH ` &0 <= i <=> i = &0 \/ &0 < i `]`
  &0 <= i /\ &0 <= j /\ &0 <= k /\ l <=> ( i = &0 \/ &0 < i ) /\ &0 <= j /\
   &0 <= k /\ l `] THEN KHANANG THEN REPEAT GEN_TAC THEN 
STRIP_TAC THENL [REPEAT (FIRST_X_ASSUM MP_TAC) THEN REPLICATE_TAC 3 DISCH_TAC
 THEN REWRITE_TAC[IMP_IMP] THEN ASM_SIMP_TAC[] THEN REWRITE_TAC[VECTOR_MUL_LZERO; 
VECTOR_ADD_LID; REAL_ADD_LID] THEN REWRITE_TAC[SET_RULE ` {v0, x, y, z} = {v0,y,z}
 UNION {x} `] THEN NHANH (SPEC_ALL IMP_IN_BA) THEN REWRITE_TAC[IN_UNIONS; 
IN_ELIM_THM] THEN REWRITE_TAC[MESON[IN]` barrier s a /\ l <=> a IN barrier s /\ 
l`] THEN PHA THEN REWRITE_TAC[MESON[]` (? t. (? v1 v2 . P v1 v2 /\ t = Q v1 v2 ) 
/\ xx IN t )  <=> (? v1 v2. P v1 v2 /\ xx IN Q v1 v2 ) `] THEN REWRITE_TAC[IN_ELIM_THM]
 THEN MESON_TAC[]; STRIP_TR THEN REWRITE_TAC[MESON[REAL_ARITH ` i <= j /\ &0 < i 
==> &0 < j `]`  i <= j /\ i <= k /\ &0 < i /\l  <=> i <= j /\ i <= k /\ &0 < j /\
 &0 < k /\ &0 < i /\ l`] THEN MESON_TAC[]]);;





let VORO2_EX =prove(`! v0 s. voro2 v0 s = {x | (!w. s w /\ ~(w = v0) ==>
  d3 x v0 < d3 x w) /\ d3 x v0 < &2} `, REWRITE_TAC[voro2; voronoi; d3 ] 
 THEN SET_TAC[]);;



let LEMMA81 = prove(`!(X:real^3 -> bool) Z s v0:real^3 .
     centered_pac s v0 /\
     Z = UNIONS {aff_ge {v0} {v1, v2} | v1,v2 | {v0, v1, v2} IN barrier s} /\
     X = UNIONS
     {aff_gt {v0} {v1, v2, v3} INTER
      aff_le {v1, v2, v3} {v0} INTER
      voro2 v0 s | v1,v2,v3 | {v0, v1, v2, v3} IN Q_SYS s}
     ==> voro2 v0 s SUBSET X UNION Z UNION VC v0 s`,
REPEAT GEN_TAC THEN ONCE_REWRITE_TAC[SET_RULE ` as SUBSET a UNION b UNION c <=> 
( as DIFF (b UNION c))   SUBSET a`] THEN REWRITE_TAC[SUBSET; IN_DIFF; IN_UNION;
 VC; lambda_x; IN_ELIM_THM; voro2;voronoi; GSYM d3;  DE_MORGAN_THM; centered_pac]
 THEN ABBREV_TAC ` ketluan x  = ((x:real^3) IN (X:real^3 -> bool))` THEN SIMP_TAC[]
 THEN PHA THEN REWRITE_TAC[MESON[]` a /\b/\e/\c==>d <=> c ==> a/\b/\e==>d`] THEN
 DISCH_TAC THEN REWRITE_TAC[GSYM (MESON[]` a /\b/\e/\c==>d <=> c ==> a/\b/\e==>d`)] 
THEN REWRITE_TAC[MESON[trg_d3_sym]` d3 x v0 < &2 /\ aa/\
          ((~(d3 v0 x < &2) \/ l) \/ l') <=> d3 x v0 < &2 /\ aa/\ (l\/ l')`; IN] THEN 
PHA THEN REWRITE_TAC[MESON[]` (!w. s w /\ ~(w = v0) ==> d3 x v0 < d3 x w) /\
 aa /\ bb /\ (cc \/ ~(!w. s w /\ dd w /\ ee w /\ ~(w = v0) ==> d3 x v0 < d3 x w)) <=>
     (!w. s w /\ ~(w = v0) ==> d3 x v0 < d3 x w) /\ aa /\ bb /\ cc`] THEN 
REWRITE_TAC[obstruct] THEN ONCE_REWRITE_TAC[BAR_TRI] THEN 
REWRITE_TAC[ MESON[]`(?bar. (?x y z. bar = {x, y, z} /\ P {x, y, z}) /\ Q bar) <=>
     (?x y z. P {x, y, z} /\ Q {x, y, z})`] THEN NHANH (MESON[]` ~(conv0 {v0, x} INTER 
conv {x', y, z} = {}) ==>  v0 IN {x' ,y,z} \/ ~( v0 IN {x', y,z})`) THEN KHANANG THEN 
NHANH (MESON[IN_SET3; SET_RULE` x = a ==> {x,b,c} = {a,b,c} /\ {x,b,c} = {b,c,a} /\
 {x,b,c} = {b,a,c}  `]`  x IN {a,b,c} ==> (? yy zz. {x,yy,zz} = {a,b,c})`) THEN 
REWRITE_TAC[EXISTS_OR_THM] THEN NGOAC THEN REWRITE_TAC[MESON[]`(?x' y z. P {x', y, z} 
/\ (?yy zz. {x, yy, zz} = {x', y, z})) <=> (?y z. P {x, y, z})`] THEN 
NHANH (CUTHE4 IN_AFF_GE_CON) THEN PHA THEN 
REWRITE_TAC[SET_RULE`  ~UNIONS {aff_ge {v0} {v1, v2} | v1,v2 | barrier s {v0, v1, v2}} x /\
((?y z. {v0, y, z} IN barrier s /\ aaa y z /\ x IN aff_ge {v0} {y, z} /\
 bbb y z) \/  last) <=> ~UNIONS {aff_ge {v0} {v1, v2} | v1,v2 | barrier s {v0, v1, v2}} x /\
     last`] THEN REWRITE_TAC[DE_MORGAN_THM] THEN SIMP_TAC[GSYM NOV20] THEN 
REWRITE_TAC[d3; GSYM IN_VO_EQ] THEN NHANH (MESON[X_IN_VOR_X; VORONOI_CONV]` x IN voronoi v0 s 
   ==> v0 IN voronoi v0 s /\ convex (voronoi v0 s )`) THEN 
NHANH (MESON[CONVEX_IM_CONV02_SU ]` x IN voronoi v0 s /\    v0 IN voronoi v0 s /\
 convex (voronoi v0 s) ==> conv0 {v0,x} SUBSET voronoi v0 s `) THEN PHA THEN 
DISCH_TAC THEN GEN_TAC THEN STRIP_TAC THENL [REPEAT (FIRST_X_ASSUM MP_TAC) THEN 
REWRITE_TAC[ IMP_IMP] THEN PHA THEN NHANH (SET_RULE` conv0 {v0, x} SUBSET voronoi v0 s 
/\a1  /\a2  /\a3  /\ ~(conv0 {v0, x} INTER conv {x', y, z} = {}) /\ l ==>
  ~( voronoi v0 s INTER conv {x', y, z} = {})`) THEN NHANH (MESON[FOUR_POINTS]
` {x', y, z} IN barrier s /\ a1 /\   ~(v0 IN {x', y, z}) ==> CARD {x',y,z, v0} = 4 `)
 THEN PHA THEN NHANH (SET_RULE `  conv0 {v0, x} SUBSET s /\ a1 /\a2 /\a3 /\
 ~(conv0 {v0, x} INTER s1  = {}) /\ l ==> ~( s INTER s1 = {}) `) THEN PHA THEN 
REWRITE_TAC[MESON[]`( s x /\ l <=>l/\ s x)/\ (a IN barrier s /\ l <=>
   l /\ a IN barrier s) `] THEN NHANH (SPEC_ALL (REWRITE_RULE[CONV3_EQ] IN_AFF_GE_CON))
 THEN PHA THEN REWRITE_TAC[SET_RULE ` ~UNIONS {aff_ge {v0} {v1, v2} | v1,v2 | 
  barrier s {v0, v1, v2}} x /\  a1 /\ x IN aff_ge {v0} {y, z} /\
   a2 /\ a3/\ {v0, y, z} IN barrier s /\ a4 <=> F `] ; REPEAT (FIRST_X_ASSUM MP_TAC)]
 THEN REWRITE_TAC[ IMP_IMP] THEN PHA THEN 
NHANH (SET_RULE` conv0 {v0, x} SUBSET voronoi v0 s /\a1  /\a2  /\a3  /\
 ~(conv0 {v0, x} INTER conv {x', y, z} = {}) /\ l ==>
  ~( voronoi v0 s INTER conv {x', y, z} = {})`) THEN 
NHANH (MESON[FOUR_POINTS]` {x', y, z} IN barrier s /\ a1 /\ 
  ~(v0 IN {x', y, z}) ==> CARD {x',y,z, v0} = 4 `) THEN PHA THEN NHANH (SET_RULE ` 
 conv0 {v0, x} SUBSET s /\ a1 /\a2 /\a3 /\ ~(conv0 {v0, x} INTER s1  = {}) /\ l 
==> ~( s INTER s1 = {}) `) THEN PHA THEN REWRITE_TAC[MESON[]`( s x /\ l <=>l/\
 s x)/\ (a IN barrier s /\ l <=>   l /\ a IN barrier s) `] THEN PHA THEN 
NHANH (MESON[IMP_IN_Q_SYS; IN]` CARD {x', y, z, v0} = 4 /\
 ~(voronoi v0 s INTER conv {x', y, z} = {}) /\ {x', y, z} IN barrier s /\
 s v0 ==> {v0,x',y,z} IN Q_SYS s `) THEN NHANH (SPEC_ALL AFF_LE_CONE) THEN PHA THEN 
ONCE_REWRITE_TAC[MESON[IN] ` ~ UNIONS s x <=> ~ ( x IN UNIONS s ) `] THEN 
ONCE_REWRITE_TAC[MESON[]` a1 /\a /\ b /\ x IN cone v0 {x', y, z} /\ l <=>a /\ b /\ l /\
  x IN cone v0 {x', y, z} /\ a1 `] THEN PHA THEN REWRITE_TAC[MESON[]` a IN Q_SYS s /\
 b /\ c <=> b /\ c /\ a IN Q_SYS s`] THEN NHANH (SPEC_ALL IMP_IN_AFF4) THEN 
NGOAC THEN REWRITE_TAC[MESON[]` (a /\ b ) /\ x IN aff_gt {v0} {x', y, z} <=> 
  x IN aff_gt {v0} {x', y, z}/\ b/\ a `] THEN PHA THEN DAO THEN 
REWRITE_TAC[GSYM VORO2_EX] THEN REWRITE_TAC[prove(`dist (x,v0) < &2 /\a1/\a2/\a3 /\
x IN voronoi v0 s /\ l  <=> a1/\a2/\a3 /\ l /\ x IN voro2 v0 s`, REWRITE_TAC[GSYM d3; 
  voro2; IN_ELIM_THM] THEN MESON_TAC[])] THEN REWRITE_TAC[MESON[]`x IN aff_le a s /\
 l <=> l /\ x IN aff_le a s `] THEN DAO THEN ONCE_REWRITE_TAC[EQ_SYM_EQ] THEN 
SIMP_TAC[] THEN ONCE_REWRITE_TAC[MESON[]` (! x. P x ) /\ a = b /\ l <=> b = a /\ l /\ 
  (! x . P x )`] THEN SIMP_TAC[] THEN MATCH_MP_TAC (MESON[]` ( a1 /\a2/\a3/\a4 ==> l ) 
==> ( a1/\a2/\a3/\a4/\a5 ==> l ) `) THEN REWRITE_TAC[IN_UNIONS; IN_ELIM_THM] THEN 
REWRITE_TAC[ MESON[]` (?t. (? a b c. P a b c /\ t = Q a b c ) /\ x IN t )
  <=> (? a b c. P a b c /\ x IN Q a b c ) `] THEN REWRITE_TAC[IN_INTER] THEN 
SET_TAC[]);;
