import pygame
import sys
import random

# Inicializar pygame
pygame.init()

# Configuración de la ventana
ANCHO = 800
ALTO = 600
ventana = pygame.display.set_mode((ANCHO, ALTO))
pygame.display.set_caption("Carreras con Alonso")

# Cargar imagen del circuito y ajustar tamaño
circuito_imagen = pygame.image.load("prueba_circuito.jpg")
circuito_imagen = pygame.transform.scale(circuito_imagen, (ANCHO, ALTO))

# Cargar imagen del coche y ajustar tamaño
coche_imagen_original = pygame.image.load("r25.png")
coche_imagen_original = pygame.transform.scale(coche_imagen_original, (70, 40))  # Ajustar al nuevo tamaño

# Coordenadas, dirección y velocidad del coche
x_coche = 100
y_coche = 300
velocidad = 5
direccion = "derecha"

# Cargar archivos de audio
canciones = ["ALÉ ALONSO ALÉ - Bydaviz.mp3", "El Nano.mp3"]
random.shuffle(canciones)  # Mezclar la lista de canciones de forma aleatoria

# Cargar sonido de arranque del motor
arranque_motor = pygame.mixer.Sound("v10_start.mp3")

# Estado del juego
arrancado = False
arranque_reproducido = False

# Definir índice de la canción actual
indice_cancion_actual = 0

# Función para iniciar el juego
def iniciar_juego():
    global arrancado
    arrancado = True
    arranque_motor.play()  # Reproducir sonido de arranque del motor

# Función para detener el juego
def detener_juego():
    global arrancado
    arrancado = False
    pygame.mixer.music.pause()

# Bucle del juego
jugando = True
reloj = pygame.time.Clock()

while jugando:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            jugando = False

    # Movimiento del coche
    teclas = pygame.key.get_pressed()
    if arrancado:
        if teclas[pygame.K_LEFT]:
            x_coche -= velocidad
            direccion = "izquierda"
        if teclas[pygame.K_RIGHT]:
            x_coche += velocidad
            direccion = "derecha"
        if teclas[pygame.K_UP]:
            y_coche -= velocidad
            direccion = "arriba"
        if teclas[pygame.K_DOWN]:
            y_coche += velocidad
            direccion = "abajo"

        # Limitar el movimiento del coche dentro de la ventana
        x_coche = max(0, min(x_coche, ANCHO - 60))
        y_coche = max(0, min(y_coche, ALTO - 30))

    # Dibujar en la pantalla
    ventana.blit(circuito_imagen, (0, 0))  # Dibujar circuito como fondo
    if direccion == "derecha":
        ventana.blit(coche_imagen_original, (x_coche, y_coche))
    elif direccion == "izquierda":
        coche_rotado = pygame.transform.flip(coche_imagen_original, True, False)
        ventana.blit(coche_rotado, (x_coche, y_coche))
    elif direccion == "arriba":
        coche_rotado = pygame.transform.rotate(coche_imagen_original, 90)
        ventana.blit(coche_rotado, (x_coche, y_coche))
    elif direccion == "abajo":
        coche_rotado = pygame.transform.rotate(coche_imagen_original, -90)
        ventana.blit(coche_rotado, (x_coche, y_coche))

    # Dibujar botón ARRANCAR
    if not arrancado:
        pygame.draw.rect(ventana, (0, 255, 0), (650, 500, 100, 50))
        fuente = pygame.font.SysFont(None, 25)
        texto = fuente.render("ARRANCAR", True, (0, 0, 0))
        ventana.blit(texto, (650, 505))

    # Control de eventos del botón ARRANCAR
    if not arrancado:
        mouse_x, mouse_y = pygame.mouse.get_pos()
        if 650 <= mouse_x <= 750 and 500 <= mouse_y <= 550:  # Coordenadas del botón
            for event in pygame.event.get():
                if event.type == pygame.MOUSEBUTTONDOWN:
                    iniciar_juego()

    # Verificar si el sonido del arranque del motor ha terminado
    if arrancado and not arranque_reproducido:
        arranque_reproducido = True
        arranque_motor.play()  # Reproducir sonido de arranque del motor nuevamente
        pygame.mixer.music.load(canciones[indice_cancion_actual])
        pygame.mixer.music.play()

    # Control de la velocidad de fotogramas
    reloj.tick(60)

    # Control de cambio de canción
    if not pygame.mixer.music.get_busy() and arrancado and arranque_reproducido:
        indice_cancion_actual = (indice_cancion_actual + 1) % len(canciones)
        pygame.mixer.music.load(canciones[indice_cancion_actual])
        pygame.mixer.music.play()

    # Actualizar la pantalla
    pygame.display.flip()

# Salir del juego
pygame.quit()
sys.exit()
