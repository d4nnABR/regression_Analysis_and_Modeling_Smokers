# 📊 Análisis Predictivo de Costos Médicos por Seguro

**Laboratorio de Regresión Lineal |  Data Science Portfolio**

[![GitHub stars](https://img.shields.io/github/stars/d4nnABR/regression_Analysis_and_Modeling_Smokers?style=social)](https://github.com/d4nnABR/regression_Analysis_and_Modeling_Smokers)
[![R](https://img.shields.io/badge/R-4.5.2-blue.svg)](https://www.r-project.org/)

Predicción de **charges** (costos médicos) usando variables demográficas y hábitos. **Modelos segmentados** para **fumadores/no fumadores** con validación 80/20.

## 📈 Resultados Clave

| Métrica | Fumadores | No Fumadores | Global |
|---------|-----------|--------------|--------|
| **RMSE** | **$4,862** | **$4,677** | - |
| **R²** | **0.77** | - | **0.75** |
| **Smoker Impact** | **+$24,008** | - | **Dominante** |

> **Insight principal**: Ser fumador aumenta costos **20x** más que cualquier otra variable.

## 🧪 Dataset

**Entrenamiento** (`insurance-entreno.csv`): 1,028 observaciones
```
age;sex;bmi;children;smoker;region;charges
19;female;27.9;0;yes;southwest;16884.92
28;male;33;3;no;southeast;4449.46
...
```

**Uso** (`insurance-uso.csv`): 10 casos para predicción

## 🛠️ Requisitos (instalación automática)

```r
# Una línea instala todo
install.packages(c("tidyverse", "caTools", "MLmetrics", "corrplot", "patchwork"))
```

```r
library(tidyverse)
library(caTools)
library(MLmetrics)
library(corrplot)
library(patchwork)
```

## 🚀 Uso Rápido

```bash
git clone https://github.com/d4nnABR/regression_Analysis_and_Modeling_Smokers.git
cd regression_Analysis_and_Modeling_Smokers
```

**Working directory automático**

## 📊 Pipeline de Análisis

```
1. EDA → Histogramas + Boxplots (outliers detectados)
2. Split 80/20 → Estratificado por smoker
3. Modelos → Global + Segmentados
4. Métricas → RMSE, MAPE, R²
5. Predicciones → Dataset de uso
```

### Gráficos Generados
- Distribución `charges` (sesgo derecho)
- Boxplots `bmi/age/charges` (outliers altos)
- Scatter pred vs real

## 🔍 Insights de Negocio

| Variable | Impacto | Acción |
|----------|---------|--------|
| **smoker=yes** | **+$24,008** | Tarifas diferenciales |
| **bmi (+1)** | **+$343** | Programas wellness |
| **age (+1)** | **+$261** | Escalado por edad |
| **children (+1)** | **+$530** | Descuentos familia |

## 📈 Modelos Implementados

```r
# Global (R² = 0.75)
lm(charges ~ age + sex + bmi + children + smoker + region)

# Segmentados
lm(charges ~ age + sex + bmi + children + region | smoker)
```

## 🎯 Conclusiones Ejecutivas

✅ **Alta precisión** segmentando fumadores (RMSE ~$4.7k)  
✅ **Variables accionables** para pricing actuarial  
⚠️ **Outliers altos** → Casos crónicos a revisar  
💡 **Smoker domina** → Base para políticas antifumo  

## 👨‍💻 Autor

**Gary Abrigo**  
Data Science Student | Guatemala  
[LinkedIn](https://linkedin.com/in/garyabrigo) | [GitHub](https://github.com/d4nnABR)

---

*Proyecto marzo 2026 | R 4.5.2 | Compatible Windows/Linux/Mac*
