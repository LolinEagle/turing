(* Standard library *)
open Printf

(* External dependencies *)
open Yojson.Basic

(* Local modules *)
open Cli
open Parse
open Simulate

let () =
	let (machine_file, input_tape) = parse_args () in
	try
		let machine_json = from_file machine_file in
		let machine = parse_machine machine_json in
		simulate_machine machine input_tape
	with
	| e -> printf "Error: %s\n" (Printexc.to_string e)
