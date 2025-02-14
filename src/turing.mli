type turing_machine

val parse_machine : Yojson.Basic.t -> turing_machine
val simulate_machine : turing_machine -> string -> unit
