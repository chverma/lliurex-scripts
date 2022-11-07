setup: changeunifigrouptodefault changeunifigrouptodefault filter eap changeUnifiUserGroup.py
    ## Install dependencies
	sudo repoman-cli -e 2
	sudo apt update
	sudo apt install -y python3-dotenv
	sudo repoman-cli -d 2
	## Create install directory
	mkdir -p /usr/bin/changeunifigroup/backup
	cp default /usr/bin/changeunifigroup/default
	cp eap /usr/bin/changeunifigroup/eap
	cp filter /usr/bin/changeunifigroup/filter
	cp changeunifigrouptodefault /usr/bin/changeunifigroup/changeunifigrouptodefault
	cp changeunifigrouptofp /usr/bin/changeunifigroup/changeunifigrouptofp
	cp changeUnifiUserGroup.py /usr/bin/changeunifigroup/changeUnifiUserGroup.py

	## Backup files
	mv /etc/freeradius/3.0/sites-available/default /usr/bin/changeunifigroup/backup/default.backup
	mv /etc/freeradius/3.0/mods-enabled/eap /usr/bin/changeunifigroup/backup/eap.backup
	mv /etc/freeradius/3.0/policy.d/filter /usr/bin/changeunifigroup/backup/filter.backup

	## Create symbolic links
	ln -s /usr/bin/changeunifigroup/changeunifigrouptodefault /etc/freeradius/3.0/mods-enabled/changeunifigrouptodefault
	ln -s /usr/bin/changeunifigroup/changeunifigrouptofp /etc/freeradius/3.0/mods-enabled/changeunifigrouptofp

	## Create symbolic links
	ln -s /usr/bin/changeunifigroup/default /etc/freeradius/3.0/sites-available/default
	ln -s /usr/bin/changeunifigroup/eap /etc/freeradius/3.0/mods-enabled/eap
	ln -s /usr/bin/changeunifigroup/filter /etc/freeradius/3.0/policy.d/filter
test:
	freeradius -X
clean:
	mv /usr/bin/changeunifigroup/backup/default.backup /etc/freeradius/3.0/sites-available/default
	mv /usr/bin/changeunifigroup/backup/eap.backup /etc/freeradius/3.0/mods-enabled/eap
	mv /usr/bin/changeunifigroup/backup	/filter.backup /etc/freeradius/3.0/policy.d/filter
	rm /etc/freeradius/3.0/mods-enabled/changeunifigrouptofp
	rm /etc/freeradius/3.0/mods-enabled/changeunifigrouptodefault
