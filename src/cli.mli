(** Parse command line arguments and return a tuple with (machine_file, input) *)
val parse_args : unit -> string * string

(** Display usage message and exit *)
val show_usage : unit -> 'a
