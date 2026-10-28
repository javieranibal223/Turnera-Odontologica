-- Versión 8: permisos configurables de la secretaria y registro de acciones con aprobación.
CREATE TABLE `permiso_rol` (
    `id` int NOT NULL AUTO_INCREMENT,
    `consultorio_id` int NOT NULL,
    `rol` varchar(20) CHARACTER SET utf8mb4 NOT NULL,
    `modulo` varchar(40) CHARACTER SET utf8mb4 NOT NULL,
    `accion` varchar(30) CHARACTER SET utf8mb4 NOT NULL,
    `nivel` varchar(20) CHARACTER SET utf8mb4 NOT NULL,
    CONSTRAINT `PK_permiso_rol` PRIMARY KEY (`id`),
    CONSTRAINT `UQ_permiso_rol` UNIQUE (`consultorio_id`, `rol`, `modulo`, `accion`),
    CONSTRAINT `FK_permiso_rol_consultorio` FOREIGN KEY (`consultorio_id`) REFERENCES `consultorio` (`id`) ON DELETE CASCADE
) CHARACTER SET=utf8mb4;

CREATE TABLE `actividad_permiso` (
    `id` int NOT NULL AUTO_INCREMENT,
    `consultorio_id` int NOT NULL,
    `usuario_id` int NOT NULL,
    `modulo` varchar(40) CHARACTER SET utf8mb4 NOT NULL,
    `accion` varchar(30) CHARACTER SET utf8mb4 NOT NULL,
    `creado_en` datetime(6) NOT NULL,
    CONSTRAINT `PK_actividad_permiso` PRIMARY KEY (`id`),
    CONSTRAINT `FK_actividad_permiso_consultorio` FOREIGN KEY (`consultorio_id`) REFERENCES `consultorio` (`id`) ON DELETE CASCADE,
    CONSTRAINT `FK_actividad_permiso_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`) ON DELETE RESTRICT
) CHARACTER SET=utf8mb4;
