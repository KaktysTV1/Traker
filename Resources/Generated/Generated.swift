// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum InfoPlist {
    /// Трекер
    internal static let cfBundleDisplayName = L10n.tr("InfoPlist", "CFBundleDisplayName", fallback: "Трекер")
  }
  internal enum Localizable {
    internal enum Button {
      /// Отменить
      internal static let cancel = L10n.tr("Localizable", "button.cancel", fallback: "Отменить")
      /// Cоздать
      internal static let create = L10n.tr("Localizable", "button.create", fallback: "Cоздать")
      /// Удалить
      internal static let delete = L10n.tr("Localizable", "button.delete", fallback: "Удалить")
      /// Готово
      internal static let done = L10n.tr("Localizable", "button.done", fallback: "Готово")
      /// Редактировать
      internal static let editTitle = L10n.tr("Localizable", "button.editTitle", fallback: "Редактировать")
      /// Закрепить
      internal static let pinTitle = L10n.tr("Localizable", "button.pinTitle", fallback: "Закрепить")
      /// Сохранить
      internal static let saveTitle = L10n.tr("Localizable", "button.saveTitle", fallback: "Сохранить")
      /// Открепить
      internal static let unpinTitle = L10n.tr("Localizable", "button.unpinTitle", fallback: "Открепить")
      /// Вот это технологии!
      internal static let wowTechnology = L10n.tr("Localizable", "button.wowTechnology", fallback: "Вот это технологии!")
    }
    internal enum Day {
      /// Все дни
      internal static let allDays = L10n.tr("Localizable", "day.allDays", fallback: "Все дни")
      /// Пятница
      internal static let friday = L10n.tr("Localizable", "day.friday", fallback: "Пятница")
      /// Понедельник
      internal static let monday = L10n.tr("Localizable", "day.monday", fallback: "Понедельник")
      /// Суббота
      internal static let saturday = L10n.tr("Localizable", "day.saturday", fallback: "Суббота")
      /// Воскресенье
      internal static let sunday = L10n.tr("Localizable", "day.sunday", fallback: "Воскресенье")
      /// Четверг
      internal static let thursday = L10n.tr("Localizable", "day.thursday", fallback: "Четверг")
      /// Вторник
      internal static let tuesday = L10n.tr("Localizable", "day.tuesday", fallback: "Вторник")
      /// Среда
      internal static let wednesday = L10n.tr("Localizable", "day.wednesday", fallback: "Среда")
      /// Будни
      internal static let weekDays = L10n.tr("Localizable", "day.weekDays", fallback: "Будни")
      /// Выходные дни
      internal static let weekEnd = L10n.tr("Localizable", "day.weekEnd", fallback: "Выходные дни")
      internal enum Short {
        /// Пт
        internal static let friday = L10n.tr("Localizable", "day.short.friday", fallback: "Пт")
        /// Пн
        internal static let monday = L10n.tr("Localizable", "day.short.monday", fallback: "Пн")
        /// Сб
        internal static let saturday = L10n.tr("Localizable", "day.short.saturday", fallback: "Сб")
        /// Вс
        internal static let sunday = L10n.tr("Localizable", "day.short.sunday", fallback: "Вс")
        /// Чт
        internal static let thursday = L10n.tr("Localizable", "day.short.thursday", fallback: "Чт")
        /// Вт
        internal static let tuesday = L10n.tr("Localizable", "day.short.tuesday", fallback: "Вт")
        /// Ср
        internal static let wednesday = L10n.tr("Localizable", "day.short.wednesday", fallback: "Ср")
      }
    }
    internal enum Field {
      /// Введите название трекера
      internal static let enterTrackerName = L10n.tr("Localizable", "field.enterTrackerName", fallback: "Введите название трекера")
      /// Ограничение 38 символов
      internal static let lettersLimit = L10n.tr("Localizable", "field.lettersLimit", fallback: "Ограничение 38 символов")
    }
    internal enum Filter {
      /// Все трекеры
      internal static let allTrackersTitle = L10n.tr("Localizable", "filter.allTrackersTitle", fallback: "Все трекеры")
      /// Завершенные
      internal static let completedTrackersTitle = L10n.tr("Localizable", "filter.completedTrackersTitle", fallback: "Завершенные")
      /// Фильтры
      internal static let filtersTitle = L10n.tr("Localizable", "filter.filtersTitle", fallback: "Фильтры")
      /// Не завершенные
      internal static let notCompletedTitle = L10n.tr("Localizable", "filter.notCompletedTitle", fallback: "Не завершенные")
      /// Трекеры на сегодня
      internal static let todayTrackersTitle = L10n.tr("Localizable", "filter.todayTrackersTitle", fallback: "Трекеры на сегодня")
    }
    internal enum Title {
      /// Добавить категорию
      internal static let addCategory = L10n.tr("Localizable", "title.addCategory", fallback: "Добавить категорию")
      /// Трекеры, относящиеся к данной категории также будут удалены
      internal static let alertMessage = L10n.tr("Localizable", "title.alertMessage", fallback: "Трекеры, относящиеся к данной категории также будут удалены")
      /// Эта категория точно не нужна?
      internal static let alertTitle = L10n.tr("Localizable", "title.alertTitle", fallback: "Эта категория точно не нужна?")
      /// Среднее значение
      internal static let averageValue = L10n.tr("Localizable", "title.averageValue", fallback: "Среднее значение")
      /// Лучший период
      internal static let bestPeriod = L10n.tr("Localizable", "title.bestPeriod", fallback: "Лучший период")
      /// Категория
      internal static let category = L10n.tr("Localizable", "title.category", fallback: "Категория")
      /// Цвет
      internal static let color = L10n.tr("Localizable", "title.color", fallback: "Цвет")
      /// Трекеров завершено
      internal static let completedTrackers = L10n.tr("Localizable", "title.completedTrackers", fallback: "Трекеров завершено")
      /// Уверены что хотите удалить трекер?
      internal static let deleteTrackerTitle = L10n.tr("Localizable", "title.deleteTrackerTitle", fallback: "Уверены что хотите удалить трекер?")
      /// Редактирование категории
      internal static let editingCategory = L10n.tr("Localizable", "title.editingCategory", fallback: "Редактирование категории")
      /// Emoji
      internal static let emoji = L10n.tr("Localizable", "title.emoji", fallback: "Emoji")
      /// Привычки и события можно
      /// объединить по смыслу
      internal static let emptyCategories = L10n.tr("Localizable", "title.emptyCategories", fallback: "Привычки и события можно \nобъединить по смыслу")
      /// Что будем отслеживать?
      internal static let emptyTrackersStub = L10n.tr("Localizable", "title.emptyTrackersStub", fallback: "Что будем отслеживать?")
      /// Введите название категории
      internal static let enterCategory = L10n.tr("Localizable", "title.enterCategory", fallback: "Введите название категории")
      /// Нерегулярное событие
      internal static let event = L10n.tr("Localizable", "title.event", fallback: "Нерегулярное событие")
      /// Отслеживайте только
      /// то, что хотите
      internal static let firstPage = L10n.tr("Localizable", "title.firstPage", fallback: "Отслеживайте только \nто, что хотите")
      /// Привычка
      internal static let habit = L10n.tr("Localizable", "title.habit", fallback: "Привычка")
      /// Редактирование привычки
      internal static let habitEditing = L10n.tr("Localizable", "title.habitEditing", fallback: "Редактирование привычки")
      /// Идеальные дни
      internal static let idealDays = L10n.tr("Localizable", "title.idealDays", fallback: "Идеальные дни")
      /// Новая категория
      internal static let newCategory = L10n.tr("Localizable", "title.newCategory", fallback: "Новая категория")
      /// Новое нерегулярное событие
      internal static let newEvent = L10n.tr("Localizable", "title.newEvent", fallback: "Новое нерегулярное событие")
      /// Новая привычка
      internal static let newHabit = L10n.tr("Localizable", "title.newHabit", fallback: "Новая привычка")
      /// Анализировать пока нечего
      internal static let noDataToAnalyze = L10n.tr("Localizable", "title.noDataToAnalyze", fallback: "Анализировать пока нечего")
      /// Ничего не найдено
      internal static let notFoundTitle = L10n.tr("Localizable", "title.notFoundTitle", fallback: "Ничего не найдено")
      /// Закрепленные
      internal static let pinnedTitle = L10n.tr("Localizable", "title.pinnedTitle", fallback: "Закрепленные")
      /// Расписание
      internal static let schedule = L10n.tr("Localizable", "title.schedule", fallback: "Расписание")
      /// Поиск
      internal static let search = L10n.tr("Localizable", "title.search", fallback: "Поиск")
      /// Даже если это
      /// не литры воды и йога
      internal static let secondPage = L10n.tr("Localizable", "title.secondPage", fallback: "Даже если это \nне литры воды и йога")
      /// Статистика
      internal static let statistics = L10n.tr("Localizable", "title.statistics", fallback: "Статистика")
      /// Cоздание трекера
      internal static let trackerCreating = L10n.tr("Localizable", "title.trackerCreating", fallback: "Cоздание трекера")
      /// Трекеры
      internal static let trackers = L10n.tr("Localizable", "title.trackers", fallback: "Трекеры")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
