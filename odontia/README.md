# Odontia (OdontoApp): consultorio odontológico independiente

Sistema para **un odontólogo independiente y una secretaria**: agenda única, pacientes, historia clínica,
odontograma, laboratorio, pagos y finanzas. Diseño basado en el prototipo "Odontia" (Figma) y en la planilla
de atención ambulatoria (signos vitales, diagnóstico CIE-10, prácticas por pieza).

Backend ASP.NET Core 8 + EF Core (MySQL / Pomelo) · Frontend React 18 + Vite + react-router-dom.

| Servicio | URL local |
|---|---|
| Frontend (lo que se abre en el navegador) | **http://localhost:5173** |
| API | http://localhost:5000/api |

## Cómo levantarlo en localhost

Requisitos (instalar una vez):
- **MySQL 8** o **MariaDB** (por ejemplo XAMPP: iniciar "MySQL" desde el panel). Por defecto se conecta como `root` sin contraseña a la base `odontoapp`, que se crea sola. Cambialo en `backend/OdontoApp.Api/appsettings.Development.json`.
- **.NET SDK 8 o superior**.
- **Node.js 20 o superior** (https://nodejs.org).

1. Backend (terminal 1):
   ```bash
   cd backend/OdontoApp.Api
   dotnet run
   ```
   La primera vez crea las tablas. No crea usuarios: el primer ingreso es el alta del odontólogo dueño.
2. Frontend (terminal 2):
   ```bash
   cd frontend
   npm install
   npm run dev
   ```
3. Abrir **http://localhost:5173**. Como el consultorio todavía no existe, la app muestra **Crear el consultorio**: el odontólogo escribe el nombre y entra con su cuenta de Google. Después, desde *Perfil y configuración* invitás a la secretaria por correo (enlace de un solo uso). Ella entra con la cuenta de Google de ese mismo correo.

### Inicio de sesión con Google

El ingreso usa **Firebase Authentication** con el proveedor Google. El proyecto de Firebase ya viene configurado en `backend/OdontoApp.Api/appsettings.json` y en `frontend/.env.local`, así que **no hace falta crear ninguna cuenta ni proyecto**. Solo hay que tener internet para iniciar sesión.

La API verifica el token de Google con certificados públicos: no guarda contraseñas ni claves secretas de Firebase.

### Si ya tenías la base de la versión anterior

La API crea las tablas solo cuando la base no existe (`EnsureCreated`), así que **no agrega las columnas nuevas** a una base vieja. Dos opciones:
- **Base de prueba:** borrar la base `odontoapp` (phpMyAdmin › Operaciones › Eliminar) y volver a ejecutar `dotnet run`.
- **Conservar los datos:** ejecutar una vez `backend/database/actualizar_v2.sql` en phpMyAdmin (pestaña SQL).

Si preferís crear la base a mano, el script completo está en `backend/database/schema.sql`.

## Un odontólogo y una secretaria

- Hay **un odontólogo dueño** y **secretarias invitadas**. Todos entran **solo con Google**: la app no guarda contraseñas ni credenciales. La base solo registra quién está autorizado (correo, rol y el identificador de Google) y si está activo.
- La agenda es **una sola columna**: dos turnos no se pueden superponer (cada turno tiene su duración). La única excepción es un turno marcado como **urgencia / sobreturno**.
- El horario de atención, el bloqueo de almuerzo, los sábados y la duración por defecto se configuran en `appsettings.json` › `Agenda`.

## Módulos

| Módulo | Dónde | Secretaria | Odontólogo |
|---|---|---|---|
| Inicio de recepción: sala de espera, agenda del día, confirmaciones, tareas, laboratorio, cobros | Inicio | ✅ | — |
| Inicio clínico: paciente en sala, alertas clínicas, turnos, finanzas del mes | Inicio | — | ✅ |
| Agenda día / semana / mes, nuevo turno con horarios libres, reprogramar, cancelar | Agenda | ✅ | ✅ |
| Llegada a la sala de espera ("Llegó"), confirmación, ausencia | Agenda, Inicio | ✅ | ✅ |
| Marcar turno como atendido / iniciar consulta | Agenda, Inicio | ❌ | ✅ |
| Recordatorio por WhatsApp (abre el mensaje listo para enviar) | Turnos y tareas | ✅ | ✅ |
| Tareas del consultorio (prioridad, categoría, vencimiento) | Turnos y tareas | ✅ | ✅ |
| Pacientes: datos, contacto, cobertura, antecedentes médicos, consentimiento | Pacientes, ficha | ✅ | ✅ |
| Alertas médicas (alergias, anticoagulado, diabetes…) | Agenda, ficha, inicio | ✅ ve las alertas | ✅ |
| Historia clínica: nueva consulta (1.ª vez / ulterior, signos vitales, motivo, examen, diagnóstico CIE-10 P/C, tratamiento, receta, prácticas por pieza, informe, evolución, honorarios) | Ficha › Historia clínica | ❌ | ✅ |
| Odontograma FDI | Ficha › Odontograma | ❌ | ✅ |
| Pagos del paciente y cuenta corriente | Ficha › Pagos, Pagos de pacientes | ✅ registrar | ✅ registrar / anular |
| Finanzas: ingresos y egresos | Finanzas | ❌ | ✅ |
| Trabajos de laboratorio | Laboratorio dental, ficha | ✅ | ✅ (+ pagar al laboratorio) |
| Equipo (invitaciones, activar o desactivar), permisos por rol | Perfil y configuración | ✅ ve sus datos | ✅ |

Cómo se conectan las finanzas:
- **Atención con honorarios** → cargo en la cuenta corriente del paciente.
- **Pago de paciente** → baja el saldo y genera automáticamente un **ingreso** en Finanzas.
- **Pago a laboratorio** → genera automáticamente un **egreso** (categoría Laboratorio).
- Los demás movimientos (alquiler, insumos, obra social…) se cargan a mano en *Finanzas*.
- Los pagos no se borran, se anulan; su ingreso deja de contar.

## Cambios al DER (versión 2)

- `paciente`: + `sexo`, `ocupacion`, `domicilio`, `contacto_emergencia`, `plan`, `grupo_sanguineo`, antecedentes (`diabetes`, `hipertension`, `embarazo`, `asma`, `cardiopatia`, `anticoagulado`, `hepatitis`, `fumador`), `alergias`, `medicacion_actual`, `otros_antecedentes`, `consentimiento_firmado`.
- `turno`: + `duracion_minutos`, `notas`, `urgencia`, `hora_llegada`; nuevo estado `EnSala`.
- `historial_clinico`: + `tipo_registro`, `tipo_consulta`, signos vitales (`ta_max`, `ta_min`, `peso`, `talla`, `temperatura`, `frecuencia_cardiaca`, `frecuencia_respiratoria`, `saturacion_o2`), `antecedentes_examen`, `prescripcion`, `informe`, `piezas`.
- Nuevas tablas: `diagnostico_atencion` (hasta 3 diagnósticos CIE-10 por atención, presuntivo/confirmado), `practica_atencion` (hallazgos y prácticas con piezas), `tarea`.

## Estructura

```
backend/OdontoApp.Api/
  Models/            Entidades EF Core (tablas y columnas en snake_case)
  Data/              OdontoDbContext + DbSeeder (solo desarrollo)
  Auth/              JWT, roles
  Agenda/            Horario, almuerzo, duración del turno y zona horaria del consultorio
  Dtos/              DTOs y mapeos entidad → DTO
  Controllers/       Auth, Turnos, Pacientes, HistorialClinico, Odontograma, Pagos, Caja, Laboratorio, Tareas
backend/database/schema.sql        Script SQL completo
backend/database/actualizar_v2.sql Actualización de una base de la versión anterior
frontend/src/
  api/, auth/        Cliente HTTP con JWT, sesión y rutas por rol
  components/        Layout (barra lateral), buscador, formularios, Tareas, HistoriaClinica, odontograma/…
  pages/             Login, inicios por rol, Agenda, TurnosYTareas, Pacientes, NuevoPaciente, FichaPaciente,
                     Clinica, Laboratorio, Pagos, Caja (Finanzas), Perfil
  utils/             Formatos, catálogos clínicos (CIE-10, prácticas) y acciones de turnos
```

## Pendiente / fuera de alcance

- Adjuntar archivos (radiografías, consentimiento firmado escaneado) a la historia clínica: requiere definir dónde se guardan los archivos.
- Envío automático de recordatorios: hoy el botón WhatsApp abre el mensaje para que la secretaria lo envíe.

## Producción

`appsettings.Development.json` trae valores de prueba (clave JWT y conexión). En producción no se usa: configurá
`Jwt:Key`, `ConnectionStrings:Default` y `Google:ClientId` con `dotnet user-secrets` o variables de entorno, y
reemplazá la creación automática de tablas por migraciones (`dotnet ef migrations add Inicial`).
