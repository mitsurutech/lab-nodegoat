# Laboratorio OWASP NodeGoat con Docker Compose: practica el OWASP Top 10 en una aplicación Node.js insegura a propósito

[English](README.md) | [Français](README.fr.md) | [Español](README.es.md) | [日本語](README.ja.md) | [Deutsch](README.de.md)

[![check](https://github.com/mitsurutech/lab-nodegoat/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-nodegoat/actions/workflows/check.yml)

Un **laboratorio de seguridad de aplicaciones web** listo para clase, de la [plataforma de aprendizaje MitsuruTech](https://mitsurutech.co.uk/es/learning), donde colegios e institutos dan a cada estudiante sus propias bases de datos, contenedores y terminal en el navegador. Cada estudiante recibe su propia copia de **OWASP NodeGoat**, una web de ahorro para la jubilación escrita en **Node.js con MongoDB** que trae incorporadas las debilidades del **OWASP Top 10**, para practicar **inyección, autenticación rota, referencias directas inseguras a objetos, cross-site scripting** y más, con el propio tutorial de NodeGoat junto a cada una mostrando el código corregido. No se instala nada y no se pone en riesgo la máquina de nadie más.

Es un solo archivo `docker-compose`, `compose.yaml`, y funciona igual en tu ordenador que en la plataforma, donde cada estudiante recibe una copia privada sin salida a internet. La página del manual de ayuda para este laboratorio es [mitsurutech.co.uk/help/lab-nodegoat](https://mitsurutech.co.uk/help/lab-nodegoat).

## La única regla

**Ataca tu propia copia y nada más.** Todo en este laboratorio se ejecuta dentro de tu copia privada, que no tiene ruta a internet ni a ningún otro estudiante, así que lo único a lo que puedes llegar es la aplicación que el laboratorio arrancó para ti. Nunca apuntes una herramienta a una web, una red o una máquina que no sea tuya, ni en un laboratorio ni en ningún otro sitio: en el Reino Unido es un delito según la [Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents), y la mayoría de los países tienen una ley parecida. Aprender cómo funcionan las debilidades es la forma de crear software que no las tenga, y una buena primera conversación en clase es por qué existe esta regla y qué es la divulgación responsable.

## Qué contiene

| Servicio | Imagen | Memoria | Qué es |
| --- | --- | --- | --- |
| `nodegoat` | `ghcr.io/mitsurutech/nodegoat`, fijada por su digest | 256 MB | OWASP NodeGoat, la web en el puerto 4000 |
| `mongo` | [`mongo:4.4.30`](https://hub.docker.com/_/mongo) | 512 MB | la base de datos donde NodeGoat guarda sus usuarios y sus ahorros |

NodeGoat arranca en unos cuatro segundos con las imágenes ya descargadas, y los dos servicios usan unos 85 MB entre los dos en reposo. El laboratorio reinicia la base de datos cada vez que arranca, con el propio `artifacts/db-reset.js` de NodeGoat, y solo entonces se declara listo, así que «listo» significa que puedes iniciar sesión.

### De dónde viene la imagen de NodeGoat

**NodeGoat no publica ninguna imagen propia**, así que este repositorio construye una. Es [OWASP NodeGoat](https://github.com/OWASP/NodeGoat) en un commit concreto del proyecto original, `c5cb68a7084e4ae7dcc60e6a98768720a81841e8` (la punta de su `master` el 15 de octubre de 2026, después de la versión 1.3), construido con **el propio `Dockerfile` de NodeGoat** y publicado por el workflow de `.github/workflows/image.yml` como `ghcr.io/mitsurutech/nodegoat:1.3.0-c5cb68a`. El archivo compose la descarga **por su digest**, así que no puede cambiar bajo los pies de una clase de una lección a la siguiente.

**No está modificada.** No se cambia ni una línea del código fuente de NodeGoat ni de su Dockerfile: la lista de cambios hechos para que funcione está vacía. Lo único añadido son las etiquetas de la imagen (título, origen, revisión y licencia) y la forma en que el laboratorio la arranca, que está en `compose.yaml` y no en la imagen: un comando de arranque que reinicia la base de datos y luego ejecuta `node server.js`, y un healthcheck. NodeGoat tiene la [Apache License 2.0](https://github.com/OWASP/NodeGoat/blob/master/LICENSE), que permite redistribuirlo. Su `LICENSE` está dentro de la imagen, en `/home/node/app/LICENSE`, y junto a la construcción como [`image/UPSTREAM-LICENSE`](image/UPSTREAM-LICENSE); el proyecto original no incluye archivo `NOTICE`. NodeGoat es obra de la comunidad OWASP y no es producto nuestro: este repositorio es solo una forma de ejecutarlo en un laboratorio.

La imagen pública propia de MongoDB se usa tal cual. La imagen base de Node.js que nombra el Dockerfile de NodeGoat es antigua (Node 12), y eso forma parte de lo que es la aplicación: si la actualizas, la aplicación puede dejar de funcionar, y un laboratorio cuya aplicación no cambia nunca es lo que necesita una clase.

## Uso en la plataforma

La [plataforma de aprendizaje MitsuruTech](https://mitsurutech.co.uk/es/learning) da a cada estudiante su propia copia de un laboratorio, en el navegador, con una terminal al lado.

**Para probarlo:** abre la [página de contenedores](https://mitsurutech.co.uk/es/container), busca este laboratorio en **Sample labs** y pulsa Start. No hace falta cuenta para probar uno.

**Para ponerlo como tarea a una clase:**

1. En tu módulo, crea una tarea de tipo **Lab** y elige **In a GitHub repository**.
2. Indica `https://github.com/mitsurutech/lab-nodegoat` con la rama `main`. El archivo compose es el predeterminado, `compose.yaml`. Haz antes un fork del repositorio si quieres cambiar el archivo.
3. Publica. La copia de cada estudiante parte del commit que publicaste, así que un cambio posterior aquí no altera un laboratorio ya asignado.
4. Indica en la tarea qué hay que entregar (consulta [Para docentes](#para-docentes)) y asígnala como cualquier otra tarea.

La [guía de laboratorios de seguridad](https://mitsurutech.co.uk/es/help/security-labs) del manual de ayuda y su [guía de laboratorios de contenedores](https://mitsurutech.co.uk/es/help/labs) explican el resto: qué puede decir un archivo compose, cuánta memoria recibe una copia y cómo un docente abre, sigue y corrige la copia de un estudiante. La [vista general de laboratorios](https://mitsurutech.co.uk/es/help/labs) también enumera los demás laboratorios de ejemplo.

¿Aún no tienes cuenta de centro? [El primer año es gratis](https://mitsurutech.co.uk/es/pricing) para hasta 50 estudiantes, y para [registrarte](https://mitsurutech.co.uk/es/signup) basta un correo electrónico.

## Ejecutarlo en tu propio ordenador

Necesitas Docker con el plugin Compose. El primer arranque descarga las imágenes.

```bash
docker compose -f compose.yaml -f local.yaml up
```

Abre <http://localhost:4000> e inicia sesión como `user1` con la contraseña `User1_123`. El administrador es `admin` con `Admin_123`, y `user2` tiene `User2_123`.

`local.yaml` solo publica el puerto en `127.0.0.1`, así que el laboratorio solo es accesible desde tu ordenador. Detenlo con `Ctrl-C` y elimínalo con `docker compose -f compose.yaml -f local.yaml down -v`. Ejecútalo en una máquina desde la que no te importe atacar: la aplicación es insegura a propósito.

## Cómo recorrerlo

1. **Inicia sesión** como `user1`. La base de datos ya está creada, así que no hay nada que preparar. La página de inicio de sesión de NodeGoat tiene un enlace **Tutorial Guide** a su propio tutorial.
2. **Elige una debilidad.** El tutorial sigue el OWASP Top 10: inyección (incluida la inyección de JavaScript en el servidor en la página Contributions), autenticación y gestión de sesiones rotas, cross-site scripting, referencias directas inseguras a objetos (cambia el número al final de la dirección de Allocations), configuración de seguridad incorrecta, exposición de datos sensibles, falta de control de acceso, falsificación de petición en sitios cruzados, componentes con vulnerabilidades conocidas y redirecciones no validadas, con dos tutoriales más sobre falsificación de peticiones del lado del servidor y denegación de servicio por expresiones regulares.
3. **Explótala y luego lee la corrección.** Cada página del tutorial muestra el código vulnerable y el código corregido, y el código fuente lleva la corrección como comentario junto a la debilidad.
4. **Empieza de nuevo cuando quieras.** Parar y arrancar el laboratorio da una base de datos nueva, que es también la forma de volver de una página que hayas roto. Algunos ejercicios, como el de denegación de servicio por expresiones regulares del tutorial, están pensados para hacer daño al servidor.

## Para docentes

En este laboratorio no se corrige nada automáticamente. El estudiante entrega pruebas y tú las corriges, como cualquier otro laboratorio.

**Pide las pruebas en dos partes.** Primero, la prueba del trabajo: una captura de pantalla de cada debilidad usada, con la dirección del propio laboratorio visible en el navegador para que se vea claramente que es su copia. Segundo, la comprensión: para cada una, una explicación escrita con sus propias palabras de qué es la debilidad, la entrada exacta que usó y por qué funcionó, qué podría hacer un atacante con ella y cómo debería haberse escrito el código. La segunda parte te dice si lo ha entendido o lo ha copiado de una guía resuelta. Para un trabajo más exigente, pide la corrección además del ataque.

**Dónde encaja en un curso.** NodeGoat encaja en programación segura y el OWASP Top 10 dentro de una unidad de desarrollo web o de ciberseguridad: control de acceso, autenticación, tratamiento de entradas y codificación de salidas, en una aplicación escrita en JavaScript que un estudiante de web puede leer. También sirve para la parte legal y ética de una unidad: autorización y alcance, la Computer Misuse Act 1990 y la divulgación responsable. Consulta la redacción exacta en la unidad de tu propio organismo certificador; aquí no se cita ninguna.

**Quién ve qué.** Estos laboratorios se usan a menudo con estudiantes de 16 y 17 años. Una copia es privada para el estudiante que la arrancó. Un miembro del personal que imparte el módulo puede abrirla para ver lo que ha hecho el estudiante, y abrir el trabajo de un estudiante queda escrito en el registro de accesos, que el estudiante puede leer.

## Qué no funciona en un laboratorio

El laboratorio no tiene ninguna salida a internet. La página Learning Resources enlaza a webs externas y no muestra nada a lo que un laboratorio pueda llegar, y los ejercicios que piden una dirección de internet (el de falsificación de peticiones del lado del servidor del tutorial) solo pueden llegar a los propios servicios del laboratorio. NodeGoat recibe 256 MB y su base de datos 512 MB. La base de datos no se guarda: no se conserva nada al parar el laboratorio.

## Solución de problemas

- **La página de inicio de sesión no aparece justo después de Start.** Espera unos segundos y vuelve a pulsar Open: el laboratorio solo se declara listo cuando la base de datos ya está creada.
- **La web deja de responder después de un ejercicio.** Algunos ejercicios tumban el servidor a propósito. Para el laboratorio y arráncalo de nuevo para tener una copia nueva.
- **En tu ordenador, el puerto 4000 ya está en uso.** Cambia el número de la izquierda en `local.yaml`, por ejemplo `127.0.0.1:4001:4000`, y abre ese puerto en su lugar.

## Acerca de

Este laboratorio lo hace [Mitsuru Technologies Ltd](https://mitsurutech.co.uk/es), la empresa que está detrás de la [plataforma de aprendizaje MitsuruTech](https://mitsurutech.co.uk/es/learning): un lugar donde los docentes ponen trabajo de programación, bases de datos, contenedores y laboratorios y corrigen lo que entregan los estudiantes. Los archivos de este repositorio que escribimos nosotros (el archivo compose, las pruebas y el workflow) tienen licencia MIT, consulta [LICENSE](LICENSE); OWASP NodeGoat tiene licencia Apache-2.0 y pertenece a sus autores.

Otros laboratorios de la misma serie, cada uno en su propio repositorio y cada uno con una [página en el manual](https://mitsurutech.co.uk/es/help/labs):

- [lab-dvwa](https://github.com/mitsurutech/lab-dvwa): DVWA, la Damn Vulnerable Web Application
- [lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop): OWASP Juice Shop
- [lab-webgoat](https://github.com/mitsurutech/lab-webgoat): OWASP WebGoat y WebWolf
- [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin): MySQL y phpMyAdmin
- [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea): Git y Gitea
- [lab-sample](https://github.com/mitsurutech/lab-sample): PostgreSQL y PostgREST

## Sobre las contraseñas de este repositorio

Las cuentas de arriba (`user1`, `user2`, `admin`) son las cuentas de demostración que publica el propio NodeGoat. Son datos de ejercicio para un laboratorio que solo se ejecuta en tu ordenador o dentro de la plataforma, nunca credenciales reales, y están escritas aquí a propósito.
