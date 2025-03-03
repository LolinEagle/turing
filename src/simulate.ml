(* Standard library *)
open Printf
open String

(* Local modules *)
open Display
open Types
open Validate

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

	(* Simulation logic remains the same *)
	while not (List.mem !current_state machine.finals) do
		(* Reads the character at the head position, defaulting to the blank char *)
		let read_char = try Bytes.get tape !head with _ -> machine.blank in
		(* Finds the transitions for the current state *)
		match Hashtbl.find_opt machine.transitions !current_state with
		| Some ts -> (
				try
					(* Finds the transition that matches the read character *)
					let transition = List.find (fun t -> t.read = read_char) ts in
					(* Display the state of the machine *)
					display_step tape !head !current_state transition;
					(* Writes the character specified by the transition to the tape *)
					Bytes.set tape !head transition.write;
					(* Moves the head left or right based on the transition action *)
					head := (
						match transition.action with
						| Left -> max 0 (!head - 1)
						| Right -> min (tape_length - 1) (!head + 1)
					);
					current_state := transition.to_state;
				with Not_found ->
					failwith (sprintf "No transition for state %s and read %c"
						!current_state read_char)
			)
		| None ->
				failwith (sprintf "Invalid state: %s" !current_state)
	done;
	display_tape tape !head;
	printf " (%s, %c)\n" !current_state (Bytes.get tape !head)
