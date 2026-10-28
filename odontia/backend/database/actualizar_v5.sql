-- Versión 5: nuevos estados del odontograma (caries, obturación, sellante, endodoncia, implante).
-- Las caras que tenían 'Requerida' o 'Existente' pasan a obturación, la prestación más frecuente.
-- Los colores cambian: rojo = a realizar, azul = existente. Los significados guardados no cambian.
SET SQL_SAFE_UPDATES = 0;

UPDATE odontograma_diente SET oclusal = 'ObturacionRequerida' WHERE oclusal = 'Requerida';
UPDATE odontograma_diente SET oclusal = 'ObturacionExistente' WHERE oclusal = 'Existente';
UPDATE odontograma_diente SET mesial = 'ObturacionRequerida' WHERE mesial = 'Requerida';
UPDATE odontograma_diente SET mesial = 'ObturacionExistente' WHERE mesial = 'Existente';
UPDATE odontograma_diente SET distal = 'ObturacionRequerida' WHERE distal = 'Requerida';
UPDATE odontograma_diente SET distal = 'ObturacionExistente' WHERE distal = 'Existente';
UPDATE odontograma_diente SET vestibular = 'ObturacionRequerida' WHERE vestibular = 'Requerida';
UPDATE odontograma_diente SET vestibular = 'ObturacionExistente' WHERE vestibular = 'Existente';
UPDATE odontograma_diente SET lingual = 'ObturacionRequerida' WHERE lingual = 'Requerida';
UPDATE odontograma_diente SET lingual = 'ObturacionExistente' WHERE lingual = 'Existente';

SET SQL_SAFE_UPDATES = 1;
