(* Standard library *)
open Printf
open Sys

(* External dependencies *)
open Yojson.Basic

(* Local modules *)
open Parse
open Simulate

let () =

  if Array.length argv <> 3 || argv.(1) = "-h" || argv.(1) = "--help" then (
    Printf.printf "usage: ft_turing [-h] jsonfile input\n";
    Printf.printf "positional arguments:\n";
    Printf.printf "jsonfile   json description of the machine\n";
    Printf.printf "input      input of the machine\n";
    Printf.printf "optional arguments:\n";
    Printf.printf "-h, --help show this help message and exit\n";
    exit 0
  );
  if String.length argv.(2) <= 0 then (
    Printf.printf "The input cannot be an empty string\n";
    exit 0
  );

  let machine_file = argv.(1) in
  let input = argv.(2) in

  try
    let machine_json = from_file machine_file in
    let machine = parse_machine machine_json in
    simulate_machine machine input
  with
  | e -> printf "Error: %s\n" (Printexc.to_string e);
