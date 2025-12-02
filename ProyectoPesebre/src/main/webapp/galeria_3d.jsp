<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Galería 3D de Adornos Navideños</title>

    <!-- Carga de Bootstrap CSS (Para estilos de UI) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Carga de Three.js y OrbitControls/GLTFLoader (Patrón Estable de CDN) -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/controls/OrbitControls.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/loaders/GLTFLoader.js"></script>

    <!-- Enlace al archivo CSS externo (Colores Temáticos) -->
    <link rel="stylesheet" href="css/style.css">

    <style>
        /* Definición de variables de color (si no están en style.css) */
        :root {
            --color-pino: #004D40; 
            --color-rojo-oscuro: #8B0000;
            --color-oro: #FFD700;
            --color-crema: #F5F5DC;
        }

        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow: hidden; 
        }

        /* Contenedor principal de la simulación */
        main {
            height: 100vh;
            width: 100vw;
            position: relative;
        }

        canvas {
            display: block;
            width: 100%;
            height: 100%;
        }
        
        /* Botones de navegación */
        .nav-button {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            z-index: 10;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            background-color: var(--color-pino);
            color: white;
            border: 2px solid var(--color-oro);
            cursor: pointer;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 1.5rem;
            opacity: 0.85;
            transition: opacity 0.2s, background-color 0.2s;
        }
        .nav-button:hover {
            opacity: 1;
            background-color: var(--color-rojo-oscuro);
        }

        #loading-message {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(255, 255, 255, 0.9);
            padding: 10px 20px;
            border-radius: 5px;
            color: var(--color-pino);
            font-weight: bold;
            z-index: 5;
        }
    </style>
</head>

