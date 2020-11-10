const String DB_NAME = "wanandroid.db";
class UserLoginTable {
  static const String TABLE_NAME = "UserLogin";

  static const String COLUMN_ID = "id";
  static const String COLUMN_USERNAME = "username";
  static const String COLUMN_NICKNAME = "nickname";
  static const String COLUMN_PUBLIC_NAME = "publicName";
  static const String COLUMN_TOKEN = "token";
  static  const String COLUMN_EMAIL = "email";
  static const String COLUMN_ADMIN = "admin";
  static const String COLUMN_ICON = "icon";
  static const String COLUMN_TYPE= "type";

  static const String CREATE_TABLE = "create table ${TABLE_NAME}"
      "("
      "${COLUMN_ID} integer,"
      "${COLUMN_USERNAME} text,"
      "${COLUMN_NICKNAME} text,"
      "${COLUMN_PUBLIC_NAME} text,"
      "${COLUMN_TOKEN} text,"
      "${COLUMN_EMAIL} text,"
      "${COLUMN_ICON} text,"
      "${COLUMN_TYPE} integer,"
      "${COLUMN_ADMIN} integer"
      ")";
}
