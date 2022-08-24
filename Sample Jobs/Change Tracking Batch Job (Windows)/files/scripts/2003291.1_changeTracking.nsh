#!/bin/nsh

# This script calls the jli script and passed the arguments.  The jython script should be in the share/sensors directory

#Arguments:
#        -g      <masterTemplateGroup>		Where the template is
#        -t      <templateName>			Name of the template
#        -s      <masterSnapshotJobGroup>	Where to keep the snapshot jobs
#        -a      <masterAuditJobGroup>		Where to keep the audit jobs
#        -u      <unathorizedAuditJobGroup>	Where to keep the audit jobs
#        -n      <snmpHost>			Name of the SNMP host (optional)
#        -d      <true|false>			Enable debugging

# To run this through the CM GUI run this as a Type 1 NSH script with the arguments noted above, 
# Make sure to double quote any spaces in the paths eg:

# bljython execute_change_detection.jy -g "/Change Track" -t "Change Template" -s "/Snap Group" -a "/Audit Group"  -u "/Audit Group 2"
#
# Make sure to set the BladeLogic Path as well.

BLADE_PATH_LX="/opt/bladelogic"
BLADE_PATH_WIN="C:\Progra~1\BladeLogic\OM"
HOST_OS=`nexec $HOST uname -s`

while [ $# -gt 0 ]
	do
	case "${1}" in
	-g)
		shift
		TG="${1}"
		;;
	-t)
		shift
		TN="${1}"
		;;
	-s)
		shift
		SG="${1}"
		;;
	-a)
		shift
		AG="${1}"
		;;
	-d)
		shift
		DB="${1}"
		;;
	-n)
		shift
		NH="${1}"
		;;
	-u)
		shift
		UG="${1}"
		;;

	*)
		#echo "ERROR: bad argument"
		;;
	esac
	shift
done


if [ "${HOST_OS}" = "WindowsNT" ]
	then
	echo "Calling Jython"
	#echo "cmd /c bljython ${BLADE_PATH_WIN}\share\sensors\execute_change_detection.jy  -g "${TG}" -t "${TN}" -s "${SG}" -a "${AG}" -u "${UG}" -n "${NH}" -d "${DB}""
	nexec $HOST cmd /c "bljython ${BLADE_PATH_WIN}\share\sensors\execute_change_detection.jy  -g "${TG}" -t "${TN}" -s "${SG}" -a "${AG}"  -u "${UG}"  -n "${NH}" -d "${DB}""
	EXIT_CODE="$?"
	if [ "$EXIT_CODE" -ne "0" ]; then
		exit 1
	fi
else
	echo "Calling Jython"
	#echo "sh -c ${BLADE_PATH_LX}/bin/bljython ${BLADE_PATH_LX}/share/sensors/execute_change_detection.jy -g "${TG}" -t "${TN}" -s "${SG}" -a "${AG}"  -u "${UG}"  -n "${NH}" -d "${DB}""
	nexec $HOST sh -c "${BLADE_PATH_LX}/bin/bljython ${BLADE_PATH_LX}/share/sensors/execute_change_detection.jy -g "${TG}" -t "${TN}" -s "${SG}" -a "${AG}"  -u "${UG}"  -n "${NH}" -d "${DB}""
	EXIT_CODE="$?"
	if [ "$EXIT_CODE" -ne "0" ]; then
		exit 1
	fi
fi