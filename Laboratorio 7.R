#----------------------#
#----Carga de datos----#
#-----y librerías------#
#----------------------#

setwd("C:/Users/brydo/OneDrive/Desktop/Estudios/00. Especialización y Maestría/Estadística/Laboratorios/Laboratorio 7")

#Cargo las librerías

library(tidyverse)
library(caTools) #Corre preparación de datos para ML
library(MLmetrics) #Validación de modelos
library(corrplot)

#Cargo los archivos

#Datos para entreno del modelo
df_entreno_crudo <- read.csv("insurance - entreno.csv", sep = ";") %>% na.omit()

#Datos para utilización del modelo
df_uso_crudo <- read.csv("insurance - uso.csv", sep = ";").


#----------------------#
#----Inciso 1, 2,3-----#
#----------------------#

# Usamos el dataframe original para ver el panorama completo
library(patchwork)

# 2. Definimos los gráficos (sin mostrarlos aún)
p1 = ggplot(df_entreno_crudo, aes(x = age)) + 
  geom_histogram(bins = 30, fill = "skyblue", color = "black") + 
  theme_minimal() + labs(title = "Edad")

p2 = ggplot(df_entreno_crudo, aes(x = bmi)) + 
  geom_histogram(bins = 30, fill = "salmon", color = "black") + 
  theme_minimal() + labs(title = "IMC (BMI)")

p3 = ggplot(df_entreno_crudo, aes(x = charges)) + 
  geom_histogram(bins = 30, fill = "lightgreen", color = "black") + 
  theme_minimal() + labs(title = "Cargos")

# 3. Combinamos con patchwork:
(p1 + p2) / p3


#Para la variable edad, hay cierto cumulo de jovenes al principio, para el demas no se observa un tema de 
#sesgo como tal, para la variable BMI, se observa una distribución en forma de campana de Gauss teniendo 
#cierta concentración entre los 27 a los 35 de BMI, indicanto que el mayor grupo de personas se encuentra
#en un peso entre normal y sobrepeso clase 1, sin embargo en los charges si se nota el sesgo para la derecha
#en el cual efectivamente hay mas personas con menos cargos y un grupo pequeño de personas con muchos cargos,
#lo cual en el ambito de los seguros es justo como debería de verse.

#----------------------#
#-------Inciso 4-------#
#----------------------#

ggplot(df_entreno_crudo, aes(x = charges) ) +
  geom_histogram(binwidth = 500, fill = "darkgreen", color = "white", alpha = 0.8) +
  labs(title = "Distribución de la variable charges", 
       x="Cargos", 
       y= "Frecuencia") +
  theme_minimal()

#El histograma muestra que la variable charges no sigue una distribución simétrica, ya que está sesgada hacia la derecha,
#lo que significa que la mayoría de los pacientes presentan costos médicos bajos o moderados, y solo una minoría registra
#valores muy elevados. Además, se identifican valores atípicos que superan los 40,000–60,000, los cuales podrían afectar
#tanto el análisis descriptivo como el desempeño del modelo de regresión si no se tratan adecuadamente.

#----------------------#
#-------Inciso 5-------#
#----------------------#

#Utiliza gráficos de caja y bigotes (boxplots) para identificar posibles valores atípicos en las 
#variables numéricas como bmi, age, y charges.  
#Pregunta: ¿Hay valores atípicos que deberían ser suavizados o eliminados antes de ajustar el 
#modelo?

ggplot(df_entreno_crudo, aes(x = "BMI", y = bmi)) +
  geom_boxplot(alpha = 0.7, fill = "#69b3a2", width = 0.4) +
  labs(
    title = "Análisis BMI",
    x = NULL,
    y = "BMI"
  ) +
  theme_minimal(base_size = 12)


ggplot(df_entreno_crudo, aes(x = "Age", y = age)) +
  geom_boxplot(alpha = 0.7, fill = "#69b3a2", width = 0.4) +
  labs(
    title = "Análisis Age",
    x = NULL,
    y = "Age"
  ) +
  theme_minimal(base_size = 12)


ggplot(df_entreno_crudo, aes(x = "Charges", y = charges)) +
  geom_boxplot(alpha = 0.7, fill = "#69b3a2", width = 0.4) +
  labs(
    title = "Análisis Charges",
    x = NULL,
    y = "Charges"
  ) +
  theme_minimal(base_size = 12)

#Analizando el boxplot, vemos que la variable BMI sí presenta valores atípicos en la parte alta de la distribución
#Analizando el boxplot, no se observan valores atípicos en la variable age
#Analizando el boxplot, vemos que la variable Charges sí presenta valores atípicos en la parte alta de la distribución
#En conclusión, solo con ell análisis de llos boxplot, podríamos suavizar las variables BMI y Charges, 
#priorizando esta última que presenta valores claramente atípicos.

#----------------------#
#-------Inciso 7-------#
#----------------------#

