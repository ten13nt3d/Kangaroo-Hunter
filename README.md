# 🦘 Kangaroo-Hunter: Distributed Bitcoin Puzzle Cracker

![Docker](https://img.shields.io/badge/docker-ready-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/status-experimental-orange)

**Kangaroo-Hunter** es un entorno Dockerizado y paralelizado para ejecutar [JeanLucPons/Kangaroo](https://github.com/JeanLucPons/Kangaroo) y buscar claves privadas de Bitcoin a través de fragmentos definidos (shards) del keyspace. Esta configuración es especialmente útil para desafíos como el puzzle #69 de Bitcoin, permitiendo ataques distribuidos de fuerza bruta usando el algoritmo del canguro de Pollard.

---

## 📚 Tabla de Contenidos

- [📦 Estructura del Proyecto](#-estructura-del-proyecto)
- [🚀 Características](#-características)
- [🔧 Requisitos](#-requisitos)
- [🧱 Build del Contenedor](#-build-del-contenedor)
- [🧩 1. Generar Shards (Rangos)](#-1-generar-shards-rangos)
- [🔄 2. Ejecutar Kangaroo en Paralelo](#-2-ejecutar-kangaroo-en-paralelo)
- [🔍 Salida Esperada](#-salida-esperada)
- [📄 Ejemplo de Línea de Comando Kangaroo](#-ejemplo-de-línea-de-comando-kangaroo)
- [🧪 Tests y Verificación](#-tests-y-verificación)
- [🤝 Contribuir](#-contribuir)
- [⚠️ Aviso Legal](#-aviso-legal)
- [📜 Licencia](#-licencia)

---

## 📦 Estructura del Proyecto
```project
kangaroo-hunter/
├── 📄 Dockerfile            # 🐳 Define entorno con dependencias necesarias 
├── 🧬 docker-compose.yml    # ⚙️ Orquesta múltiples contenedores Kangaroo 
├── 🔢 generate_shards.sh    # 📐 Genera los rangos de búsqueda (shards) 
├── 🧮 run_parallel.sh        # 🔄 Ejecuta Kangaroo usando GNU Parallel
└── 📝 README.md              # 📘 Documentación principal del proyecto
```

## 🚀 Características

- 🐳 **Docker-Ready**: Portabilidad asegurada para correr Kangaroo en cualquier máquina o servidor.
- ⚙️ **docker-compose**: Levanta múltiples workers fácilmente.
- 📐 **Shard Generator**: Divide el espacio de claves en fragmentos (shards) para facilitar el escaneo distribuido.
- 🔄 **Parallel Execution**: Utiliza GNU Parallel para explotar múltiples núcleos o nodos cloud.
- 💡 **Simple & Modular**: Separación clara de tareas y scripts fácilmente personalizables.

---

## 🔧 Requisitos

- Docker y docker-compose
- GNU Parallel (`sudo apt install parallel`)
- Un sistema operativo Linux/macOS (para uso local o en servidores cloud)

## 🧱 Build del Contenedor

Primero, clona este repositorio y construye la imagen Docker:

```bash
git clone https://github.com/ten13nt3d/kangaroo-hunter.git
cd kangaroo-hunter
docker build -t kangaroo .
```

---

## 🧩 1. Generar Shards (Rangos):

Edita generate_shards.sh y ajusta los parámetros como:
```generate_shards.sh
# Ejemplo
start_range=1000000000000000000000000000000000000000
end_range=1000000000000000000000000001000000000000
step=1000000000000000000000000000000000000
```
Luego ejecuta:
```bash
chmod +x generate_shards.sh
./generate_shards.sh
```

Esto generará un archivo shards.txt con líneas tipo:
```shards.txt
1000000000000000000000000000000000000000:1000000000000000000000000000100000000
...
```

## 🔄 2. Ejecutar Kangaroo en Paralelo

Opción A: GNU Parallel (uso local)
Requiere que el binario Kangaroo esté compilado en la carpeta.
```bash
chmod +x run_parallel.sh
./run_parallel.sh
```
El script leerá shards.txt y ejecutará una instancia de Kangaroo por shard.

## Opción B: Docker Compose (multi-contenedor)

Define tu docker-compose.yml así:
```yaml
services:
  kangaroo:
    build: .
    volumes:
      - ./shards.txt:/app/shards.txt
    environment:
      - TARGET_HASH160=your_target_here
    command: ./Kangaroo -r ${RANGE} -t ${TARGET_HASH160}

```

Levanta el entorno con:
```bash
docker-compose up --build
```

Para escalar:
```bash
docker-compose up --scale kangaroo=4
```

## 🔍 Salida Esperada

Cada instancia de Kangaroo imprimirá en consola:
```bash
Found private key: 0xABC123... for pubkey: <target>
```
Guarda los resultados con:
```bash
./run_parallel.sh > results.log 2>&1
grep "Found private key" results.log
```

---

## 📄 Ejemplo de Línea de Comando Kangaroo

Kangaroo requiere tres parámetros principales:
```bash
./Kangaroo -r <start>:<end> -t <target_hash160> -g
```

Parámetros:
- -r: Rango de claves
- -t: Hash160 objetivo
- -g: Usa modo GPU si está disponible (requiere CUDA)

---

## 🧪 Tests y Verificación

Puedes probar el sistema con claves pequeñas y hash160s falsos para validar que el sistema recorra los rangos correctamente.

---

## 🤝 Contribuir
Pull Requests bienvenidas para mejoras como:

- [ ] UI Web para visualización de progreso
- [ ] Logs persistentes en contenedores
- [ ] Soporte multi-cloud

---

## ⚠️ Aviso Legal

Este software es solo para uso educativo e investigativo. El uso indebido para acceder a fondos ajenos en la blockchain de Bitcoin puede ser ilegal en tu jurisdicción. Úsalo bajo tu propio riesgo.

---

## 📜 Licencia
MIT — libre de usar, modificar, compartir.

---

## ✨ A caza del puzzle 69... que el canguro te acompañe.