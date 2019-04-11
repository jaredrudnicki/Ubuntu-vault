#!/bin/bash
if [ "$(id -u)" == "0" ]; then
	echo "ubuntu-spaget.sh is not being run as root"
	echo "run as 'sudo sh ubuntu-spaget.sh 2>&1 | tee output.log' to output the console output to a log file."
	exit
else
    	
	#Updates the system
	apt-get update
	apt-get upgrade
	apt-get install ssh -y
	apt-get install libpam-cracklib -y

	#purge and removes bad software
	apt-get purge apache2 -y
	apt-get purge wesnoth -y
	apt-get purge john -y
	apt-get purge samba -y
	apt-get purge nginx -y
	apt-get purge ftp -y
	apt-get purge netcat -y
	
	#Remove media files
	cd /home
	rm -rf /home/*/Music/*.mp3
	rm -rf /home/*/Pictures/*.bmp
	rm -rf /home/*/Pictures/*.png
	rm -rf /home/*/Pictures/*.jpg
	rm -rf /home/*/Videos/*.mp4

	#ssh root login denied
	sed -i '/PermitRootLogin/ c\PermitRootLogin no/' /etc/ssh/sshd_config
	
	#replace the entire file with the following line
	echo "allow-guest=false" > /etc/lightdm/lightdm.conf
	echo "remove autologin" >> /etc/lightdm/lightdm.conf
	
	#disable IPV4 forwarding may not work
	sudo echo 0 > /proc/sys/net/ipv4/ip_forward

	#removes scheduled tasks from cron
	#crontab -r
	
	#Control IP packet forwarding
	sed -i '/net.ipv4.ip_forward/ c\net.ipv4.ip_forward = 0' sysctl.conf

	#IP spoofing protection
	sed -i '/net.ipv4.conf.all.rp_filter/ c\net.ipv4.conf.all.rp_filter = 1' /etc/sysctl.conf
	sed -i '/net.ipv4.conf.default.rp_filter = 0/ c\net.ipv4.conf.default.rp_filter = 1' /etc/sysctl.conf


	#Ignore ICMP broadcast requests
	sed -i '/net.ipv4.icmp_echo_ignore_broadcasts/ c\net.ipv4.icmp_echo_ignore_broadcasts = 1' /etc/sysctl.conf

	#disables source packet routing
	sed -i '/net.ipv4.conf.all.accept_source_route/ c\net.ipv4.conf.all.accept_source_route = 0' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.all.accept_source_route/ c\net.ipv6.conf.all.accept_source_route = 0' /etc/sysctl.conf
	sed -i '/net.ipv4.conf.default.accept_source_route/ c\net.ipv4.conf.default.accept_source_route = 0' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.default.accept_source_route/ c\net.ipv6.conf.default.accept_source_route = 0' /etc/sysctl.conf

	#Ignore send redirects
	sed -i '/net.ipv4.conf.all.send_redirects/ c\net.ipv4.conf.all.send_redirects = 0' /etc/sysctl.conf
	sed -i '/net.ipv4.conf.default.send_redirects/ c\net.ipv4.conf.default.send_redirects = 0' /etc/sysctl.conf

	#Block SYN Attacks
	sed -i '/net.ipv4.tcp_syncookies/ c\net.ipv4.tcp_syncookies = 1' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_syn_backlog/ c\net.ipv4.tcp_max_syn_backlog = 2048' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_synack_retries/ c\net.ipv4.tcp_synack_retries = 2' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syn_retries/ c\net.ipv4.tcp_syn_retries = 5' /etc/sysctl.conf

	#Log Martians
	sed -i '/net.ipv4.conf.all.log_martians/ c\net.ipv4.conf.all.log_martians = 1' /etc/sysctl.conf
	sed -i '/net.ipv4.icmp_ignore_bogus_error_responses/ c\net.ipv4.icmp_ignore_bogus_error_responses = 1' /etc/sysctl.conf

	#Ignore ICMP redirects
	sed -i '/net.ipv4.conf.all.accept_redirects/ c\net.ipv4.conf.all.accept_redirects = 0' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.all.accept_redirects/ c\net.ipv6.conf.all.accept_redirects = 0' /etc/sysctl.conf
	sed -i '/net.ipv4.conf.default.accept_redirects/ c\net.ipv4.conf.default.accept_redirects = 0' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.default.accept_redirects/ c\net.ipv6.conf.default.accept_redirects = 0' /etc/sysctl.conf

	#Ignore Directed Pings
	sed -i '/net.ipv4.icmp_echo_ignore_all/ c\net.ipv4.icmp_echo_ignore_all = 1' /etc/sysctl.conf

	#Secure Redirects
	sed -i '/net.ipv4.conf.all.secure_redirects/ c\net.ipv4.conf.all.secure_redirects = 0' /etc/sysctl.conf

	#Log Impossible Addressed Packets
	sed -i '/net.ipv4.conf.default.secure_redirects/ c\net.ipv4.conf.default.secure_redirects = 0' /etc/sysctl.conf

	#Enable ExecShield Protection
	sed -i '/kernel.exec-shield/ c\kernel.exec-shield = 1' /etc/sysctl.conf
	sed -i '/kernel.randomize_va_space/ c\kernel.randomize_va_space = 1' /etc/sysctl.conf

	#IPv6 Networking
	sed -i '/net.ipv6.conf.all.disable_ipv6/ c\net.ipv6.conf.all.disable_ipv6 = 1' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.default.router_solicitations/ c\net.ipv6.conf.default.router_solicitations = 0' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.default.accept_ra_rtr_pref/ c\net.ipv6.conf.default.accept_ra_rtr_pref = 0' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.default.accept_ra_pinfo/ c\net.ipv6.conf.default.accept_ra_pinfo = 0' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.default.accept_ra_defrtr/ c\net.ipv6.conf.default.accept_ra_defrtr = 0' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.default.autoconf/ c\net.ipv6.conf.default.autoconf = 0' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.default.dad_transmits/ c\net.ipv6.conf.default.dad_transmits = 0' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.default.max_addresses/ c\net.ipv6.conf.default.max_addresses = 1' /etc/sysctl.conf
	
	#Password Policies
	sed -i '/PASS_MIN_DAYS/ c\PASS_MIN_DAYS 7' /etc/login.defs	
	sed -i '/PASS_MAX_DAYS/ c\PASS_MAX_DAYS 90' /etc/login.defs
	sed -i '/PASS_MIN_DAYS/ c\PASS_MIN_DAYS 14' /etc/login.defs
	sed -i '/pam_unix.so/ c\password	[success=1 default=ignore]	pam_unix.so obscure sha512 remember=5 minlen=8' /etc/pam.d/common-password
	sed -i 'pam_cracklib.so/ c\password	requisite			pam_cracklib.so retry=3 minlen=8 difok=3 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1' /etc/pam.d/common-password
	echo "auth required pam_tally2.so deny=5 onerr=fail unlock_time=1800" >> /etc/pam.d/common-auth
	
	#Firewall settings
	ufw enable
    	ufw deny 23
   	ufw deny 2049
    	ufw deny 515
    	ufw deny 111

fi
