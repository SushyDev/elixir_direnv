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
				in 
				{
					default = pkgs.mkShell {
						buildInputs =
							let
								globalPackages = [
									pkgs.beamMinimal28Packages.elixir_1_19
									pkgs.beamMinimal28Packages.erlang
									pkgs.unzip
									pkgs.asdf-vm
									pkgs.mise
									pkgs.vfox
								];

								linuxOnlyPackages = pkgs.lib.optional stdenv.isLinux [
									pkgs.watchman
									pkgs.inotify-tools
								];
							in
							globalPackages ++ linuxOnlyPackages;
					};
				}
			);
		in
		{
			inherit devShells;
		};
}
