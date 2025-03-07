open Printf

let position lexbuf =
  let curr = lexbuf.Lexing.lex_curr_p in
  let file = curr.Lexing.pos_fname in
  let line = curr.Lexing.pos_lnum in
  let char = curr.Lexing.pos_cnum - curr.Lexing.pos_bol in
    if file = "" then
      () (* lexbuf information is rarely accurate at the toplevel *)
    else
      print_string "";Format.sprintf ": line %d, character %d" line char

let _ =
  let file_name = Sys.argv.(1) in
  let mod_name = Sys.argv.(2) in
  let file = open_in file_name in
  let lexbuf = Lexing.from_channel file in 
  let proof_dag = ref (Proof.DAG.create ()) in
  try
    while true do
      proof_dag := Tstpparser.proof Tstplexer.tstpproof lexbuf
      (*print_string result; print_newline (); flush stdout*)
    done
  with 
    | Tstplexer.EoF ->
      let mod_file = open_out (mod_name ^ ".mod") in
      let sig_file = open_out (mod_name ^ ".sig") in
      fprintf mod_file "%s" (Proof.printCertMod !proof_dag mod_name);
      fprintf sig_file "%s" (Proof.printCertSig !proof_dag mod_name);
      close_out mod_file;
      close_out sig_file;
      exit 0
    | Parsing.Parse_error ->  
      Format.printf "Syntax error while parsing file %s at %s.\n%!" file_name (position lexbuf); 
      exit 1
    | Failure str -> 
      Format.printf ("Failure in file %s at %s.\n%!") file_name (position lexbuf); 
      print_endline str; 
      exit 1
;;
