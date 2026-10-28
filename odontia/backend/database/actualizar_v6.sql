-- Versión 6: nota por pieza en el odontograma.
ALTER TABLE `odontograma_diente`
    ADD COLUMN `nota` varchar(255) CHARACTER SET utf8mb4 NULL AFTER `lingual`;
