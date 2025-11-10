/// Constantes de la aplicación
/// Centraliza todos los valores constantes para evitar hardcoding
class AppConstants {
  // Prevenir instanciación
  AppConstants._();

  // Keys para SharedPreferences
  static const String usersStorageKey = 'users_data';

  // Límites de validación
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minAge = 0;
  static const int maxAge = 150;

  // Mensajes de validación
  static const String requiredFieldMessage = 'Este campo es requerido';
  static const String invalidNameMessage = 'Nombre inválido';
  static const String invalidLastNameMessage = 'Apellido inválido';
  static const String invalidDateMessage = 'Fecha inválida';
  static const String futureDateMessage = 'La fecha no puede ser futura';
  static const String invalidAgeMessage = 'Edad inválida';

  // Textos de UI
  static const String appTitle = 'Gestión de Usuarios';
  static const String homeTitle = 'Lista de Usuarios';
  static const String addUserTitle = 'Agregar Usuario';
  static const String editUserTitle = 'Editar Usuario';
  static const String addressesTitle = 'Direcciones';
  static const String addAddressTitle = 'Agregar Dirección';

  // Botones
  static const String saveButton = 'Guardar';
  static const String cancelButton = 'Cancelar';
  static const String deleteButton = 'Eliminar';
  static const String editButton = 'Editar';
  static const String addButton = 'Agregar';
  static const String backButton = 'Volver';

  // Labels de formulario
  static const String nameLabel = 'Nombre';
  static const String lastNameLabel = 'Apellido';
  static const String birthDateLabel = 'Fecha de Nacimiento';
  static const String countryLabel = 'País';
  static const String stateLabel = 'Departamento';
  static const String cityLabel = 'Municipio';

  // Formatos
  static const String dateFormat = 'dd/MM/yyyy';

  // Mensajes
  static const String noUsersMessage = 'No hay usuarios registrados';
  static const String noAddressesMessage = 'No hay direcciones registradas';
  static const String userSavedMessage = 'Usuario guardado exitosamente';
  static const String userDeletedMessage = 'Usuario eliminado';
  static const String addressSavedMessage = 'Dirección guardada';
  static const String addressDeletedMessage = 'Dirección eliminada';

  // Confirmaciones
  static const String deleteUserConfirm = '¿Eliminar este usuario?';
  static const String deleteAddressConfirm = '¿Eliminar esta dirección?';
  static const String confirmAction = 'Confirmar';
}
