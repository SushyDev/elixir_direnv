{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
	};

	outputs = { self, nixpkgs }:
		let
			supportedSystems = nixpkgs.lib.platforms.all;
			devShells = 
				nixpkgs.lib.genAttrs supportedSystems (system: 
				let
					pkgs = import nixpkgs { inherit system; };
					inherit (pkgs) stdenv;

					globalPackages = [
						pkgs.beamMinimal28Packages.elixir_1_19
						pkgs.beamMinimal28Packages.erlang
						pkgs.unzip
						pkgs.asdf-vm
						pkgs.mise
						pkgs.vfox
					];

					linuxOnlyPackages = if stdenv.isLinux then [
						pkgs.watchman
						pkgs.inotify-tools
					] else [];
				in 
				{
					default = pkgs.mkShell {
						buildInputs = globalPackages ++ linuxOnlyPackages;

						shellHook = ''
							echo "Elixir version: $(elixir --version)"
						'';
					};
				}
			);
		in
		let
			supportedSystems = nixpkgs.lib.platforms.all;
			packages = {};
		in
		{
			inherit devShells packages;
		};
}
