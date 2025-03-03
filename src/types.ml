type direction = Left | Right

type transition = {
	read : char;			(* character to read *)
	to_state : string;(* state to transition to *)
	write : char;			(* character to write *)
	action : direction;	(* action: "LEFT" or "RIGHT" *)
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

let direction_of_string = function
  | "LEFT" -> Left
  | "RIGHT" -> Right
  | s -> failwith (Printf.sprintf "Invalid direction: '%s'. Must be 'LEFT' or 'RIGHT'" s)

let string_of_direction = function
  | Left -> "LEFT"
  | Right -> "RIGHT"