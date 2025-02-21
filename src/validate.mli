val validate_alphabet : string list -> char list
val validate_blank : string -> char list -> char
val validate_finals : string list -> string list -> string list
val validate_initial : string -> string list -> string
val validate_transitions : (string * Yojson.Basic.t) list -> string list -> (string * Yojson.Basic.t) list
val validate_read : string -> char list -> char
val validate_write : string -> char list -> char
val validate_state : string -> string list -> string
val validate_action : string -> string
val validate_input : char list -> char -> string -> unit
