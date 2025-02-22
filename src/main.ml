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
	if String.length args.(2) <= 0 then (
		Printf.printf "The input cannot be an empty string\n";
		exit 0
	);

	let machine_file = args.(1) in
	let input = args.(2) in

	try
		let machine_json = Yojson.Basic.from_file machine_file in
		let machine = Turing.parse_machine machine_json in
		Turing.simulate_machine machine input
	with
	| e -> Printf.printf "Error: %s\n" (Printexc.to_string e)
