-- Versión 4: inicio de sesión solo con Google. Se eliminan usuario y contraseña (sin credenciales locales).
-- Ejecutar UNA sola vez sobre una base "odontoapp" de la versión 3, con datos.
--
-- ANTES DE EJECUTAR: todos los usuarios necesitan correo (será su identificador de Google).
-- Revisá y completá los que falten:
--   SELECT id, nombre FROM usuario WHERE email IS NULL OR email = '';
--   UPDATE usuario SET email = 'correo@ejemplo.com' WHERE id = 1;
--
-- El primer paso hace fallar el script si queda algún usuario sin correo, antes de borrar nada.

-- 1) Correo obligatorio (falla aquí si hay usuarios sin correo).
ALTER TABLE `usuario`
    MODIFY COLUMN `email` varchar(150) CHARACTER SET utf8mb4 NOT NULL;

-- 2) Quitar credenciales locales.
ALTER TABLE `usuario`
    DROP INDEX `IX_usuario_usuario`,
    DROP INDEX `IX_usuario_email`,
    DROP COLUMN `usuario`,
    DROP COLUMN `password`;

-- 3) Identificador de Google y unicidad por consultorio.
ALTER TABLE `usuario`
    ADD COLUMN `google_sub` varchar(255) CHARACTER SET ascii NULL AFTER `email`,
    ADD CONSTRAINT `UQ_usuario_google_sub` UNIQUE (`google_sub`),
    ADD CONSTRAINT `UQ_usuario_consultorio_email` UNIQUE (`consultorio_id`, `email`);