<body>
    <% 
        String contextPath = request.getContextPath(); 
        // Rutas de los modelos GLB (Deben existir en tu proyecto)
        String[] modelPaths = {
            contextPath + "/multimedia/models/adorno1.glb",
            contextPath + "/multimedia/models/adorno2.glb",
            contextPath + "/multimedia/models/adorno3.glb"
        };
        String[] modelTitles = {
            "Esfera Festiva Dorada",
            "Campana Clásica de Bronce",
            "Muñeco de Nieve Animado"
        };
        
        // Convertir arrays de Java a strings JSON para usar en JavaScript
        String jsModelPaths = "[";
        for (int i = 0; i < modelPaths.length; i++) {
            jsModelPaths += String.format("'%s'", modelPaths[i]);
            if (i < modelPaths.length - 1) jsModelPaths += ",";
        }
        jsModelPaths += "]";
        
        String jsModelTitles = "[";
        for (int i = 0; i < modelTitles.length; i++) {
            jsModelTitles += String.format("'%s'", modelTitles[i]);
            if (i < modelTitles.length - 1) jsModelTitles += ",";
        }
        jsModelTitles += "]";
    %>
    
    <main>
        <!-- Flecha de navegación IZQUIERDA -->
        <div id="prev-button" class="nav-button" style="left: 10px;">&lt;</div>
        
        <!-- Flecha de navegación DERECHA -->
        <div id="next-button" class="nav-button" style="right: 10px;">&gt;</div>
        
        <!-- Título del modelo actual -->
        <div style="position: absolute; top: 10px; width: 100%; text-align: center; z-index: 10; font-family: var(--font-coquette);">
            <h4 id="model-title" style="color: var(--color-pino); background: rgba(255, 255, 255, 0.7); display: inline-block; padding: 5px 15px; border-radius: 10px; border: 1px solid var(--color-pino);">Cargando...</h4>
        </div>
        
        <!-- Enlace para salir de la simulación -->
        <div style="position: absolute; bottom: 10px; left: 10px; z-index: 10;">
            <a href="<%= contextPath %>/index.jsp#juego" class="btn btn-sm" style="background-color: var(--color-rojo-oscuro); color: white;">
                &larr; Salir de la Galería
            </a>
        </div>
        
        <div id="loading-message">Iniciando 3D...</div>

        <!-- El Canvas se adjuntará aquí por JavaScript -->
    </main>

    <script>
        let scene, camera, renderer, controls;
        const loader = new THREE.GLTFLoader();
        let currentModel = null;
        let currentIndex = 0;

        const modelPaths = <%= jsModelPaths %>;
        const modelTitles = <%= jsModelTitles %>;

        const modelTitle = document.getElementById('model-title');
        const loadingMessage = document.getElementById('loading-message');
        const prevButton = document.getElementById('prev-button');
        const nextButton = document.getElementById('next-button');

        function init() {
            // Configuración base
            scene = new THREE.Scene();
            scene.background = new THREE.Color(0xF5F5DC); // Fondo crema

            camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 100);
            camera.position.set(0, 1, 4); // Posición inicial para ver el modelo central

            renderer = new THREE.WebGLRenderer({ antialias: true });
            renderer.setSize(window.innerWidth, window.innerHeight);
            renderer.setPixelRatio(window.devicePixelRatio);
            document.querySelector('main').appendChild(renderer.domElement);

            // Luces (Esenciales para ver el GLB)
            scene.add(new THREE.AmbientLight(0xffffff, 1)); // Luz blanca ambiental
            const light = new THREE.DirectionalLight(0xffffff, 2);
            light.position.set(5, 5, 5);
            scene.add(light);

            // Controles: OrbitControls para rotar el objeto con el mouse
            controls = new THREE.OrbitControls(camera, renderer.domElement);
            controls.enableDamping = true; // Efecto de arrastre suave
            controls.dampingFactor = 0.05;
            controls.screenSpacePanning = false; // Bloquear paneo lateral
            controls.enableKeys = false; // Deshabilitar teclado

            // Listeners
            window.addEventListener('resize', onWindowResize);
            prevButton.addEventListener('click', () => navigate(-1));
            nextButton.addEventListener('click', () => navigate(1));

            // Iniciar con el primer modelo
            loadModel(currentIndex);
            animate();
        }

        function loadModel(index) {
            if (currentModel) {
                scene.remove(currentModel);
                currentModel.traverse(function (child) {
                    if (child.isMesh) {
                        child.geometry.dispose();
                        child.material.dispose();
                    }
                });
                currentModel = null;
            }

            const path = modelPaths[index];
            modelTitle.textContent = "Cargando: " + modelTitles[index];
            loadingMessage.style.display = 'block';

            loader.load(
                path,
                function (gltf) {
                    currentModel = gltf.scene;
                    
                    // Centrar y escalar el modelo si es necesario
                    const box = new THREE.Box3().setFromObject(currentModel);
                    const size = box.getSize(new THREE.Vector3());
                    const center = box.getCenter(new THREE.Vector3());

                    // Ajustar escala para que quepa en la vista (ej. máximo 2 unidades)
                    const maxDim = Math.max(size.x, size.y, size.z);
                    const scaleFactor = 2.0 / maxDim;
                    currentModel.scale.set(scaleFactor, scaleFactor, scaleFactor);
                    
                    // Mover el modelo al centro de la escena (si Three.js lo carga descentrado)
                    currentModel.position.sub(center).add(new THREE.Vector3(0, size.y * scaleFactor / 2, 0)); 
                    
                    scene.add(currentModel);
                    modelTitle.textContent = modelTitles[index];
                    loadingMessage.style.display = 'none';

                    // Opcional: Rotación automática inicial
                    currentModel.rotation.y = Math.PI / 4;

                },
                function (xhr) {
                    // Función de progreso
                    const progress = (xhr.loaded / xhr.total) * 100;
                    // FIX CRÍTICO: Usar una función IIFE para evitar el conflicto de compilación JSP/EL
                    loadingMessage.textContent = (function() { 
                        return "Cargando: " + Math.round(progress) + "%";
                    })();
                },
                function (error) {
                    // Función de error
                    console.error(`Error al cargar GLB: ${path}`, error);
                    modelTitle.textContent = modelTitles[index] + " (ERROR)";
                    loadingMessage.textContent = "Error al cargar el modelo. Verifique la consola.";
                    
                    // --- FALLBACK VISUAL (Cubo simple) ---
                    const geometry = new THREE.BoxGeometry(1, 1, 1);
                    const material = new THREE.MeshBasicMaterial({ color: 0x8B0000 }); // Rojo vino
                    currentModel = new THREE.Mesh(geometry, material);
                    scene.add(currentModel);
                }
            );
        }

        function navigate(direction) {
            currentIndex += direction;
            const totalModels = modelPaths.length;
            
            if (currentIndex < 0) {
                currentIndex = totalModels - 1;
            } else if (currentIndex >= totalModels) {
                currentIndex = 0;
            }
            loadModel(currentIndex);
        }

        function onWindowResize() {
            camera.aspect = window.innerWidth / window.innerHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(window.innerWidth, window.innerHeight);
        }

        function animate() {
            requestAnimationFrame(animate);
            controls.update(); // Mantiene el damping (efecto suave)
            renderer.render(scene, camera);
        }

        window.onload = init;
    </script>
</body>
</html>