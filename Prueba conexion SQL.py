import numpy as np
import pandas as pd
import psycopg2
from sqlalchemy import create_engine

# Todas las librerias que use, las ultimas dos hay que instalarlas. Buscar documentacion

'------------------------------------------------1------------------------------------------------'
try:

    host = 'localhost'
    port = 5433
    database = 'Baseball'
    username = 'postgres'
    password = 'Ikariam521'

    connection = psycopg2.connect(
        host=host,
        port=port,
        database=database,
        user=username,
        password=password
    )
except psycopg2.Error as e:
    print("Unable to connect to the PostgreSQL server:")
    print(e)

# En este paso el metodo de try es opcional. Se hace para que en caso de que ocurra un error con los datos que hay que rellenar, el
# sistema entregue la frase de "Unable to connect...." Revisar internet en caso de que se quiera dejar solo con la conexion
# Falta el cierre de conexion pero como varias de las cosas que hice despues de este paso dependen de eso, preferi bajar los dos comandos del cierre
# a las ultimas lineas del documento.

'-----------------------------------------------2------------------------------------------------'
cursor = connection.cursor()


cursor.execute('SELECT * FROM allstarfull LIMIT 5')
result_1 = cursor.fetchall()

cursor.execute('SELECT DISTINCT(teamid) FROM allstarfull')
result_2 = cursor.fetchall()

for row in result_1:
    print(row)

print(np.array(result_2))

# Para poder interactuar con la base de datos de postgres, se tiene que crear primero un cursor. En este apartado hice dos queries para imprimirlas de
# diferentes maneras. Ambos casos siguen la misma estructura pero a la hora de imprimir uno se hace con un loop mientras que el otro se hace
# usando el metodo array de numpy

'-----------------------------------------------3------------------------------------------------'
Prueba_Formateo ='''1,gomezle01,1933,0,ALS193307060,NYA,921,AL,1,1
2,ferreri01,1933,0,ALS193307060,BOS,912,AL,1,2
3,gehrilo01,1933,0,ALS193307060,NYA,921,AL,1,3
4,gehrich01,1933,0,ALS193307060,DET,919,AL,1,4
5,dykesji01,1933,0,ALS193307060,CHA,915,AL,1,5'''

formateado = Prueba_Formateo.strip().split('\n')
data = [line.split(',') for line in formateado[0:]]

for i in formateado:
    print(i)

# Este paso fue una prueba de copiar una tabla generada en la consola de postgres y pegarla en la consola de python. La variable definida a principio
# debe tener tres comillas ''' para que el codifo funcione, ya que la tabla es CSV, se usa la , como separador, ya que no puse nombres de columnas
# no hay codigo para editar eso. Solamente se usan los datos de la tabla y se procesan usando list comprehension. Por ultimo se usa un loop para print
# los valores de la tabla. Unica finalidad de este apartado es aprender a copiar, pegar, procesar e imprimir una tabla generada en sql en la consola de python.

'-----------------------------------------------4------------------------------------------------'
df = pd.read_csv(r'C:\Users\vicen\OneDrive\Escritorio\Data Analytics\DATA\Python\Data Cleaning US Census Data\states0.csv')
print(df.head())

# Solo se cargan los datos usando pandas, como no estoy trabajando el proyecto de donde saque los datos, hay que poner toda la ruta al archivo. Para esto se
# agrega la r antes de las comillas. Siempre imprimir el head para ver que haya cargado correctamente.

'-----------------------------------------------5------------------------------------------------'
# Create a SQLAlchemy engine to utilize pandas.io.sql module
engine = create_engine('postgresql+psycopg2://postgres:Ikariam521@localhost:5433/Films')

df1 = 'df1'
df.to_sql(df1, engine, if_exists='replace', index=False)

# Commit the changes
connection.commit()

# Este apartado genera una tabla temporal en la base de datos escogida. Para esto hay que editar los valores del link.

'-----------------------------------------------6------------------------------------------------'
cursor.close()
connection.close()

# Se cierra el cursos que se habia abierto previamente

# Gracias al paso 5, he sido capaz de:
    # Cargar un CSV usando pandas
    # Crear una tabla temporal en la base de datos de postgres con los valores obtenidos del CSV anterior
    # Realizar queries en la consola de SQL sobre la tabla temporal y usando el paso 3 formatear y utilizar los resultados en Python
    # en caso de que se cierreel scratch file de sql, lo unico que hay que hacer es call la table con el nombre de que le asigne en este file

# Sin embargo, antes de hacer el ultimo apartado, resultaria mejor y mas directo utilizar el paso 2 y correr el codigo de SQL en consola Python







