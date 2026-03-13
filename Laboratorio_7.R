setwd("C:/Users/Gary/Downloads/URL/Estadística/Laboratorio #7")


#Cargo las librerias a utilizar
library(tidyverse)
library(caTools) # Correr preparacióm de datos para ML
library(MLmetrics)
library(corrplot)

# Cargar los archivos que vamos a utilizar
# Datos para entreno del modelo
df_entreno_crudo <- read.csv("insurance - entreno.csv", sep = ";") %>% na.omit() #por ahora se omiten los n/a pero estos se deben tratar
# Datos para utiilización del modelo
df_uso_crudo <- read.csv("insurance - uso.csv ", sep = ";")


# Vamops a proceder al proceso de entrenamiento y prueba del modelo
split <- sample.split(df_entreno_crudo$smoker, SplitRatio = 0.8) 
# Split en consola da lo que esta tomando aleatoriamente con el 80%

# Hago el proceso de entrenamiento y prueba
df_entreno <- subset(df_entreno_crudo, split == T)
df_prueba <- subset(df_entreno_crudo, split == F)

###VISUALIZACION ENTRE FUMADORES Y NO FUMADORES
smoker_df <- df_entreno_crudo %>% filter(smoker == "yes")
boxplot(smoker_df$charges)

no_smoker_df <- df_entreno_crudo %>% filter(smoker == "no")
boxplot(no_smoker_df$charges)

ggplot(df_entreno_crudo, aes(x = smoker, y = charges)) + geom_boxplot()


#Construyo el set de datos para los fumadores entreno y no fumadores entreno
entreno_fumadores <- df_entreno %>% filter(smoker == "yes")
entreno_nofumadores <- df_entreno %>% filter(smoker == "no")

#ENTRENO LOS MODELOS
modelo_lm_fumadores <- lm(charges ~ age + sex + bmi + children + region, data = entreno_fumadores)
modelo_lm_nofumadores <- lm(charges ~ age + sex + bmi + children + region, data = entreno_nofumadores)

#VER R CUADRADO
summary(modelo_lm_fumadores)
summary(modelo_lm_nofumadores)





