#!/bin/ksh
#
# Copyright (c) 2026 sashan@openbsd.org
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#    - Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    - Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the following
#      disclaimer in the documentation and/or other materials provided
#      with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

#
# script generates configuration for SRC PF RT and ECO
# hosts used by pf_forward regression test.
# see $SRC/regress/sys/net/pf_forward/Makefile
# for more details.
#
# script generates configuration to
#	src/etc/*
#	pf/etc/*
#	rt/etc/*
#	eco/etc/*
# directories. It also attempts to scp the configuration
# to test hosts .
#
# command above configures PF testbed using parameters found
# in Makefile. If Makefile is not provided the script uses
# built in defaults.
#

#
# read defaults in case Makefile is not specified.
#
typeset SRC_OUT=''
typeset PF_IN=''
typeset PF_OUT=''
typeset RT_IN=''
typeset RT_OUT=''
typeset ECO_IN=''
typeset ECO_OUT=''
typeset RDR_IN=''
typeset RDR_OUT=''
typeset AF_IN=''
typeset RTT_IN=''
typeset RTT_OUT=''
typeset RPT_IN=''
typeset RPT_OUT=''
typeset SRC_OUT6=''
typeset PF_IN6=''
typeset PF_OUT6=''
typeset RT_IN6=''
typeset RT_OUT6=''
typeset ECO_IN6=''
typeset ECO_OUT6=''
typeset RDR_IN6=''
typeset RDR_OUT6=''
typeset AF_IN6=''
typeset RTT_IN6=''
typeset RTT_OUT6=''
typeset RPT_IN6=''
typeset RPT_OUT6=''

