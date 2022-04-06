#!/bin/bash

if [[ id -u -ne 0 ]]
then

	echo "Este script necesita privilegios de administrador"

	exit 1

elif [[ $# -ne 2 ]]
then
	echo "Numero incorrecto de parametros"
	exit 1

else
	if [[ $1 -ne  [ "-a" | "-s" ] ]]
	then

		echo "Opcion invalida" > &2


	elif [[ $1 -eq "-s" ]]
	then
		mkdir -p /extra/backup
		olfIFS="$IFS"
		IFS=,

		cat "$2" |
		while read idus ig
		do
			if id "$idus" > /dev/null 2>&1
			then
				usermod -L "$idus"
				dirhom="$HOME"
				if tar -cpf /extra/backup/$iduser.tar "$iduser" >/dev/null/ 2>&1
				then
					userdel -r -f "$idus">/dev/null/ 2>&1
				else
					usermod -U "$idus"
				fi
			fi
		done
	elif [[ $1 -eq "-a"]]
	then
		oldIFS="$IFS"
		IFS=,
		cat "$2" |
		while read idus pass nombre
		do
			if [[ "$idus" -eq  "" || "$pass" -eq "" || "$nombre" -eq "" ]]
			then
				echo "Campo invalido"
				exit 1
			fi
			if id "$idus" >/dev/null 2>&1
			then
				echo "Usuario ya existe"
				exit 1
			fi
			useradd -m -k /etc/skel -U -f 30 -K UID_MIN=1815 -c "$nombre" "$idus"
			echo "$idus:$pass| chpasswd
			echo "$nombre el usuario ha sido creado"

		done



	fi

fi
