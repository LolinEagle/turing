open Yojson.Basic

let () =
	let args = Sys.argv in

	if Array.length args <> 3 || args.(1) = "-h" || args.(1) = "--help" then (
		Printf.printf "usage: turing [-h] jsonfile input\n";
		Printf.printf "positional arguments:\n";
		Printf.printf "jsonfile   json description of the machine\n";
		Printf.printf "input      input of the machine\n";
		Printf.printf "optional arguments:\n";
		Printf.printf "-h, --help show this help message and exit\n";
		exit 0
	);

	let jsonfile = args.(1) in
	let input = args.(2) in

	try
		let json = Yojson.Basic.from_file jsonfile in
		let machine = Turing.parse_machine json in
		Turing.simulate_machine machine input
	with
	| e -> Printf.printf "Error: %s\n" (Printexc.to_string e)
