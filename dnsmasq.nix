{ config, pkgs, ...}:
let
addresses = import ./blocked-addresses.nix;
cname = builtins.map(addr: "${addr},localhost") addresses;
in
{

services.dnsmasq = {
		 enable = true;
		 alwaysKeepRunning = true;
		 settings = {
		 	    inherit address cname;
			    server = [
		 	    	   "1.1.1.3"
				   "1.0.0.3"
				   ];
			    };

};
}