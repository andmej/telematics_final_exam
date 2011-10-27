Banco de datos
==============

Ofrece los servicios en una API REST.

Todos los requests (excepto los de autenticación) deben estar acompañados de un parámetro `token` (por ejemplo, `http://host/ei/courses?token=asdf1234`). Cualquier requests que no tenga el parámetro `token` o tenga un `token` inválido será respondido con:

    <?xml version="1.0" encoding="UTF-8"?>
    <error>
      <mensaje>Token inválido</mensaje>
    </error>

En adelante se excluye el parámetro `token` de todos los ejemplos, por simplicidad.

Eafit Interactiva
-----------------

* `String login(String username, String password)`

  Implementado en `POST http://host/ei/session`

  **Ejemplo:**
      `curl -d username=amejiap3 -d password=asdf http://localhost:3001/ei/session`

  Respuesta:

    <?xml version="1.0" encoding="UTF-8"?>
    <ei>
      <autenticacion>
        <status>ok</status>
        <token>r4nd0mn3ss</token>
      </autenticacion>
    </ei>
    

 `curl -d username=amejiap3 -d password=invalid http://localhost:3001/ei/session`

    <?xml version="1.0" encoding="UTF-8"?>
    <ei>
      <autenticacion>
        <status>error</status>
        <token nil="true"></token>
      </autenticacion>
    </ei>


* `String getCursos(String token)`

 Implementado en `GET http://host/ei/courses`
 
 **Ejemplo:**
 
 `curl http://localhost:3001/ei/courses`
 
 Respuesta:
 
    <?xml version="1.0" encoding="UTF-8"?>
    <ei>
      <cursos>
        <curso>
          <codigo>st0263</codigo>
          <nombre>Topicos Especiales en Telematica</nombre>
          <grupo>031</grupo>
        </curso>
        <curso>
          <codigo>st0260</codigo>
          <nombre>Seminario de Ingeniería de Sistemas</nombre>
          <grupo>032</grupo>
        </curso>
      </cursos>
    </ei>
 
 
    String getContenidosCursos(String token, String cursoId)
    String getListaClase(String token, String cursoId, String grupo)

Programación Académica
-----------------

    String login(String username, String password)
    String getProgramacion(String token, String cursoId, String grupo, String semestre)

Admisiones y Registro
-----------------

    String login(String username, String password)
    String consultaEstudiantesPorNombre(String token, String patronNombre)
    String consultaDatosEstudiante(String token, string codEstudiante)
