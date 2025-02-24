type transition = {
	read : char;			(* character to read *)
	to_state : string;(* state to transition to *)
	write : char;			(* character to write *)
	action : string;	(* action: "LEFT" or "RIGHT" *)
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
