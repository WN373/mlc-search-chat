package ai.mlc.mlcchat

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

class DatabaseHelper(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    companion object {
        private const val DATABASE_NAME = "mydatabase.db"
        private const val DATABASE_VERSION = 1
    }

    override fun onCreate(db: SQLiteDatabase) {
        // 创建表的语句
        val createTableQuery =
            "CREATE TABLE IF NOT EXISTS " +
                    "questions " +
                    "(id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "question TEXT," +
                    "answer TEXT, " +
                    "" +
                    ")"
        // 执行创建表的语句
        db.execSQL(createTableQuery)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        // 升级数据库的逻辑
        // 可以根据需要进行表结构的修改或数据的迁移
    }
}
