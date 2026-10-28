-- Versión 3: consultorio (empresa), invitaciones y usuarios vinculados al consultorio.
-- Ejecutar UNA sola vez en una base "odontoapp" creada con la versión 2 (sin perder datos).
-- phpMyAdmin > odontoapp > pestaña SQL. Requiere MySQL 8 o MariaDB 10.5+.
-- Si la base es de prueba, es más simple borrarla: la API la vuelve a crear al iniciar.

START TRANSACTION;

-- ---------- Consultorio: la "empresa" creada por el odontólogo ----------
CREATE TABLE `consultorio` (
    `id` int NOT NULL AUTO_INCREMENT,
    `nombre` varchar(120) CHARACTER SET utf8mb4 NOT NULL,
    `creado_en` datetime(6) NOT NULL,
    CONSTRAINT `PK_consultorio` PRIMARY KEY (`id`)
) CHARACTER SET=utf8mb4;

-- Consultorio inicial para los datos existentes (la base v2 tenía un solo consultorio implícito).
INSERT INTO `consultorio` (`nombre`, `creado_en`) VALUES ('Consultorio', UTC_TIMESTAMP(6));
SET @consultorio_inicial = LAST_INSERT_ID();

-- ---------- Usuario: vínculo con el consultorio, correo, estado ----------
ALTER TABLE `usuario`
    ADD COLUMN `consultorio_id` int NULL AFTER `id`,
    ADD COLUMN `email` varchar(150) CHARACTER SET utf8mb4 NULL AFTER `usuario`,
    ADD COLUMN `activo` tinyint(1) NOT NULL DEFAULT 1 AFTER `rol`,
    ADD COLUMN `creado_en` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) AFTER `activo`;

UPDATE `usuario` SET `consultorio_id` = @consultorio_inicial WHERE `consultorio_id` IS NULL;

ALTER TABLE `usuario`
    MODIFY COLUMN `consultorio_id` int NOT NULL,
    ADD INDEX `IX_usuario_email` (`email`),
    ADD INDEX `IX_usuario_consultorio_id` (`consultorio_id`),
    ADD CONSTRAINT `FK_usuario_consultorio` FOREIGN KEY (`consultorio_id`)
        REFERENCES `consultorio` (`id`) ON DELETE RESTRICT;

-- ---------- Invitacion: alta de la secretaria por enlace de un solo uso ----------
-- Se guarda solo el hash SHA-256 del token; el enlace se muestra una única vez al odontólogo.
CREATE TABLE `invitacion` (
    `id` int NOT NULL AUTO_INCREMENT,
    `consultorio_id` int NOT NULL,
    `email` varchar(150) CHARACTER SET utf8mb4 NOT NULL,
    `rol` varchar(20) CHARACTER SET utf8mb4 NOT NULL,
    `token_hash` char(64) CHARACTER SET ascii NOT NULL,
    `creada_por_id` int NOT NULL,
    `creada_en` datetime(6) NOT NULL,
    `expira_en` datetime(6) NOT NULL,
    `usada_en` datetime(6) NULL,
    `usuario_creado_id` int NULL,
    `revocada_en` datetime(6) NULL,
    CONSTRAINT `PK_invitacion` PRIMARY KEY (`id`),
    CONSTRAINT `UQ_invitacion_token_hash` UNIQUE (`token_hash`),
    INDEX `IX_invitacion_consultorio_email` (`consultorio_id`, `email`),
    CONSTRAINT `FK_invitacion_consultorio` FOREIGN KEY (`consultorio_id`)
        REFERENCES `consultorio` (`id`) ON DELETE CASCADE,
    CONSTRAINT `FK_invitacion_creada_por` FOREIGN KEY (`creada_por_id`)
        REFERENCES `usuario` (`id`) ON DELETE RESTRICT
) CHARACTER SET=utf8mb4;

COMMIT;
