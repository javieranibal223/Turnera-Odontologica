-- Versión 7: nombres de estados alineados con las opciones de la pantalla.
-- Requerida pasa a ARealizar (rojo). Ausente pasa a AusenteExistente; AExtraer pasa a ExtraccionARealizar.
SET SQL_SAFE_UPDATES = 0;

UPDATE odontograma_diente SET oclusal = 'CariesARealizar' WHERE oclusal = 'CariesRequerida';
UPDATE odontograma_diente SET oclusal = 'ObturacionARealizar' WHERE oclusal = 'ObturacionRequerida';
UPDATE odontograma_diente SET mesial = 'CariesARealizar' WHERE mesial = 'CariesRequerida';
UPDATE odontograma_diente SET mesial = 'ObturacionARealizar' WHERE mesial = 'ObturacionRequerida';
UPDATE odontograma_diente SET distal = 'CariesARealizar' WHERE distal = 'CariesRequerida';
UPDATE odontograma_diente SET distal = 'ObturacionARealizar' WHERE distal = 'ObturacionRequerida';
UPDATE odontograma_diente SET vestibular = 'CariesARealizar' WHERE vestibular = 'CariesRequerida';
UPDATE odontograma_diente SET vestibular = 'ObturacionARealizar' WHERE vestibular = 'ObturacionRequerida';
UPDATE odontograma_diente SET lingual = 'CariesARealizar' WHERE lingual = 'CariesRequerida';
UPDATE odontograma_diente SET lingual = 'ObturacionARealizar' WHERE lingual = 'ObturacionRequerida';

UPDATE odontograma_diente SET estado_general = 'CoronaARealizar' WHERE estado_general = 'CoronaRequerida';
UPDATE odontograma_diente SET estado_general = 'EndodonciaARealizar' WHERE estado_general = 'EndodonciaRequerida';
UPDATE odontograma_diente SET estado_general = 'ImplanteARealizar' WHERE estado_general = 'ImplanteRequerida';
UPDATE odontograma_diente SET estado_general = 'ProtesisFijaARealizar' WHERE estado_general = 'ProtesisFijaRequerida';
UPDATE odontograma_diente SET estado_general = 'ProtesisRemovibleARealizar' WHERE estado_general = 'ProtesisRemovibleRequerida';
UPDATE odontograma_diente SET estado_general = 'ExtraccionARealizar' WHERE estado_general = 'AExtraer';
UPDATE odontograma_diente SET estado_general = 'AusenteExistente' WHERE estado_general = 'Ausente';

SET SQL_SAFE_UPDATES = 1;
