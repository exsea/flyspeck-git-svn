(* ========================================================================= *)
(*                          The Jordan Curve Theorem                         *)
(*                                                                           *)
(*                             Proof by Tom Hales                            *)
(*                                                                           *)
(*           A few tweaks by John Harrison for the latest HOL Light          *)
(* ========================================================================= *)

(*** Standard HOL Light library ***)


(*** New stuff ***)

needs "Rqe/num_calc_simp.ml";;  

flyspeck_needs "jordan/tactics_refine.ml";; 
flyspeck_needs "jordan/lib_ext.ml";; 
flyspeck_needs "jordan/tactics_fix.ml";; 
flyspeck_needs "jordan/parse_ext_override_interface.ml";; 
flyspeck_needs "jordan/tactics_ext.ml";; 
flyspeck_needs "jordan/num_ext_gcd.ml";; 
flyspeck_needs "jordan/num_ext_nabs.ml";;   
flyspeck_needs "jordan/real_ext_geom_series.ml";; 
flyspeck_needs "jordan/real_ext.ml";;  
flyspeck_needs "jordan/float.ml";; 
flyspeck_needs "jordan/tactics_ext2.ml";; 
flyspeck_needs "jordan/misc_defs_and_lemmas.ml";; 

(*  (* need to be reworked.  These don't currently load *)
flyspeck_needs "Jordan/compute_pi.ml";;
flyspeck_needs "Jordan/metric_spaces.ml";;
flyspeck_needs "Jordan/jordan_curve_theorem.ml";;
*)