function set_pf_forward_vars {
	typeset MAKEFILE=${1}

	if [[ -z "${MAKEFILE}" ]] ; then
		SRC_OUT=10.188.210.10
		PF_IN=10.188.210.50
		PF_OUT=10.188.211.50
		RT_IN=10.188.211.51
		RT_OUT=10.188.212.51
		ECO_IN=10.188.212.52
		ECO_OUT=10.188.213.52
		RDR_IN=10.188.214.188
		RDR_OUT=10.188.215.188
		AF_IN=10.188.216.82		# /24 must be dec(ECO_IN6/120)
		RTT_IN=10.188.217.52
		RTT_OUT=10.188.218.52
		RPT_IN=10.188.220.10
		RPT_OUT=10.188.221.10
		SRC_OUT6=fdd7:e83e:66bc:210:fce1:baff:fed1:561f
		PF_IN6=fdd7:e83e:66bc:210:5054:ff:fe12:3450
		PF_OUT6=fdd7:e83e:66bc:211:5054:ff:fe12:3450
		RT_IN6=fdd7:e83e:66bc:211:5054:ff:fe12:3451
		RT_OUT6=fdd7:e83e:66bc:212:5054:ff:fe12:3451
		ECO_IN6=fdd7:e83e:66bc:212:5054:ff:fe12:3452
		ECO_OUT6=fdd7:e83e:66bc:213:5054:ff:fe12:3452
		RDR_IN6=fdd7:e83e:66bc:214::188
		RDR_OUT6=fdd7:e83e:66bc:215::188
		AF_IN6=fdd7:e83e:66bc:216::34	# /120 must be hex(ECO_IN/24)
		RTT_IN6=fdd7:e83e:66bc:217:5054:ff:fe12:3452
		RTT_OUT6=fdd7:e83e:66bc:218:5054:ff:fe12:3452
		RPT_IN6=fdd7:e83e:66bc:1220:fce1:baff:fed1:561f
		RPT_OUT6=fdd7:e83e:66bc:1221:fce1:baff:fed1:561f
	else
		SRC_OUT=`awk '/^SRC_OUT .*/ {print($3);}' ${MAKEFILE}`
		PF_IN=`awk '/^PF_IN .*/ {print($3);}' ${MAKEFILE}`
		PF_OUT=`awk '/^PF_OUT .*/ {print($3);}' ${MAKEFILE}`
		RT_IN=`awk '/^RT_IN .*/ {print($3);}' ${MAKEFILE}`
		RT_OUT=`awk '/^RT_OUT .*/ {print($3);}' ${MAKEFILE}`
		ECO_IN=`awk '/^ECO_IN .*/ {print($3);}' ${MAKEFILE}`
		ECO_OUT=`awk '/^ECO_OUT .*/ {print($3);}' ${MAKEFILE}`
		RDR_IN=`awk '/^RDR_IN .*/ {print($3);}' ${MAKEFILE}`
		RDR_OUT=`awk '/^RDR_OUT .*/ {print($3);}' ${MAKEFILE}`
		AF_IN=`awk '/^AF_IN .*/ {print($3);}' ${MAKEFILE}`
		RTT_IN=`awk '/^RTT_IN .*/ {print($3);}' ${MAKEFILE}`
		RTT_OUT=`awk '/^RTT_OUT .*/ {print($3);}' ${MAKEFILE}`
		RPT_IN=`awk '/^RPT_IN .*/ {print($3);}' ${MAKEFILE}`
		RPT_OUT=`awk '/^RPT_OUT .*/ {print($3);}' ${MAKEFILE}`
		SRC_OUT6=`awk '/^SRC_OUT6 .*/ {print($3);}' ${MAKEFILE}`
		PF_IN6=`awk '/^PF_IN6 .*/ {print($3);}' ${MAKEFILE}`
		PF_OUT6=`awk '/^PF_OUT6 .*/ {print($3);}' ${MAKEFILE}`
		RT_IN6=`awk '/^RT_IN6 .*/ {print($3);}' ${MAKEFILE}`
		RT_OUT6=`awk '/^RT_OUT6 .*/ {print($3);}' ${MAKEFILE}`
		ECO_IN6=`awk '/^ECO_IN6 .*/ {print($3);}' ${MAKEFILE}`
		ECO_OUT6=`awk '/^ECO_OUT6 .*/ {print($3);}' ${MAKEFILE}`
		RDR_IN6=`awk '/^RDR_IN6 .*/ {print($3);}' ${MAKEFILE}`
		RDR_OUT6=`awk '/^RDR_OUT6 .*/ {print($3);}' ${MAKEFILE}`
		AF_IN6=`awk '/^AF_IN6 .*/ {print($3);}' ${MAKEFILE}`
		RTT_IN6=`awk '/^RTT_IN6 .*/ {print($3);}' ${MAKEFILE}`
		RTT_OUT6=`awk '/^RTT_OUT6 .*/ {print($3);}' ${MAKEFILE}`
		RPT_IN6=`awk '/^RPT_IN6 .*/ {print($3);}' ${MAKEFILE}`
		RPT_OUT6=`awk '/^RPT_OUT6 .*/ {print($3);}' ${MAKEFILE}`
	fi
}

