open Printf

let validate_alphabet alphabet_strings =
  List.map (fun s ->
    if String.length s <> 1 then
      failwith (sprintf "Alphabet entry '%s' must be a single character" s)
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
      failwith (sprintf "Final state '%s' must be part of the states" final)
  ) finals;
  finals

let validate_initial initial states =
  if not (List.mem initial states) then
    failwith (sprintf "initial state '%s' must be part of the states" initial)
  else
    initial

let validate_transitions transitions_json states =
  List.iter (fun (state, _) ->
    if not (List.mem state states) then
      failwith (sprintf "Transition '%s' must be part of the states" state)
  ) transitions_json;
  transitions_json

let validate_read read alphabet =
  if String.length read <> 1 then
    failwith (sprintf "read value '%s' must be a single character" read);
  let read_char = read.[0] in
  if not (List.mem read_char alphabet) then
    failwith (sprintf "read value '%c' must be part of the alphabet" read_char)
  else
    read_char

let validate_write write alphabet =
  if String.length write <> 1 then
    failwith (sprintf "write value '%s' must be a single character" write);
  let write_char = write.[0] in
  if not (List.mem write_char alphabet) then
    failwith (sprintf "write value '%c' must be part of the alphabet" write_char)
  else
    write_char

let validate_state state states =
  if not (List.mem state states) then
    failwith (sprintf "state '%s' must be part of the states" state)
  else
    state

let validate_action action =
  if (action = "LEFT" || action = "RIGHT") then
    action
  else
    failwith (sprintf "Action '%s' must be LEFT or RIGHT" action)

let validate_input alphabet blank input =
  String.iter (fun c ->
    if not (List.mem c alphabet) then
      failwith (sprintf "Input character '%c' must be part of the alphabet" c)
    else if c = blank then
      failwith (sprintf "Input cannot contain blank character '%c'" c)
  ) input