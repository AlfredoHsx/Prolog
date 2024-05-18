import requests
from bs4 import BeautifulSoup
import os


def buscar_imagenes(terminos_de_busqueda, numero_de_imagenes=2):
    imgCont = 1
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
                    with open(f'img/{imgCont}_{termino}.jpg', 'wb') as handler:
                        handler.write(img_data)
                    #print(f"Imagen de '{termino_planta}' descargada.")
                    imgCont = imgCont + 1
                except Exception as e:
                    imgCont = imgCont
                    #print(f"No se pudo descargar la imagen de '{termino_planta}': {e}")
        #else:
            #print(f"No se pudo realizar la solicitud para '{termino_planta}'. Código de estado: {response.status_code}")


if __name__ == "__main__":

    terminos_de_busqueda = \
    ["Abrojo", "Acacia", "Acanto", "Acedera", "Aceite de oliva", "Aceitilla", "Acelga", "Achicoria", "Aconito", "Agar-agar", "Aguacate", "Ajenjo", "Ajo", "Albahaca", "Alcachofa", "Alcanfor", "Alfalfa", "Alholva", "Alpiste", "Anacahuite", "Anagalida", "Anis", "Anis estrella", "Apio", "Arnica", "Arroz", "Artemisa", "Avena", "Azafran", "Azahar", "Beleño", "Belladona", "Benjui", "Berro", "Betonia", "Boldo", "Borraja", "Brionia", "Cabellos de elote", "Calendula", "Canela", "Capulin", "Cardo", "Cardo santo", "Cascara sagrada", "Castaño de indias", "Cebada", "Cebolla", "Cedron", "Cerezo", "Chaparro amargoso", "Chia", "Chicalote", "Cilantro", "Cipres", "Ciruela", "Clavo", "Cola de caballo", "Colchico", "Coquito de aceite", "Crataegus", "Cuachalalate", "Cuasia", "Cuercillo", "Damiana", "Diente de leon", "Digital", "Doradilla", "Encina", "Encino rojo", "Enebro", "Epazote", "Esparrago", "Espinacas", "Espino", "Espinosilla", "Estafiate", "Eucalipto", "Fenogreco", "Fresno", "Gelsemio", "Genciana", "Geranio", "Germen de trigo", "Girasol", "Gobernadora", "Gordolobo", "Grama", "Granada", "Guayaba", "Hamamelis", "Helecho", "Helecho macho", "Hiedra", "Hierba del pollo", "Hierbabuena", "Higuera", "Hinojo", "Hisopol", "Ipecacuana", "Jengibre", "Jugo de limon", "Jugo de toronja", "Jugo de vastago de platano morado", "Laurel", "Lavanda", "Leche de higuera", "Lechuga", "Limon", "Linaza", "Lino", "Llanten", "Lupulo", "Malva", "Malvavisco", "Manzanilla", "Marrubio", "Mastuerzo", "Matarique", "Mate", "Melisa", "Membrillo", "Menta", "Mezquite", "Miel", "Milenrama", "Monacillo", "Mostaza", "Muerdago", "Muicle", "Naranja", "Nogal", "Nuez de kola", "Nuez vomica", "Ocote", "Oregano", "Ortiga", "Papaloquelite", "Papaya", "Pasiflora", "Perejil", "Pimiento", "Pingüica", "Pino", "Pirúl", "Prodigiosa", "Puerro", "Quina", "Quina amarilla", "Quina roja", "Rabano", "Retama", "Ricino", "Roble", "Romero", "Rosal", "Ruda", "Ruibarbo", "Sabina", "Salvia", "Sanguinaria", "Sauco", "Semilla de calabaza", "Siempreviva", "Simonillo", "Tabachin", "Tabaco", "Tabaquillo", "Tamarindo", "Te de limon", "Te negro", "Tecomasuchil", "Tejocote", "Tila", "Tlachichinole", "Toloache", "Tomillo", "Toronja", "Toronjil", "Tronadora", "Uva", "Valeriana", "Verbena", "Violeta", "Yohimbe", "Zanahoria", "Zarzamora", "Zarzaparrilla", "Zoapatle", "Barbasco", "Opio"]

    buscar_imagenes(terminos_de_busqueda)
