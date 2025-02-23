open Sys

let usage_msg = "usage: ft_turing [-h] jsonfile input\n\
  positional arguments:\n\
  jsonfile   json description of the machine\n\
  input      input of the machine\n\
  optional arguments:\n\
  -h, --help show this help message and exit"

let show_usage () =
  Printf.printf "%s\n" usage_msg;
  exit 0

let parse_args () =
  if Array.length argv <> 3 || argv.(1) = "-h" || argv.(1) = "--help" then
    show_usage ();

  if String.length argv.(2) <= 0 then (
    Printf.printf "The input cannot be an empty string\n";
    exit 0
  );

  (argv.(1), argv.(2))
