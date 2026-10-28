-- Actualiza una base "odontoapp" creada con la versión anterior (sin perder datos).
-- Ejecutar UNA sola vez, por ejemplo desde phpMyAdmin (pestaña SQL) con la base odontoapp seleccionada.
-- Si la base es de prueba y no tiene datos que importen, es más simple borrarla: la API la vuelve a crear al iniciar.

-- ---------- Paciente: contacto, cobertura y antecedentes médicos ----------
ALTER TABLE `paciente`
    ADD COLUMN `sexo` varchar(20) CHARACTER SET utf8mb4 NULL AFTER `fecha_nacimiento`,
    ADD COLUMN `ocupacion` varchar(100) CHARACTER SET utf8mb4 NULL AFTER `sexo`,
    ADD COLUMN `domicilio` varchar(200) CHARACTER SET utf8mb4 NULL AFTER `ocupacion`,
    ADD COLUMN `contacto_emergencia` varchar(150) CHARACTER SET utf8mb4 NULL AFTER `domicilio`,
    ADD COLUMN `plan` varchar(50) CHARACTER SET utf8mb4 NULL AFTER `obra_social`,
    ADD COLUMN `grupo_sanguineo` varchar(5) CHARACTER SET utf8mb4 NULL AFTER `nro_afiliado`,
    ADD COLUMN `diabetes` tinyint(1) NOT NULL DEFAULT 0,
    ADD COLUMN `hipertension` tinyint(1) NOT NULL DEFAULT 0,
    ADD COLUMN `embarazo` tinyint(1) NOT NULL DEFAULT 0,
    ADD COLUMN `asma` tinyint(1) NOT NULL DEFAULT 0,
    ADD COLUMN `cardiopatia` tinyint(1) NOT NULL DEFAULT 0,
    ADD COLUMN `anticoagulado` tinyint(1) NOT NULL DEFAULT 0,
    ADD COLUMN `hepatitis` tinyint(1) NOT NULL DEFAULT 0,
    ADD COLUMN `fumador` tinyint(1) NOT NULL DEFAULT 0,
    ADD COLUMN `alergias` varchar(255) CHARACTER SET utf8mb4 NULL,
    ADD COLUMN `medicacion_actual` varchar(255) CHARACTER SET utf8mb4 NULL,
    ADD COLUMN `otros_antecedentes` text CHARACTER SET utf8mb4 NULL,
    ADD COLUMN `consentimiento_firmado` tinyint(1) NOT NULL DEFAULT 0;

-- ---------- Turno: duración, notas, urgencia (sobreturno) y llegada a la sala de espera ----------
ALTER TABLE `turno`
    ADD COLUMN `duracion_minutos` int NOT NULL DEFAULT 30 AFTER `hora`,
    ADD COLUMN `notas` varchar(255) CHARACTER SET utf8mb4 NULL AFTER `motivo`,
    ADD COLUMN `urgencia` tinyint(1) NOT NULL DEFAULT 0 AFTER `notas`,
    ADD COLUMN `hora_llegada` time(6) NULL AFTER `urgencia`;

-- ---------- Historia clínica: consulta completa ----------
ALTER TABLE `historial_clinico`
    ADD COLUMN `tipo_registro` varchar(20) CHARACTER SET utf8mb4 NOT NULL DEFAULT 'Consulta' AFTER `fecha`,
    ADD COLUMN `tipo_consulta` varchar(20) CHARACTER SET utf8mb4 NULL AFTER `tipo_registro`,
    ADD COLUMN `ta_max` int NULL AFTER `tipo_consulta`,
    ADD COLUMN `ta_min` int NULL AFTER `ta_max`,
    ADD COLUMN `peso` decimal(5,1) NULL AFTER `ta_min`,
    ADD COLUMN `talla` decimal(5,1) NULL AFTER `peso`,
    ADD COLUMN `temperatura` decimal(4,1) NULL AFTER `talla`,
    ADD COLUMN `frecuencia_cardiaca` int NULL AFTER `temperatura`,
    ADD COLUMN `frecuencia_respiratoria` int NULL AFTER `frecuencia_cardiaca`,
    ADD COLUMN `saturacion_o2` int NULL AFTER `frecuencia_respiratoria`,
    ADD COLUMN `antecedentes_examen` text CHARACTER SET utf8mb4 NULL AFTER `motivo_consulta`,
    ADD COLUMN `prescripcion` text CHARACTER SET utf8mb4 NULL AFTER `tratamiento`,
    ADD COLUMN `informe` text CHARACTER SET utf8mb4 NULL AFTER `prescripcion`,
    ADD COLUMN `piezas` varchar(100) CHARACTER SET utf8mb4 NULL AFTER `informe`;

CREATE TABLE `diagnostico_atencion` (
    `id` int NOT NULL AUTO_INCREMENT,
    `historial_id` int NOT NULL,
    `orden` tinyint unsigned NOT NULL,
    `codigo` varchar(10) CHARACTER SET utf8mb4 NULL,
    `descripcion` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
    `caracter` varchar(20) CHARACTER SET utf8mb4 NOT NULL,
    CONSTRAINT `PK_diagnostico_atencion` PRIMARY KEY (`id`),
    CONSTRAINT `FK_diagnostico_atencion_historial_clinico_historial_id` FOREIGN KEY (`historial_id`) REFERENCES `historial_clinico` (`id`) ON DELETE CASCADE
) CHARACTER SET=utf8mb4;

CREATE TABLE `practica_atencion` (
    `id` int NOT NULL AUTO_INCREMENT,
    `historial_id` int NOT NULL,
    `codigo` varchar(10) CHARACTER SET utf8mb4 NULL,
    `descripcion` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
    `piezas` varchar(100) CHARACTER SET utf8mb4 NULL,
    `observaciones` varchar(500) CHARACTER SET utf8mb4 NULL,
    CONSTRAINT `PK_practica_atencion` PRIMARY KEY (`id`),
    CONSTRAINT `FK_practica_atencion_historial_clinico_historial_id` FOREIGN KEY (`historial_id`) REFERENCES `historial_clinico` (`id`) ON DELETE CASCADE
) CHARACTER SET=utf8mb4;

-- ---------- Tareas de la recepción / consultorio ----------
CREATE TABLE `tarea` (
    `id` int NOT NULL AUTO_INCREMENT,
    `texto` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
    `prioridad` varchar(10) CHARACTER SET utf8mb4 NOT NULL,
    `categoria` varchar(30) CHARACTER SET utf8mb4 NULL,
    `vence` date NULL,
    `completada` tinyint(1) NOT NULL,
    `completada_en` datetime(6) NULL,
    `usuario_id` int NOT NULL,
    `creado_en` datetime(6) NOT NULL,
    CONSTRAINT `PK_tarea` PRIMARY KEY (`id`),
    CONSTRAINT `FK_tarea_usuario_usuario_id` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`) ON DELETE RESTRICT
) CHARACTER SET=utf8mb4;

CREATE INDEX `IX_diagnostico_atencion_historial_id` ON `diagnostico_atencion` (`historial_id`);
CREATE INDEX `IX_practica_atencion_historial_id` ON `practica_atencion` (`historial_id`);
CREATE INDEX `IX_tarea_completada_vence` ON `tarea` (`completada`, `vence`);
CREATE INDEX `IX_tarea_usuario_id` ON `tarea` (`usuario_id`);
