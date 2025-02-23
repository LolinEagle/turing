(* Standard library *)
open Printf
open String

(* Local modules *)
open Types
open Validate

let display_transitions machine =
	Hashtbl.iter (fun state transitions ->
		List.iter (fun t ->
			printf "(%s, %c) -> (%s, %c, %s)\n"
				state t.read t.to_state t.write t.action
		) transitions
	) machine.transitions

let display_machine machine =
	let padding = 39 - length machine.name / 2 in
	printf "%s\n*%s*\n" (make 80 '*') (make 78 ' ');
	printf "*%s%s%s*\n"
		(make (padding - length machine.name mod 2) ' ') machine.name
		(make padding ' ');
	printf "*%s*\n%s\n" (make 78 ' ') (make 80 '*');
	printf "Alphabet : [ %s ]\n"
		(concat ", " (List.map (make 1) machine.alphabet));
	printf "States   : [ %s ]\n" (concat ", " machine.states);
	printf "Initial  : %s\n" machine.initial;
	printf "Finals   : [ %s ]\n" (concat ", " machine.finals);
	display_transitions machine;
	printf "%s\n" (make 80 '*')

(* Simulate the Turing machine *)
let simulate_machine machine input_tape =

  (* Validate input before simulation *)
  validate_input machine.alphabet machine.blank input_tape;

	(* Display the machine details *)
	display_machine machine;

	(* Tape representation *)
	let tape = Bytes.of_string (input_tape ^ (make 8 machine.blank)) in
	let tape_length = Bytes.length tape in			(* Gets the length of the tape *)
	let head = ref 0 in													(* Current head position *)
	let current_state = ref machine.initial in	(* Current state *)

	let display_state transition =
		printf "[";
		for i = 0 to tape_length - 1 do
			if i = !head then printf "\027[31m%c\027[0m" (Bytes.get tape i)
			else printf "%c" (Bytes.get tape i)
		done;
		printf "] (%s, %c) -> (%s, %c, %s)\n" !current_state transition.read
			transition.to_state transition.write transition.action
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
					display_state trans;
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
					failwith (sprintf "No transition for state %s and read %c"
						!current_state read_char)
			)
		| None ->
				failwith (sprintf "Invalid state: %s" !current_state)
	done;
	printf "[";
	for i = 0 to tape_length - 1 do
		if i = !head then printf "\027[31m%c\027[0m" (Bytes.get tape i)
		else printf "%c" (Bytes.get tape i)
	done;
	printf "] (%s, %c)\n" !current_state (Bytes.get tape !head)
