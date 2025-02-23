(* Standard library *)
open Printf

(* External dependencies *)
open Yojson.Basic

(* Local modules *)
open Cli
open Parse
open Simulate

let () =
  let args = parse_args () in
  try
    let machine_json = from_file args.machine_file in
    let machine = parse_machine machine_json in
    simulate_machine machine args.input
  with
  | e -> printf "Error: %s\n" (Printexc.to_string e)
