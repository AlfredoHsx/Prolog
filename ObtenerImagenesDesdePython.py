import requests
from bs4 import BeautifulSoup
import os


def buscar_imagenes(terminos_de_busqueda, numero_de_imagenes=5):
    for termino in terminos_de_busqueda:
        termino_planta = f"{termino} planta"  # Concatenar "planta" al término de búsqueda
        url = f"https://www.google.com/search?q={termino_planta}&tbm=isch"
        headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"}
        response = requests.get(url, headers=headers)

        if response.status_code == 200:
            soup = BeautifulSoup(response.text, 'html.parser')
            imagenes = soup.find_all('img', limit=numero_de_imagenes)
            for i, img in enumerate(imagenes):
                try:
                    img_url = img['src']
                    img_data = requests.get(img_url).content
                    with open(f'D:/OneDrive/Escritorio/PARALASIMAGENES/{termino}.jpg', 'wb') as handler:
                        handler.write(img_data)
                    print(f"Imagen de '{termino_planta}' descargada.")
                except Exception as e:
                    print(f"No se pudo descargar la imagen de '{termino_planta}': {e}")
        else:
            print(f"No se pudo realizar la solicitud para '{termino_planta}'. Código de estado: {response.status_code}")


if __name__ == "__main__":
    terminos_de_busqueda = \
        [
        "Malva", "Zarzaparrilla", "Anís", "Perejil", "Sanguinaria", "Limon", "Sauco", "Árnica", "Llanten", "Fenogreco",
        "Zarzamora", "Salvia", "Tilo", "Valeriana", "Yerbabuena", "Manzanilla", "Jugo_de_limón", "Jugo_de_toronja",
        "Pingüica", "Quinoa_roja", "Encino_rojo", "Pimiento", "Huramelis", "Cola_de_caballo", "Arnica", "Ajenjo",
        "Germen_de_trigo", "Quira", "Canela", "Alholva", "Eucalipto", "Cebada", "Tabachin", "Borraja", "Gerciana",
        "Limón", "Genciana", "Cardo", "Chicalote", "Alcanfor", "Toronja", "Merrubio", "Toloache", "Oregano", "Lupulo",
        "Cuasia", "Uva", "Cerezo", "Rosal", "Encina", "Borraga", "Anacahuite", "Benjui", "Rabano", "Ipecacuana",
        "Mostaza", "Ortiga", "Espinosilla", "Romero", "Diente_de_león", "Aceite_de_oliva", "Retama",
        "Cabellos_de_elote", "Pinguica", "Ajo", "Cebolla", "Hiedra", "Cuachalalate", "Siempreviva", "Mastuerzo",
        "Higuera", "Toronjil", "Boldo", "Linaza", "Laurel", "Briania", "Nuez_de_kcla", "Tejocote", "Achicoria", "Apio",
        "Sanguinaria", "Berro", "Matarique", "Tronadora", "Bucalipto", "Damiana", "Capulín", "Mezquite",
        "Tlalchichinole", "Membrillo", "Arroz", "Guayaba", "Albahaca", "Granada", "Sinionillo", "Chaparro_amargoso",
        "Muicle", "Monacillo", "Naranja", "Tamarindo", "Quina", "Tabequillo", "Ruibaxbo", "Anís_estrella", "Ipecacuana",
        "Cedrón", "Té_de_limón", "Genciana", "Grama", "Granado", "Gordolobo"

    ]

    buscar_imagenes(terminos_de_busqueda)
