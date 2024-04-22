#!/bin/bash

# Obtener el PID del proceso padre
parent_pid=$$

#####
# Dibujo ASCII e Información
#####

# Colores para las diferentes secciones
COLOR_NOMBRE="\e[38;5;208m"  # Color para el nombre de la sección
COLOR_CONTENIDO="\e[38;5;75m"  # Color para el contenido de la sección

# Información del sistema
os=$(lsb_release -d | cut -f2)  # Distribución del sistema
host=$(hostname)  # Nombre del host
kernel=$(uname -r)  # Versión del kernel
time=$(date)  # Hora actual

# Información del entorno
shell=$(echo $SHELL)  # Shell actual
resolution=$(xrandr | awk '/\*/ {print $1}')  # Resolución de pantalla

# Información del hardware
cpu=$(lscpu | grep "Model name" | cut -d':' -f2 | sed 's/^[ \t]*//')  # Modelo de CPU
gpu=$(lspci | grep VGA | cut -d':' -f3 | sed 's/^[ \t]*//')  # GPU
memory=$(free -h | awk '/Mem:/ {print $2}')  # Memoria total del sistema

# Función para imprimir secciones con colores
print_section() {
    printf "${COLOR_NOMBRE}$1${COLOR_CONTENIDO}$2\n"
}

# Imprimir la información recopilada con colores
inf1=$(print_section "Sistema operativo: " "$os")
inf2=$(print_section "Nombre del host: " "$host")
inf3=$(print_section "Kernel: " "$kernel")
inf4=$(print_section "Hora actual: " "$time")
inf5=$(print_section "Shell: " "$shell")
inf6=$(print_section "Resolución de pantalla: " "$resolution")
inf7=$(print_section "CPU: " "$cpu")
inf8=$(print_section "GPU: " "$gpu")
inf9=$(print_section "Memoria total: " "$memory")

