open Yojson.Basic.Util

(* Types for the Turing machine description *)
type transition = {
	read : char;				(* character to read *)
	to_state : string;	(* state to transition to *)
	write : char;				(* character to write *)
	action : string;		(* action: "LEFT" or "RIGHT" *)
}

type turing_machine = {
	name : string;
	alphabet : char list;
	blank : char;
	states : string list;
	initial : string;
	finals : string list;
	transitions : (string, transition list) Hashtbl.t;
}

let validate_alphabet alphabet_strings =
  List.map (fun s ->
    if String.length s <> 1 then
      failwith (Printf.sprintf "Alphabet entry '%s' must be a single character" s)
    else s.[0]
  ) alphabet_strings

let validate_blank blank_str alphabet =
  let blank =
    if String.length blank_str <> 1 then
      failwith "Blank must be a single character"
    else blank_str.[0]
  in
  if not (List.mem blank alphabet) then
    failwith "Blank character must be part of the alphabet";
  blank

let validate_finals finals states =
  List.iter (fun final ->
    if not (List.mem final states) then
      failwith (Printf.sprintf "Final state '%s' must be part of the states" final)
  ) finals;
  finals

let validate_initial initial states =
  if not (List.mem initial states) then
    failwith (Printf.sprintf "initial state '%s' must be part of the states" initial)
  else
    initial

let validate_transitions transitions_json states =
  List.iter (fun (state, _) ->
    if not (List.mem state states) then
      failwith (Printf.sprintf "Transition '%s' must be part of the states" state)
  ) transitions_json;
  transitions_json

let validate_read read alphabet =
  if String.length read <> 1 then
    failwith (Printf.sprintf "read value '%s' must be a single character" read);
  let read_char = read.[0] in
  if not (List.mem read_char alphabet) then
    failwith (Printf.sprintf "read value '%c' must be part of the alphabet" read_char)
  else
    read_char

let validate_write write alphabet =
  if String.length write <> 1 then
    failwith (Printf.sprintf "write value '%s' must be a single character" write);
  let write_char = write.[0] in
  if not (List.mem write_char alphabet) then
    failwith (Printf.sprintf "write value '%c' must be part of the alphabet" write_char)
  else
    write_char

let validate_state state states =
  if not (List.mem state states) then
    failwith (Printf.sprintf "state '%s' must be part of the states" state)
  else
    state

let validate_action action =
    if (action = "LEFT" || action = "RIGHT") then
        action
    else
        failwith (Printf.sprintf "Action '%s' must be LEFT or RIGHT" action)

let validate_input alphabet blank input =
  String.iter (fun c ->
    if not (List.mem c alphabet) then
      failwith (Printf.sprintf "Input character '%c' must be part of the alphabet" c)
    else if c = blank then
      failwith (Printf.sprintf "Input cannot contain blank character '%c'" c)
  ) input

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

let display_transitions machine =
	Hashtbl.iter (fun state transitions ->
		List.iter (fun t ->
			Printf.printf "(%s, %c) -> (%s, %c, %s)\n"
				state t.read t.to_state t.write t.action
		) transitions
	) machine.transitions

(* Simulate the Turing machine *)
let simulate_machine machine input =
  (* Validate input before simulation *)
  validate_input machine.alphabet machine.blank input;

	(* Tape representation *)
	let tape = Bytes.of_string input in					(* Converts the input string *)
	let tape_length = Bytes.length tape in			(* Gets the length of the tape *)
	let head = ref 0 in													(* Current head position *)
	let current_state = ref machine.initial in	(* Current state *)

	(* Print machine details *)
	let padding = 39 - String.length machine.name / 2 in
	Printf.printf "%s\n*%s*\n" (String.make 80 '*') (String.make 78 ' ');
	Printf.printf "*%s%s%s*\n"
		(String.make (padding - String.length machine.name mod 2) ' ') machine.name
		(String.make padding ' ');
	Printf.printf "*%s*\n%s\n" (String.make 78 ' ') (String.make 80 '*');
	Printf.printf "Alphabet : [ %s ]\n"
		(String.concat ", " (List.map (String.make 1) machine.alphabet));
	Printf.printf "States   : [ %s ]\n" (String.concat ", " machine.states);
	Printf.printf "Initial  : %s\n" machine.initial;
	Printf.printf "Finals   : [ %s ]\n" (String.concat ", " machine.finals);
	display_transitions machine;
	Printf.printf "%s\n" (String.make 80 '*');

  let display_state (transition) =
		Printf.printf "[";
		for i = 0 to tape_length - 1 do
			if i = !head then Printf.printf "\027[31m%c\027[0m" (Bytes.get tape i)
			else Printf.printf "%c" (Bytes.get tape i)
			done;
			Printf.printf "] (%s, %c) -> (%s, %c, %s)\n" !current_state
				(Bytes.get tape !head) transition.to_state transition.write
				transition.action
	in

	(* Simulation logic remains the same *)
	while not (List.mem !current_state machine.finals) do
		(* Reads the character at the head position, defaulting to the blank char *)
		let read_char = try Bytes.get tape !head with _ -> machine.blank in
		(* Finds the transitions for the current state *)
		match Hashtbl.find_opt machine.transitions !current_state with
		| Some ts -> (
				try
					(* Finds the transition that matches the read character *)
					let trans = List.find (fun t -> t.read = read_char) ts in
					(* Display the state of the machine *)
					display_state (trans);
					(* Writes the character specified by the transition to the tape *)
					Bytes.set tape !head trans.write;
					(* Moves the head left or right based on the transition action *)
					head := (
						match trans.action with
						| "LEFT" -> max 0 (!head - 1)
						| "RIGHT" -> min (tape_length - 1) (!head + 1)
						| _ -> failwith "Invalid action"
					);
					current_state := trans.to_state;
				with Not_found ->
					failwith (Printf.sprintf "No transition for state %s and read %c"
						!current_state read_char)
			)
		| None ->
				failwith (Printf.sprintf "Invalid state: %s" !current_state)
	done;
	Printf.printf "Machine halted in state: %s\n" !current_state
