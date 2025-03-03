(* External dependencies *)
open Yojson.Basic.Util

(* Local modules *)
open Types
open Validate

let parse_transition alphabet states t =
  let read =
    t |> member "read" |> to_string
    |> fun r -> validate_read r alphabet in
  let to_state =
    t |> member "to_state" |> to_string
    |> fun s -> validate_state s states in
  let write =
    t |> member "write" |> to_string
    |> fun w -> validate_write w alphabet in
  let action =
    t |> member "action" |> to_string |> direction_of_string in

  { read; to_state; write; action }

let create_transitions_table transitions_json alphabet states =
  let parse_state_transitions (state, ts) =
    let ts_list =
      ts |> to_list
      |> List.map (parse_transition alphabet states) in
    (state, ts_list)
  in
  transitions_json
  |> List.map parse_state_transitions
  |> List.fold_left (fun tbl (state, ts) ->
    Hashtbl.add tbl state ts;
    tbl
  ) (Hashtbl.create 10)

let parse_machine json =
  let name =
    json |> member "name" |> to_string in
  let alphabet =
    json |> member "alphabet" |> to_list |> filter_string
    |> validate_alphabet in
  let blank =
    json |> member "blank" |> to_string
    |> fun b -> validate_blank b alphabet in
  let states =
    json |> member "states" |> to_list |> filter_string in
  let initial =
    json |> member "initial" |> to_string
    |> fun i -> validate_initial i states in
  let finals =
    json |> member "finals" |> to_list |> filter_string
    |> fun f -> validate_finals f states in
  let transitions =
    json |> member "transitions" |> to_assoc
    |> fun t -> validate_transitions t states
    |> fun t -> create_transitions_table t alphabet states in

  { name; alphabet; blank; states; initial; finals; transitions }
