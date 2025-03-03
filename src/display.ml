open Printf
open Types

(* ANSI escape codes *)
let ansi_red = "\027[31m"
let ansi_reset = "\027[0m"

let with_color str = sprintf "%s%s%s" ansi_red str ansi_reset

let display_tape tape head =
  let chars = 
    List.init (Bytes.length tape) (fun i ->
      let c = Bytes.get tape i |> String.make 1 in
      if i = head then with_color c else c
    )
  in
  printf "[%s]" (String.concat "" chars)

let display_step tape head current_state transition =
  display_tape tape head;
  printf " (%s, %c) -> (%s, %c, %s)\n"
    current_state transition.read
    transition.to_state transition.write (string_of_direction transition.action)

let display_transitions machine =
  Hashtbl.iter (fun state transitions ->
    List.iter (fun t ->
      printf "(%s, %c) -> (%s, %c, %s)\n"
        state t.read t.to_state t.write (string_of_direction t.action)
    ) transitions
  ) machine.transitions

let make_header width name =
  let padding = (width - 2 - String.length name) / 2 in
  let left_pad = padding + (if String.length name mod 2 = 1 then 1 else 0) in
  let border = String.make width '*' in
  let empty = sprintf "*%s*" (String.make (width - 2) ' ') in
  let title = sprintf "*%s%s%s*"
    (String.make left_pad ' ')
    name
    (String.make padding ' ')
  in
  String.concat "\n" [border; empty; title; empty; border]

let format_list items =
  sprintf "[ %s ]" (String.concat ", " items)

let display_machine machine =
  (* Display header *)
  printf "%s\n" (make_header 80 machine.name);

  (* Display machine properties *)
  printf "Alphabet : %s\n" (format_list (List.map (String.make 1) machine.alphabet));
  printf "States   : %s\n" (format_list machine.states);
  printf "Initial  : %s\n" machine.initial;
  printf "Finals   : %s\n" (format_list machine.finals);

  (* Display transitions *)
  display_transitions machine;

  (* Display footer *)
  printf "%s\n" (String.make 80 '*')
