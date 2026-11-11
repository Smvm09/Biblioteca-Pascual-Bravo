-- 1. Eliminar tablas si existen para reiniciar la base de datos de forma limpia
DROP TABLE IF EXISTS prestamos CASCADE;
DROP TABLE IF EXISTS libros CASCADE;
DROP TABLE IF EXISTS categorias CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;

-- 2. Tabla de Categorías (Organización del catálogo)
CREATE TABLE categorias (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

-- 3. Tabla de Usuarios (Lectores y Administradores)
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    documento VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    rol VARCHAR(20) DEFAULT 'lector' CHECK (rol IN ('lector', 'administrador')),
    estado VARCHAR(20) DEFAULT 'activo' CHECK (estado IN ('activo', 'suspendido'))
);

-- 4. Tabla de Libros (Inventario)
CREATE TABLE libros (
    id SERIAL PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    autor VARCHAR(150) NOT NULL,
    categoria_id INT NOT NULL,
    ejemplares_totales INT NOT NULL CHECK (ejemplares_totales >= 0),
    ejemplares_disponibles INT NOT NULL CHECK (ejemplares_disponibles >= 0 AND ejemplares_disponibles <= ejemplares_totales),
    CONSTRAINT fk_categoria FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE CASCADE
);

-- 5. Tabla de Préstamos 
CREATE TABLE prestamos (
    id SERIAL PRIMARY KEY,
    usuario_id INT NOT NULL,
    libro_id INT NOT NULL,
    fecha_prestamo DATE DEFAULT CURRENT_DATE,
    fecha_limite DATE NOT NULL,
    fecha_devolucion DATE,
    estado VARCHAR(20) DEFAULT 'prestado' CHECK (estado IN ('prestado', 'devuelto', 'vencido')),
    CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    CONSTRAINT fk_libro FOREIGN KEY (libro_id) REFERENCES libros(id) ON DELETE CASCADE
);

-- =======================================================
-- DATOS DE PRUEBA (Para iniciar con información básica)
-- =======================================================

INSERT INTO categorias (nombre) VALUES 
('Ficción'), 
('Tecnología'), 
('Historia'), 
('Ciencia');

INSERT INTO usuarios (documento, nombre, email, rol) VALUES
('10001', 'Samuel Vidal', 'samuel@example.com', 'administrador'),
('10002', 'Carlos Pérez', 'carlos@example.com', 'lector');

INSERT INTO libros (isbn, titulo, autor, categoria_id, ejemplares_totales, ejemplares_disponibles) VALUES
('978-0132350884', 'Clean Code', 'Robert C. Martin', 2, 5, 5),
('978-0547928227', 'El Hobbit', 'J.R.R. Tolkien', 1, 3, 3);