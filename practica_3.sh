#!/bin/bash
if [[ $(id -u) -ne 0 ]]
then
	echo "Este script necesita privilegios de administracion"
	exit 1
elif [[ "$#" -ne "2" ]]
then
	echo "Numero incorrecto de parametros"
	exit 1
else
	if [[ "$1" != "-a" && "$1" != "-s" ]]
	then
		echo "Opcion invalida" >&2
	elif [[ "$1" = "-s" ]]
	then
		mkdir -p /extra/backup
		olfIFS="$IFS"
		IFS=","
		cat "$2" |
		while read idus ig
		do
			if id "$idus" >/dev/null 2>&1
			then
				usermod -L "$idus"
				dirhom=  /bin/cat /etc/passwd | grep "$idus" | cut -d ':' -f 6 | tail -1
				if tar -cf "/extra/backup/$iduser.tar $dirhom" >/dev/null 2>&1
				then
					userdel -r -f "$idus">/dev/null 2>&1
					echo "echo"
				else
					usermod -U "$idus"> /dev/null 2>&1
					echo -n "$dirhom"
				fi
			fi
		done
		IFS="$oldIFS"
	elif [[ "$1" = "-a" ]]
	then
		oldIFS="$IFS"
		IFS=","
		cat "$2" |
		while read idus pass nombre
		do
			if [ -z "$idus" ] || [ -z "$pass" ] || [ -z "$nombre" ]
			then
				echo "Campo invalido"
				exit 1
			fi
			if id "$idus" >/dev/null 2>&1
			then
				echo "El usuario $idus ya existe"
				exit 1
			fi
			useradd -m -k /etc/skel -U -f 30 -K UID_MIN=1815 -c "$nombre" "$idus"
			echo "$idus:$pass"| chpasswd
			echo "$nombre ha sido creado"
		done
		IFS="$oldIFS"
	fi
fi
