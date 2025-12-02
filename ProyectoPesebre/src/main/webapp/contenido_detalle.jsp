<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Datos.Contenido" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>

<%
    // Obtener datos del Servlet
    String categoria = (String) request.getAttribute("categoriaSeleccionada");
    @SuppressWarnings("unchecked")
    List<Contenido> contenidoLista = (List<Contenido>) request.getAttribute("contenidoLista");
    String contextPath = request.getContextPath();
    
    String tituloPagina = categoria != null ? categoria : "Contenido Detallado";
    
    // Determinar si debemos usar el layout de Línea de Tiempo
    boolean isTimeline = "Historia".equals(categoria);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= tituloPagina %> - La Natividad</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="bg-gray-100 p-8">
    <div class="max-w-7xl mx-auto bg-white p-8 rounded-xl shadow-2xl">
        <h1 class="text-4xl font-extrabold mb-2 text-color-azul">Categoría: <%= tituloPagina %></h1>
        <p class="text-xl text-gray-600 mb-8">
            <%= isTimeline ? "Línea de Tiempo Interactiva" : "Multimedia y detalles" %> sobre <%= tituloPagina.toLowerCase() %>.
        </p>
        
        <a href="<%= contextPath %>/index.jsp#contenido" class="inline-block mb-6 text-color-rojo hover:text-color-azul">&larr; Volver a las Categorías</a>

        <% if (contenidoLista == null || contenidoLista.isEmpty()) { %>
            <div class="p-8 text-center border-2 border-gray-300 rounded-lg text-gray-600">
                <p class="font-bold">Aún no hay contenido disponible para esta categoría.</p>
            </div>
        <% } else { %>
            
            <% if (isTimeline) { %>
                
                <!-- --- LÍNEA DE TIEMPO INTERACTIVA (CATEGORÍA HISTORIA) --- -->
                <div id="timeline-container" class="relative border-l-4 border-color-rojo ml-4 md:ml-12">
                    
                    <% 
                        int index = 0;
                        for (Contenido item : contenidoLista) { 
                            // Alternar diseño para efecto visual
                            boolean isLeft = index % 2 == 0;
                    %>
                    
                    <!-- Elemento de la Línea de Tiempo -->
                    <div class="mb-8 flex justify-between items-start w-full <%= isLeft ? "md:flex-row-reverse" : "md:flex-row" %> timeline-item">
                        
                        <!-- Punto de Círculo -->
                        <div class="absolute w-4 h-4 bg-color-oro rounded-full mt-1.5 <%= isLeft ? "-left-2" : "-left-2" %> border-4 border-white z-10"></div>
                        
                        <!-- Contenido Principal -->
                        <div class="bg-white p-6 rounded-lg shadow-lg w-full md:w-5/12 <%= isLeft ? "md:mr-auto" : "md:ml-auto" %> border-t-4 border-color-azul">
                            
                            <!-- Cabecera Desplegable (Clickable Header) -->
                            <div 
                                class="flex justify-between items-center cursor-pointer pb-2 mb-2 border-b-2 border-gray-100 hover:text-color-rojo transition duration-200"
                                onclick="toggleTimelineContent(<%= item.getId() %>)">
                                <h3 class="text-xl font-bold text-color-azul"><%= item.getTitulo() %></h3>
                                <svg id="icon-<%= item.getId() %>" class="w-5 h-5 transition-transform duration-300 transform" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
                            </div>

                            <!-- Contenido Desplegable -->
                            <div id="content-<%= item.getId() %>" class="hidden overflow-hidden transition-all duration-500">
                                <p class="text-gray-700 mb-4"><%= item.getCuerpo() %></p>

                                <!-- Multimedia (Código reutilizado del caso general) -->
                                <% 
                                    String url = item.getUrlMultimedia();
                                    if (url != null && !url.isEmpty()) {
                                        // Si la URL no es externa (http/https), anteponemos el ContextPath
                                        String finalUrl = url.startsWith("http") ? url : contextPath + "/" + url;
                                        
                                        if (item.isYoutubeVideo()) { %>
                                            <iframe width="100%" height="200" src="<%= finalUrl %>" frameborder="0" allowfullscreen class="rounded-lg"></iframe>
                                    <%  } else if (url.toLowerCase().endsWith(".mp3") || url.toLowerCase().endsWith(".wav")) { %>
                                            <audio controls class="w-full mt-2">
                                                <source src="<%= finalUrl %>" type="audio/mpeg">
                                            </audio>
                                    <%  } else if (url.toLowerCase().endsWith(".png") || url.toLowerCase().endsWith(".jpg") || url.toLowerCase().endsWith(".jpeg")) { %>
                                            <img src="<%= finalUrl %>" alt="<%= item.getTitulo() %>" class="w-full h-auto object-cover rounded-lg mt-2" onerror="this.onerror=null; this.src='https://placehold.co/400x200/D4AF37/FFFFFF?text=Imagen+Histórica'">
                                    <%  } else { %>
                                            <div class="p-2 text-xs text-gray-500">Recurso: <a href="<%= finalUrl %>" target="_blank" class="text-color-azul hover:underline">Ver</a></div>
                                    <%  }
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                    <% 
                            index++;
                        } 
                    %>
                </div>

            <% } else { %>
            
                <!-- --- LAYOUT DE CONTENIDO GENERAL (PARA OTRAS CATEGORÍAS) --- -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                    <% for (Contenido item : contenidoLista) { %>
                        <div class="bg-white p-6 rounded-xl shadow-lg border-t-4 border-color-oro">
                            <!-- ... (Contenido genérico como estaba antes) ... -->
                            <h2 class="text-2xl font-bold mb-3 text-color-azul"><%= item.getTitulo() %></h2>
                            <p class="text-gray-700 mb-4"><%= item.getCuerpo() %></p>
                            
                            <div class="mt-4 w-full bg-gray-100 rounded-lg overflow-hidden">
                                <% 
                                    String url = item.getUrlMultimedia();
                                    if (url != null && !url.isEmpty()) {
                                        String finalUrl = url.startsWith("http") ? url : contextPath + "/" + url;
                                        
                                        if (item.isYoutubeVideo()) { %>
                                            <iframe width="100%" height="315" src="<%= finalUrl %>" frameborder="0" allowfullscreen class="rounded-lg"></iframe>
                                    <%  } else if (url.toLowerCase().endsWith(".mp3") || url.toLowerCase().endsWith(".wav")) { %>
                                            <audio controls class="w-full p-4">
                                                <source src="<%= finalUrl %>" type="audio/mpeg">
                                            </audio>
                                    <%  } else if (url.toLowerCase().endsWith(".png") || url.toLowerCase().endsWith(".jpg") || url.toLowerCase().endsWith(".jpeg")) { %>
                                            <img src="<%= finalUrl %>" alt="Imagen de <%= item.getTitulo() %>" class="w-full h-auto object-cover rounded-lg" onerror="this.onerror=null; this.src='https://placehold.co/400x250/B8860B/FFFFFF?text=Imagen+no+disponible'">
                                    <%  } else if (url.toLowerCase().endsWith(".js") || url.toLowerCase().contains("threejs")) { %>
                                            <div class="p-8 text-center text-color-rojo font-bold border-4 border-dashed border-color-rojo bg-gray-50 h-64 flex items-center justify-center">
                                                Contenedor para Modelo 3D Interactivo (URL: <%= finalUrl %>)
                                            </div>
                                    <%  } else { %>
                                            <div class="p-4 text-center text-sm text-gray-500">
                                                Enlace no reconocido: <a href="<%= finalUrl %>" target="_blank" class="text-color-azul hover:underline">Ver Recurso</a>
                                            </div>
                                    <%  }
                                    } else { %>
                                        <div class="p-4 text-center text-sm text-gray-500">
                                            No hay recurso multimedia asociado a este detalle.
                                        </div>
                                    <% } %>
                            </div>
                            
                        </div>
                    <% } %>
                </div>
            <% } %>
            
        <% } %>
    </div>
    
    <!-- JavaScript para la funcionalidad de la Línea de Tiempo -->
    <script>
        /**
         * Función que alterna la visibilidad del contenido de un punto de la línea de tiempo.
         * @param {number} id - El ID del elemento de contenido (usamos el ID de la base de datos).
         */
        function toggleTimelineContent(id) {
            const content = document.getElementById(`content-${id}`);
            const icon = document.getElementById(`icon-${id}`);

            if (content.classList.contains('hidden')) {
                // Abrir
                content.classList.remove('hidden');
                content.style.maxHeight = content.scrollHeight + 'px';
                icon.classList.add('rotate-180');
            } else {
                // Cerrar
                content.style.maxHeight = '0';
                content.classList.add('hidden');
                icon.classList.remove('rotate-180');
            }
        }
    </script>
</body>
</html>