# Dibujo ASCII
echo -e "
────────\e[38;5;15m▄▄▄▄▄███████████████████▄▄▄▄▄──────\e[0m
\e[38;5;15m────▄██████████▀▀▀▀▀▀▀▀▀▀██████▀████▄────\e[0m      $inf1
\e[38;5;15m──▄██▀████████▄─────────────▀▀████─▀██▄──\e[0m      $inf2
\e[38;5;15m─▀██▄▄██████████████████▄▄▄─────────▄██▀─\e[0m      $inf3
\e[38;5;15m───▀█████████████████████████▄────▄██▀───\e[0m      $inf4
\e[38;5;15m─────▀████▀▀▀▀▀▀▀▀▀▀▀▀█████████▄▄██▀─────\e[0m      $inf5
\e[38;5;15m───────▀███▄──────────────▀██████▀───────\e[0m      $inf6
\e[38;5;15m─────────▀██████▄─────────▄████▀─────────\e[0m      $inf7
\e[38;5;15m────────────▀█████▄▄▄▄▄▄▄███▀────────────\e[0m      $inf8
\e[38;5;15m──────────────▀████▀▀▀████▀──────────────\e[0m      $inf9
\e[38;5;15m────────────────▀███▄███▀────────────────\e[0m  
\e[38;5;15m───────────────────▀█▀───────────────────\e[0m
"
# Restablecer el color al valor predeterminado al final
echo -e "\e[0m"


#####
# Fin del dibujo ASCII e Información
#####

while true; do
    echo
    echo -e "\e[38;5;245mEl PID del script es: $parent_pid\e[0m"
    # Mostrar la hora actual y el PID del proceso padre en el prompt
    export PS1="\[\033[1;33m\]$(date +"%T") PID:$parent_pid\[\033[0m\] script_terminal: "
    
    # Leer la entrada del usuario
    read -p "$(date +"%T") script_terminal: " command

    # Salir si el usuario ingresa "exit"
    if [ "$command" == "exit" ]; then
        ascii-art-animator -f ./giphy.gif -a -m 2 -c 100
        exit
    fi
    
    # Mostrar la ayuda si el usuario ingresa "help"
    if [ "$command" == "help" ]; then
        echo -e "\e[1;34mLista de comandos disponibles:"
        echo -e "\e[1;32mcd\e[0m [directorio]: Cambiar de directorio."
        echo -e "\e[1;32mmkdir\e[0m [nombre_directorio]: Crear un nuevo directorio."
        echo -e "\e[1;32mtouch\e[0m [nombre_archivo]: Crear un nuevo archivo."
        echo -e "\e[1;32mrm\e[0m [nombre_archivo]: Borrar un archivo."
        echo -e "\e[1;32mrmdir\e[0m [nombre_directorio]: Borrar un directorio."
        echo -e "\e[1;32mpwd\e[0m: Mostrar el directorio actual."
        echo -e "\e[1;32mls\e[0m: Listar archivos y directorios en el directorio actual."
        echo -e "\e[1;32mserpiente\e[0m: Iniciar el juego de la serpiente."
        echo -e "\e[1;32mexit\e[0m: Salir del script.\e[0m"
        echo -e "\e[1;32mnoticias\e[0m: Ver noticieros disponibles.\e[0m"
        echo -e "\e[1;32mrrss\e[0m: Ver redes sociales disponibles.\e[0m"
        continue
    fi
    
    if [[ "$command" == "kill -9 "* ]]; then
        eval $command
    elif [ "$command" == "cd" ]; then
        cd "$home_dir" || echo "No se pudo cambiar al directorio $home_dir"
        continue
    elif [[ "$command" == "top" ]]; then
        top
    elif [[ "$command" == "cd "* ]]; then
        dir="${command#cd }"
        cd "$dir" || echo "No se pudo cambiar al directorio $dir"
    elif [[ "$command" == "mkdir "* ]]; then
        dir="${command#mkdir }"
        mkdir "$dir" || echo "No se pudo crear el directorio $dir"
    elif [[ "$command" == "touch "* ]]; then
        file="${command#touch }"
        touch "$file" || echo "No se pudo crear el archivo $file"
    elif [[ "$command" == "rm "* ]]; then
        file="${command#rm }"
        rm "$file" || echo "No se pudo borrar el archivo $file"
    elif [[ "$command" == "rmdir "* ]]; then
        dir="${command#rmdir }"
        rmdir "$dir" || echo "No se pudo borrar el directorio $dir"
    elif [[ "$command" == "pwd" ]]; then
        echo -e "\033[0;31m$(pwd)\033[0m"

    elif [[ "$command" == "ls" ]]; then
        export LS_COLORS='di=34'
        ls --color=auto

    elif [[ "$command" == "serpiente" ]]; then
        gnome-terminal -- nsnake &
    
        
    
        
    elif [[ "$command" == "noticias"* ]]; then
        echo "Seleccione un noticiero para ver las noticias:"
        echo -e "\e[96m1. El Espanol\e[0m"  # Cyan
        echo -e "\e[91m2. OK Diario\e[0m"       # Red
        echo -e "\e[92m3. El Confidencial\e[0m"  # Green
        echo -e "\e[95m4. Marca\e[0m"   # Magenta
        read -p "Ingrese el número correspondiente al noticiero: " opcion_noticias

        case $opcion_noticias in
            1)
                # Abre El Espan;ol en el navegador
                xdg-open "https://www.elespanol.com/" 2>/dev/null
                ;;
            2)
                # Abre OK Diario en el navegador
                xdg-open "https://okdiario.com/" 2>/dev/null
                ;;
            3)
                # Abre El Confidencial en el navegador
                xdg-open "https://www.elconfidencial.com/" 2>/dev/null
                ;;
            4)
                # Abre Reuters en el navegador
                xdg-open "https://www.marca.com/" 2>/dev/null
                ;;
            *)
                echo "Opción inválida. Por favor, seleccione un número del 1 al 4."
                ;;
        esac
        
    
    elif [[ "$command" == "rrss"* ]]; then
    
        echo "Seleccione una red social:"
    echo -e "\e[94m1. Twitter\e[0m"     # Celeste
    echo -e "\e[35m2. Instagram\e[0m"   # Rosa
    echo -e "\e[97m3. TikTok\e[0m"      # Rosa
    echo -e "\e[31m4. YouTube\e[0m"     # Rojo
    echo -e "\e[34m5. Facebook\e[0m"    # Azul
    read -p "Ingrese el número correspondiente a la red social: " opcion_social


        case $opcion_social in
            1)
                # Abre Twitter en el navegador
                xdg-open "https://twitter.com/home?lang=es/" 2>/dev/null
                ;;
            2)
                # Abre YouTube en el navegador
                xdg-open "https://www.instagram.com/" 2>/dev/null
                ;;
            3)
                # Abre TikTok en el navegador
                xdg-open "https://www.tiktok.com/es/" 2>/dev/null
                ;;
            4)
                # Abre YouTube en el navegador
                xdg-open "https://www.youtube.com/" 2>/dev/null
                ;;
            5)
                # Abre Facebook en el navegador
                xdg-open "https://www.facebook.com/?locale=es_ES/" 2>/dev/null
                ;;
            *)
                echo "Opción inválida. Por favor, seleccione un número del 1 al 5."
                ;;
        esac
        
    




    fi
    
    
    
done
