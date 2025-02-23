(* External dependencies *)
open Yojson.Basic.Util

(* Local modules *)
open Types
open Validate

(* Parse a JSON description into a Turing machine type *)
let parse_machine json =
  let name = json |> member "name" |> to_string in
  let alphabet = json |> member "alphabet" |> to_list |> filter_string |> validate_alphabet in
  let blank = json |> member "blank" |> to_string |> fun b -> validate_blank b alphabet in
  let states = json |> member "states" |> to_list |> filter_string in
  let initial = json |> member "initial" |> to_string |> fun i -> validate_initial i states in
  let finals = json |> member "finals" |> to_list |> filter_string |> fun f -> validate_finals f states in

  (* Read transitions *)
  let transitions = Hashtbl.create 10 in
	let transitions_json = json |> member "transitions" |> to_assoc |> fun t -> validate_transitions t states in
    List.iter (fun (state, ts) ->
        let ts_list = ts |> to_list |> List.map (fun t ->
            {
                read = t |> member "read" |> to_string |> (fun r -> validate_read r alphabet);
                to_state = t |> member "to_state" |> to_string |> (fun s -> validate_state s states);
                write = t |> member "write" |> to_string |> (fun w -> validate_write w alphabet);
                action = t |> member "action" |> to_string |> validate_action;
            }
        ) in
        Hashtbl.add transitions state ts_list
    ) transitions_json;

	(* Construct the Turing machine record *)
	{ name; alphabet; blank; states; initial; finals; transitions }