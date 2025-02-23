open Types

(** Parse command line arguments and return a record with the parsed values *)
val parse_args : unit -> args

(** Display usage message and exit *)
val show_usage : unit -> 'a
