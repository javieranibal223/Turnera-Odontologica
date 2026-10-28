-- Versión 9: el historial de la secretaria guarda el nivel con el que se hizo cada acción
-- (Con acceso = Permitido, Con registro = ConAprobacion). Las filas anteriores eran todas de "Con registro".
-- Ejecutar después de actualizar_v8.sql.
ALTER TABLE `actividad_permiso`
    ADD COLUMN `nivel` varchar(20) CHARACTER SET utf8mb4 NOT NULL DEFAULT 'ConAprobacion' AFTER `accion`;