function create_src {
	typeset MAKEFILE=${1}
	typeset VIO1_INET=''
	typeset VIO1_INET6=''

	set_pf_forward_vars ${MAKEFILE}
	
	VIO1_INET=${SRC_OUT}
	VIO1_INET6=${SRC_OUT6}

	#
	# turn IP addresses to route prefixes
	#
	RT_IN=`echo ${RT_IN} |cut -d '.' -f 1 -f 2 -f 3`
	RT_IN="${RT_IN}/24"

	RT_IN6=`echo ${RT_IN6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	RT_IN6="${RT_IN6}/64"

	ECO_IN=`echo ${ECO_IN} |cut -d '.' -f 1 -f 2 -f 3`
	ECO_IN="${ECO_IN}/24"

	ECO_IN6=`echo ${ECO_IN6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	ECO_IN6="${ECO_IN6}/64"

	ECO_OUT=`echo ${ECO_OUT} |cut -d '.' -f 1 -f 2 -f 3`
	ECO_OUT="${ECO_OUT}/24"

	ECO_OUT6=`echo ${ECO_OUT6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	ECO_OUT6="${ECO_OUT6}/64"

	RDR_IN=`echo ${RDR_IN} |cut -d '.' -f 1 -f 2 -f 3`
	RDR_IN="${RDR_IN}/24"

	RDR_IN6=`echo ${RDR_IN6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	RDR_IN6="${RDR_IN6}/64"

	RDR_OUT=`echo ${RDR_OUT} |cut -d '.' -f 1 -f 2 -f 3`
	RDR_OUT="${RDR_OUT}/24"

	RDR_OUT6=`echo ${RDR_OUT6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	RDR_OUT6="${RDR_OUT6}/64"

	AF_IN=`echo ${AF_IN} |cut -d '.' -f 1 -f 2 -f 3`
	AF_IN="${AF_IN}/24"

	AF_IN6=`echo ${AF_IN6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	AF_IN6="${AF_IN6}/64"

	RTT_IN=`echo ${RTT_IN} |cut -d '.' -f 1 -f 2 -f 3`
	RTT_IN="${RTT_IN}/24"

	RTT_IN6=`echo ${RTT_IN6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	RTT_IN6="${RTT_IN6}/64"

	RTT_OUT=`echo ${RTT_OUT} |cut -d '.' -f 1 -f 2 -f 3`
	RTT_OUT="${RTT_OUT}/24"

	RTT_OUT6=`echo ${RTT_OUT6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	RTT_OUT6="${RTT_OUT6}/64"

	NEXT_HOP=${PF_IN}
	NEXT_HOP6=${PF_IN6}

cat <<EOF > src/etc/hostname.vio1
inet ${VIO1_INET}/24
	!route add ${RT_IN} ${NEXT_HOP}
	!route add ${ECO_IN} ${NEXT_HOP}
	!route add ${ECO_OUT} ${NEXT_HOP}
	!route add ${RDR_IN} ${NEXT_HOP}
	!route add ${RDR_OUT} ${NEXT_HOP}
	!route add ${AF_IN} ${NEXT_HOP}
	!route add ${RTT_IN} ${NEXT_HOP}
	!route add ${RTT_OUT} ${NEXT_HOP}

inet6 ${VIO1_INET6}/64
	!route add -inet6 ${RT_IN6} \\
	    ${NEXT_HOP6}
	!route add -inet6 ${ECO_IN6} \\
	    ${NEXT_HOP6}
	!route add -inet6 ${ECO_OUT6} \\
	    ${NEXT_HOP6}
	!route add -inet6 ${RDR_IN6} \\
	    ${NEXT_HOP6}
	!route add -inet6 ${RDR_OUT6} \\
	    ${NEXT_HOP6}
	!route add -inet6 ${AF_IN6} \\
	    ${NEXT_HOP6}
	!route add -inet6 ${RTT_IN6} \\
	    ${NEXT_HOP6}
	!route add -inet6 ${RTT_OUT6} \\
	    ${NEXT_HOP6}

inet alias $RPT_IN
inet alias $RPT_OUT
inet6 alias $RPT_IN6
inet6 alias $RPT_OUT6
EOF

cat <<EOF > src/etc/sysctl.conf
net.inet.ip.forwarding=1
net.inet6.ip6.forwarding=1
EOF
}

function create_pf
{
	typeset MAKEFILE=${1}
	typeset VIO1_INET=''
	typeset VIO1_INET6=''
	typeset VIO2_INET=''
	typeset VIO2_INET6=''

	set_pf_forward_vars ${MAKEFILE}

	VIO1_INET=${PF_IN}
	VIO1_INET6=${PF_IN6}
	VIO2_INET=${PF_OUT}
	VIO2_INET6=${PF_OUT6}

	#
	# turn IP addresses to route prefixes
	#
	ECO_IN=`echo ${ECO_IN} |cut -d '.' -f 1 -f 2 -f 3`
	ECO_IN="${ECO_IN}/24"

	ECO_IN6=`echo ${ECO_IN6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	ECO_IN6="${ECO_IN6}/64"

	ECO_OUT=`echo ${ECO_OUT} |cut -d '.' -f 1 -f 2 -f 3`
	ECO_OUT="${ECO_OUT}/24"

	ECO_OUT6=`echo ${ECO_OUT6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	ECO_OUT6="${ECO_OUT6}/64"

	RTT_IN=`echo ${RTT_IN} |cut -d '.' -f 1 -f 2 -f 3`
	RTT_IN="${RTT_IN}/24"

	RTT_IN6=`echo ${RTT_IN6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	RTT_IN6="${RTT_IN6}/64"

	RTT_OUT=`echo ${RTT_OUT} |cut -d '.' -f 1 -f 2 -f 3`
	RTT_OUT="${RTT_OUT}/24"

	RTT_OUT6=`echo ${RTT_OUT6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	RTT_OUT6="${RTT_OUT6}/64"

	RPT_IN=`echo ${RPT_IN} |cut -d '.' -f 1 -f 2 -f 3`
	RPT_IN="${RPT_IN}/24"

	RPT_IN6=`echo ${RPT_IN6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	RPT_IN6="${RPT_IN6}/64"

	RPT_OUT=`echo ${RPT_OUT} |cut -d '.' -f 1 -f 2 -f 3`
	RPT_OUT="${RPT_OUT}/24"

	RPT_OUT6=`echo ${RPT_OUT6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	RPT_OUT6="${RPT_OUT6}/64"

	NEXT_HOP=${RT_IN}
	NEXT_HOP6=${RT_IN6}

cat <<EOF > pf/etc/hostname.vio1
inet ${VIO1_INET}/24

inet6 ${VIO1_INET6}/64
EOF

cat <<EOF > pf/etc/hostname.vio2
inet ${VIO2_INET}/24
mtu 1400
	!route add ${ECO_IN} ${NEXT_HOP}
	!route add ${ECO_OUT} ${NEXT_HOP}
	!route add ${RTT_IN} 127.0.0.1 -reject
	!route add ${RTT_OUT} 127.0.0.1 -reject
	!route add ${RPT_IN} 127.0.0.1 -reject
	!route add ${RPT_OUT} 127.0.0.1 -reject

inet6 ${VIO2_INET6}/64
	!route add -inet6 ${ECO_IN6} \\
	    ${NEXT_HOP6}
	!route add -inet6 ${ECO_OUT6} \\
	    ${NEXT_HOP6}
	!route add -inet6 ${RTT_IN6} ::1 -reject
	!route add -inet6 ${RTT_OUT6} ::1 -reject
	!route add -inet6 ${RPT_IN6} ::1 -reject
	!route add -inet6 ${RPT_OUT6} ::1 -reject
EOF

cat <<EOF > pf/etc/sysctl.conf
net.inet.ip.forwarding=1
net.inet6.ip6.forwarding=1
kern.allowdt=1
ddb.console=1
kern.allowkmem=1
EOF

cat <<EOF > pf/etc/pf.conf
#set skip on lo

block return    # block stateless traffic
pass            # establish keep-state

# By default, do not permit remote connections to X11
block return in on ! lo0 proto tcp to port 6000:6010

# Port build user does not need network
block return out log proto {tcp udp} user _pbuild

anchor "regress"
EOF
}

function create_rt
{
	typeset MAKEFILE=${1}
	typeset VIO1_INET=''
	typeset VIO1_INET6=''
	typeset VIO2_INET=''
	typeset VIO2_INET6=''

	set_pf_forward_vars ${MAKEFILE}

	VIO1_INET=${RT_IN}
	VIO1_INET6=${RT_IN6}
	VIO2_INET=${RT_OUT}
	VIO2_INET6=${RT_OUT6}

	#
	# turn IP addresses to route prefixes
	#
	SRC_OUT=`echo ${SRC_OUT} |cut -d '.' -f 1 -f 2 -f 3`
	SRC_OUT="${SRC_OUT}/24"

	SRC_OUT6=`echo ${SRC_OUT6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	SRC_OUT6="${SRC_OUT6}/64"

	RPT_IN=`echo ${RPT_IN} |cut -d '.' -f 1 -f 2 -f 3`
	RPT_IN="${RPT_IN}/24"

	RPT_IN6=`echo ${RPT_IN6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	RPT_IN6="${RPT_IN6}/64"

	RPT_OUT=`echo ${RPT_OUT} |cut -d '.' -f 1 -f 2 -f 3`
	RPT_OUT="${RPT_OUT}/24"

	RPT_OUT6=`echo ${RPT_OUT6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	RPT_OUT6="${RPT_OUT6}/64"

	ECO_OUT=`echo ${ECO_OUT} |cut -d '.' -f 1 -f 2 -f 3`
	ECO_OUT="${ECO_OUT}/24"

	ECO_OUT6=`echo ${ECO_OUT6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	ECO_OUT6="${ECO_OUT6}/64"

	RTT_IN=`echo ${RTT_IN} |cut -d '.' -f 1 -f 2 -f 3`
	RTT_IN="${RTT_IN}/24"

	RTT_IN6=`echo ${RTT_IN6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	RTT_IN6="${RTT_IN6}/64"

	RTT_OUT=`echo ${RTT_OUT} |cut -d '.' -f 1 -f 2 -f 3`
	RTT_OUT="${RTT_OUT}/24"

	RTT_OUT6=`echo ${RTT_OUT6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	RTT_OUT6="${RTT_OUT6}/64"

	NEXT_HOP_SRC_OUT=${PF_OUT}
	NEXT_HOP_SRC_OUT6=${PF_OUT6}

	NEXT_HOP_ECO_OUT=${ECO_IN}
	NEXT_HOP_ECO_OUT6=${ECO_IN6}

cat <<EOF > rt/etc/hostname.vio1
inet ${VIO1_INET}/24
mtu 1300
	!route add ${SRC_OUT} ${NEXT_HOP_SRC_OUT}
	!route add ${RPT_IN} ${NEXT_HOP_SRC_OUT}
	!route add ${RPT_OUT} ${NEXT_HOP_SRC_OUT}

inet6 ${VIO1_INET6}/64
mtu 1300
	!route add -inet6 ${SRC_OUT6} \\
	    ${NEXT_HOP_SRC_OUT6}
	!route add -inet6 ${RPT_IN6} \\
	    ${NEXT_HOP_SRC_OUT6}
	!route add -inet6 ${RPT_OUT6} \\
	    ${NEXT_HOP_SRC_OUT6}
EOF

cat <<EOF > rt/etc/hostname.vio2
inet ${VIO2_INET}/24
mtu 1300
	!route add ${ECO_OUT} ${NEXT_HOP_ECO_OUT}
	!route add ${RTT_IN} ${NEXT_HOP_ECO_OUT}
	!route add ${RTT_OUT} ${NEXT_HOP_ECO_OUT}

inet6 ${VIO2_INET6}/64
mtu 1300
	!route add -inet6 ${ECO_OUT6} \\
	    ${NEXT_HOP_ECO_OUT6}
	!route add -inet6 ${RTT_IN6} \\
	    ${NEXT_HOP_ECO_OUT6}
	!route add -inet6 ${RTT_OUT6} \\
	    ${NEXT_HOP_ECO_OUT6}
EOF

cat <<EOF > rt/etc/sysctl.conf
net.inet.ip.forwarding=1
net.inet6.ip6.forwarding=1
EOF
}

function create_eco
{
	typeset MAKEFILE=${1}
	typeset VIO1_INET=''
	typeset VIO1_INET6=''
	typeset VIO2_INET=''
	typeset VIO2_INET6=''

	set_pf_forward_vars ${MAKEFILE}

	VIO1_INET=${ECO_IN}
	VIO1_INET6=${ECO_IN6}
	VIO2_INET=${ECO_OUT}
	VIO2_INET6=${ECO_OUT6}

	#
	# turn IP addresses to route prefixes
	#
	SRC_OUT=`echo ${SRC_OUT} |cut -d '.' -f 1 -f 2 -f 3`
	SRC_OUT="${SRC_OUT}/24"

	SRC_OUT6=`echo ${SRC_OUT6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	SRC_OUT6="${SRC_OUT6}/64"

	PF_OUT=`echo ${PF_OUT} |cut -d '.' -f 1 -f 2 -f 3`
	PF_OUT="${PF_OUT}/24"

	PF_OUT6=`echo ${PF_OUT6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	PF_OUT6="${PF_OUT6}/64"

	RPT_IN=`echo ${RPT_IN} |cut -d '.' -f 1 -f 2 -f 3`
	RPT_IN="${RPT_IN}/24"

	RPT_IN6=`echo ${RPT_IN6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	RPT_IN6="${RPT_IN6}/64"

	RPT_OUT=`echo ${RPT_OUT} |cut -d '.' -f 1 -f 2 -f 3`
	RPT_OUT="${RPT_OUT}/24"

	RPT_OUT6=`echo ${RPT_OUT6} |cut -d ';' -f 1 -f 2 -f 3 -f 4`
	RPT_OUT6="${RPT_OUT6}/64"

	NEXT_HOP=${RT_OUT}
	NEXT_HOP6=${RT_OUT6}

cat <<EOF > eco/etc/hostname.vio1
inet ${VIO1_INET}/24
	!route add ${SRC_OUT} ${NEXT_HOP}
	!route add ${PF_OUT} ${NEXT_HOP}
	!route add ${RPT_IN} ${NEXT_HOP}
	!route add ${RPT_OUT} ${NEXT_HOP}

inet6 ${VIO1_INET6}/64
	!route add -inet6 ${SRC_OUT6} \\
	    ${NEXT_HOP6}
	!route add -inet6 ${PF_OUT6} \\
	    ${NEXT_HOP6}
	!route add -inet6 ${RPT_IN6} \\
	    ${NEXT_HOP6}
	!route add -inet6 ${RPT_OUT6} \\
	    ${NEXT_HOP6}

inet alias ${RTT_IN}/24
inet6 alias ${RTT_IN6}/24
EOF

cat <<EOF > eco/etc/hostname.vio2
inet ${VIO2_INET}/24

inet6 ${VIO2_INET6}/64

inet alias ${RTT_OUT}/24
inet6 alias ${RTT_OUT6}/24
EOF

cat <<EOF > eco//etc/inetd.conf
echo           stream  tcp     nowait  root    internal
echo           stream  tcp6     nowait  root    internal

echo           stream  udp     nowait  root    internal
echo           stream  udp6     nowait  root    internal

${VIO1_INET}:echo           dgram  udp     nowait  root    internal
[${VIO1_INET6}]:echo           dgram  udp6     nowait  root    internal

${VIO2_INET}:echo           dgram  udp     nowait  root    internal
[${VIO2_INET6}]:echo           dgram  udp6     nowait  root    internal

${RTT_IN}:echo           dgram  udp     nowait  root    internal
[${RTT_IN6}]:echo           dgram  udp6     nowait  root    internal

${RTT_OUT}:echo           dgram  udp     nowait  root    internal
[${RTT_OUT6}]:echo           dgram  udp6     nowait  root    internal
EOF

cat <<EOF > eco/etc/sysctl.conf
net.inet.ip.forwarding=1
net.inet6.ip6.forwarding=1
EOF
}

for i in src pf rt eco ; do
	mkdir -p $i/etc ;
done

create_src ${1}
create_pf ${1}
create_rt ${1}
create_eco ${1}

for i in src pf rt eco ; do
	scp ${i}/etc/* root@${i}:/etc/.
done
