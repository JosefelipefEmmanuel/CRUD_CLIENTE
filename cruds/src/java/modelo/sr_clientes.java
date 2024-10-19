/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package modelo;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/sr_clientes")
public class sr_clientes extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public sr_clientes() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener los datos del formulario
        String nombre = request.getParameter("nombre");
        String apellidos = request.getParameter("apellidos");
        String nit = request.getParameter("nit");
        String genero = request.getParameter("genero");
        String telefono = request.getParameter("telefono");
        String correo = request.getParameter("correo");
        String fechaIngreso = request.getParameter("fecha_ingreso");
        String accion = request.getParameter("accion");
        String index = request.getParameter("index");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConexionBD.obtenerConexion();

            if ("Registrar Cliente".equals(accion)) {
                // Insertar cliente en la base de datos
                String sql = "INSERT INTO clientes (nombre, apellidos, nit, genero, telefono, correo, fecha_ingreso) VALUES (?, ?, ?, ?, ?, ?, ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, nombre);
                stmt.setString(2, apellidos);
                stmt.setString(3, nit);
                stmt.setString(4, genero);
                stmt.setString(5, telefono);
                stmt.setString(6, correo);
                stmt.setString(7, fechaIngreso);
                stmt.executeUpdate();
                request.setAttribute("mensaje", "Cliente registrado exitosamente.");

            } else if ("Modificar Cliente".equals(accion)) {
                if (index != null && !index.isEmpty()) {
                    // Actualizar cliente
                    String sql = "UPDATE clientes SET nombre=?, apellidos=?, nit=?, genero=?, telefono=?, correo=?, fecha_ingreso=? WHERE id=?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, nombre);
                    stmt.setString(2, apellidos);
                    stmt.setString(3, nit);
                    stmt.setString(4, genero);
                    stmt.setString(5, telefono);
                    stmt.setString(6, correo);
                    stmt.setString(7, fechaIngreso);
                    stmt.setInt(8, Integer.parseInt(index));
                    stmt.executeUpdate();
                    request.setAttribute("mensaje", "Cliente modificado exitosamente.");
                }
            } else if ("Eliminar Cliente".equals(accion)) {
                if (index != null && !index.isEmpty()) {
                    // Eliminar cliente
                    String sql = "DELETE FROM clientes WHERE id=?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, Integer.parseInt(index));
                    stmt.executeUpdate();
                    request.setAttribute("mensaje", "Cliente eliminado exitosamente.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Error al interactuar con la base de datos: " + e.getMessage());
        } finally {
            ConexionBD.cerrarConexion(conn);
        }

        // Redirigir de nuevo a la página JSP para mostrar el resultado
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