#División de los datos en entrenamiento y prueba (80%/20%):  
#Divide el conjunto de datos en 80% para entrenamiento y 20% para evaluación utilizando una división aleatoria.  
#Pregunta: ¿Cómo se distribuyen las variables en los conjuntos de entrenamiento y 
#prueba? ¿Hay algún desequilibrio que deba ser manejado?  


#Proceso de entrenamiento y prueba del modelo

split <- sample.split(df_entreno_crudo$smoker, SplitRatio = 0.8)

#Hago el proceso de entrenamiento y prueba

df_entreno <- subset(df_entreno_crudo, split == T)
df_prueba <- subset(df_entreno_crudo, split == F)

ggplot(df_entreno, aes(x = "Charges", y = charges)) +
  geom_boxplot(alpha = 0.7, fill = "#69b3a2", width = 0.4) +
  labs(
    title = "Análisis Charges",
    x = NULL,
    y = "Charges"
  ) +
  theme_minimal(base_size = 12)

ggplot(df_prueba, aes(x = "Charges", y = charges)) +
  geom_boxplot(alpha = 0.7, fill = "#69b3a2", width = 0.4) +
  labs(
    title = "Análisis Charges",
    x = NULL,
    y = "Charges"
  ) +
  theme_minimal(base_size = 12)

#Al revisar a través de un boxplo la variable "charges" en el dataset de prueba y entreno
#Se observa que ambos df contienen valores atípicos en la dimensión superior, por lo que a nivel de distribución
#de datos, sí están bien distribuidos, aunque lo ideal sería no contar con esos atípicos que pueden entorpecer
#el proceso de predicción

#----------------------#
#-------Inciso 8-------#
#----------------------#
# Ajusta un modelo de regresión lineal utilizando las variables age, sex, bmi, children, 
# smoker, region para predecir los cargos médicos (charges).

modelo_global <- lm(charges ~ age + sex + bmi + children + smoker + region, 
                    data = df_entreno_crudo)


# Pregunta: ¿Qué variables tienen los coeficientes más altos y cómo impactan en los 
# cargos médicos? ¿Qué interpretaciones puedes hacer sobre los coeficientes de las 
# variables categóricas y numéricas?

summary(modelo_global)

### --------------- Respuesta ---------------- ####
# 1. Las variables con coeficientes más altos son smokeryes (24,008.11), children (529.52), 
# bmi (342.73) y age (260.53), todas significativas (p<0.001).

# Para variables numéricas (age, bmi, children): los coeficientes muestran cuánto sube el costo 
# por cada unidad extra (ej. +1 año = +$261, +1 punto BMI = +$343, +1 hijo = +$530), manteniendo todo lo demás igual.
# Para variables categóricas (smoker, sex, region): los coeficientes miden la diferencia de costo vs la categoría base
# (ej. fumador vs no fumador: +$24,008; hombre vs mujer: +$53 pero insignificante). Regiones como southeast (-$1,263) cuestan menos que la región base
 


#Construyo el set de dato para los fumadores entreno y no fumadores entreno

entreno_fumadores <- df_entreno %>% filter(smoker == "yes")
entreno_nofumadores <- df_entreno %>% filter(smoker == "no")

#Entreno los modelos

modelo_lm_fumadores <- lm(charges ~ age + sex + bmi + children + region ,data = entreno_fumadores)
modelo_lm_nofumadores <- lm(charges ~ age + sex + bmi + children + region ,data = entreno_nofumadores)

#Hago el set de prueba de cada uno
prueba_fumadores <- df_prueba %>% filter(smoker == "yes")
prueba_nofumadores <- df_prueba %>% filter(smoker == "no")

#Hago las predicciones

prueba_fumadores$pred <- predict(modelo_lm_fumadores, prueba_fumadores)
prueba_nofumadores$pred <- predict(modelo_lm_nofumadores, prueba_nofumadores)

#----------------------#
#-------Inciso 9-------#
#----------------------#

#MODELO FUMADORS INDICADORES
RMSE(prueba_fumadores$pred, prueba_fumadores$charges)
RMSE(prueba_nofumadores$pred, prueba_nofumadores$charges)

#----------------------#
#------Inciso 10-------#
#----------------------#

MAPE(prueba_fumadores$pred, prueba_fumadores$charges)
MAPE(prueba_nofumadores$pred, prueba_nofumadores$charges)


#HAGO LAS PREDICCIONES CON EL SET DE USO

df_uso_fumadores <- df_uso_crudo %>% filter(smoker == "yes")
df_uso_nofumadores <- df_uso_crudo %>% filter(smoker == "no")


df_uso_fumadores$pred <- predict(modelo_lm_fumadores, df_uso_fumadores)
df_uso_nofumadores$pred <- predict(modelo_lm_nofumadores, df_uso_nofumadores)

df_uso_completo <- rbind(df_uso_fumadores, df_uso_nofumadores)

#No se hace la 6
#No se hace la 11

#5
#7

