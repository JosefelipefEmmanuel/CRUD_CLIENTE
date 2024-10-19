<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="modelo.ConexionBD" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formulario de Cliente</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f0f0f0; /* Color gris claro */
            margin: 0;
            padding: 10px; /* Menos padding vertical */
        }
        h1, h2 {
            text-align: center;
            color: #333;
            margin: 10px 0; /* Reducido el margen */
        }
        .container {
            display: flex;
            justify-content: space-between;
            max-width: 10000px; /* Ancho máximo del contenedor */
            margin: 0 auto; /* Centrado horizontal */
            padding: 50px; /* Reducido el espacio lateral */
            background: #e6f7ff; /* Color de fondo suave para el contenedor */
            border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
        }
        .formulario {
            flex: 1;
            margin-right: 50px; /* Espacio entre el formulario y la tabla */
            background: #ffffff; /* Fondo blanco para el formulario */
            padding: 20px; /* Agregado padding para el formulario */
            border-radius: 4px; /* Bordes redondeados para el formulario */
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
        }
        form {
            display: grid;
            gap: 5px; /* Menor espacio entre los elementos del formulario */
        }
        label {
            font-weight: bold;
            font-size: 14px; /* Reducido el tamaño de la fuente */
        }
        input[type="text"], input[type="email"], input[type="date"], select {
            padding: 6px; /* Menor padding */
            border: 1px solid #ccc;
            border-radius: 4px;
            width: 100%;
            box-sizing: border-box;
            transition: border 0.3s;
            font-size: 14px; /* Reducido el tamaño de la fuente */
        }
        input[type="submit"] {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 8px; /* Menor padding */
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px; /* Reducido el tamaño de la fuente */
            transition: background-color 0.3s;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .tabla-container {
            flex: 2; /* Para que la tabla ocupe más espacio */
            overflow-y: auto; /* Habilitar desplazamiento vertical si es necesario */
            max-height: 300px; /* Altura máxima de la tabla */
            background: #ffffff; /* Fondo blanco para la tabla */
            padding: 20px; /* Agregado padding para la tabla */
            border-radius: 4px; /* Bordes redondeados para la tabla */
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            border: 2px solid #007bff; /* Borde exterior de la tabla */
            border-radius: 4px; /* Bordes redondeados */
            overflow: hidden; /* Esconde los bordes redondeados */
        }
        th, td {
            padding: 8px; /* Menor padding */
            text-align: left;
            border-bottom: 1px solid #ddd; /* Borde entre filas */
            font-size: 12px; /* Reducido el tamaño de la fuente */
        }
        th {
            background-color: #007bff;
            color: white;
            border-bottom: 2px solid #0056b3; /* Borde inferior para el encabezado */
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        td {
            border: 1px solid #ddd; /* Borde entre celdas */
        }
    </style>
    <script>
        function seleccionarFila(index) {
            const fila = document.getElementById('cliente-data-' + index);
            const clienteData = fila.dataset;

            // Asignar los valores a los campos del formulario
            document.getElementById('index').value = index;
            document.getElementById('nombre').value = clienteData.nombre;
            document.getElementById('apellidos').value = clienteData.apellidos;
            document.getElementById('nit').value = clienteData.nit;
            document.getElementById('genero').value = clienteData.genero;
            document.getElementById('telefono').value = clienteData.telefono;
            document.getElementById('correo').value = clienteData.correoElectronico; // Cambiado para consistencia
            document.getElementById('fecha_ingreso').value = clienteData.fechaIngreso;
        }
    </script>
</head>
<body>
<div class="container">
    <div class="formulario">
        <h1>Registro de Cliente</h1>

        <% 
            // Mostrar mensajes de éxito o error
            String mensaje = (String) request.getAttribute("mensaje");
            if (mensaje != null) {
        %>
            <p style="color: red; text-align: center; margin: 5px 0;"><strong><%= mensaje %></strong></p> <!-- Reducido el margen -->
        <%
            }
        %>

        <form name="clienteForm" action="sr_clientes" method="POST">
            <input type="hidden" id="index" name="index">
            <label for="nombre">Nombre:</label>
            <input type="text" id="nombre" name="nombre" required>
            
            <label for="apellidos">Apellidos:</label>
            <input type="text" id="apellidos" name="apellidos" required>
            
            <label for="nit">NIT:</label>
            <input type="text" id="nit" name="nit" required>
            
            <label for="genero">Género:</label>
            <select id="genero" name="genero">
                <option value="Masculino">Masculino</option>
                <option value="Femenino">Femenino</option>
                <option value="Otro">Otro</option>
            </select>
            
            <label for="telefono">Teléfono:</label>
            <input type="text" id="telefono" name="telefono" required>
            
            <label for="correo">Correo:</label>
            <input type="email" id="correo" name="correo" required>
            
            <label for="fecha_ingreso">Fecha de Ingreso:</label>
            <input type="date" id="fecha_ingreso" name="fecha_ingreso" required>
            
            <div>
                <input type="submit" name="accion" value="Registrar Cliente">
                <input type="submit" name="accion" value="Modificar Cliente">
                <input type="submit" name="accion" value="Eliminar Cliente">
            </div>
        </form>
    </div>

    <div class="tabla-container">
        <h2>Lista de Clientes</h2>
        <table>
            <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Apellidos</th>
                <th>NIT</th>
                <th>Género</th>
                <th>Teléfono</th>
                <th>Correo Electrónico</th>
                <th>Fecha de Ingreso</th>
            </tr>
            <%
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    conn = ConexionBD.obtenerConexion();
                    String sql = "SELECT * FROM clientes"; // Asegúrate que el nombre de la tabla es correcto
                    stmt = conn.prepareStatement(sql);
                    rs = stmt.executeQuery();

                    if (!rs.isBeforeFirst()) { // Verifica si hay resultados
                        out.println("<tr><td colspan='8'>No se encontraron registros en la base de datos.</td></tr>");
                    } else {
                        while (rs.next()) {
                            int id = rs.getInt("id");
                            String nombreCliente = rs.getString("nombre");
                            String apellidosCliente = rs.getString("apellidos");
                            String nitCliente = rs.getString("nit");
                            String generoCliente = rs.getString("genero");
                            String telefonoCliente = rs.getString("telefono");
                            String correoCliente = rs.getString("correo"); // Verifica si este nombre es correcto
                            String fechaIngresoCliente = rs.getString("fecha_ingreso");
            %>
                            <tr id="cliente-data-<%= id %>" data-nombre="<%= nombreCliente %>" data-apellidos="<%= apellidosCliente %>" data-nit="<%= nitCliente %>" data-genero="<%= generoCliente %>" data-telefono="<%= telefonoCliente %>" data-correo-electronico="<%= correoCliente %>" data-fecha-ingreso="<%= fechaIngresoCliente %>" onclick="seleccionarFila(<%= id %>)">
                                <td><%= id %></td>
                                <td><%= nombreCliente %></td>
                                <td><%= apellidosCliente %></td>
                                <td><%= nitCliente %></td>
                                <td><%= generoCliente %></td>
                                <td><%= telefonoCliente %></td>
                                <td><%= correoCliente %></td>
                                <td><%= fechaIngresoCliente %></td>
                            </tr>
            <%
                        }
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
                    if (conn != null) try { conn.close(); } catch (SQLException e) {}
                }
            %>
        </table>
    </div>
</div>
</body>
</html>
