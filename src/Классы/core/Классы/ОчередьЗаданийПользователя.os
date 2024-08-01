&Пластилин Перем УведомленияПользователям;
&Пластилин Перем ЖурналСобытий;

Перем ОчередьЗаданий;
Перем ОчередьОбрабатывается;


&Желудь
Процедура ПриСозданииОбъекта()
	ОчередьЗаданий = Новый ТаблицаЗначений;
	ОчередьЗаданий.Колонки.Добавить("Наименование");
	ОчередьЗаданий.Колонки.Добавить("Идентификатор");
	ОчередьЗаданий.Колонки.Добавить("Задание");
	ОчередьЗаданий.Колонки.Добавить("Параметры");
	ОчередьОбрабатывается = Ложь;
КонецПроцедуры

Процедура Добавить(Наименование, Задание, Параметры = Неопределено) Экспорт

	НоваяСтрока = ОчередьЗаданий.Добавить();
	НоваяСтрока.Наименование = Наименование;
	НоваяСтрока.Идентификатор = Строка(Новый УникальныйИдентификатор);
	НоваяСтрока.Задание = Задание;
	НоваяСтрока.Параметры = Параметры;

	УведомленияПользователям.СобытиеЛога("Добавлено задание: " + Наименование);
	УведомленияПользователям.СобытиеУведомление(Наименование, "Добавлено задание");

	ЗапуститьОбработкуОчереди();
	
КонецПроцедуры

Процедура ЗапуститьОбработкуОчереди()
	Если ОчередьОбрабатывается = Ложь Тогда
		ОчередьОбрабатывается = Истина;
		ФоновыеЗадания.Выполнить(ЭтотОбъект, "ОбработатьОчередь");
	КонецЕсли;
КонецПроцедуры

Процедура ОбработатьОчередь() Экспорт

	Если ОчередьЗаданий.Количество() > 0 Тогда
		
		Задание = ОчередьЗаданий[0];

		УведомленияПользователям.СобытиеЛога("Обработка задания: " + Задание.Наименование);
		Попытка
			Если Задание.Параметры = Неопределено Тогда
				Задание.Задание.Выполнить();
			Иначе
				Задание.Задание.Выполнить(Задание.Параметры);
			КонецЕсли;
			УведомленияПользователям.СобытиеЛога("Задание обработано: " + Задание.Наименование);
			УведомленияПользователям.СобытиеУведомление(Задание.Наименование, "Задание обработано");	
		Исключение
			ОписаниеОшибки = ОписаниеОшибки();
			ТекстОшибки = "Задание завершено с ошибкой: " + Задание.Наименование + " " + ОписаниеОшибки;
			УведомленияПользователям.СобытиеЛога(ТекстОшибки);
			УведомленияПользователям.СобытиеУведомление(Задание.Наименование, "Задание завершено с ошибкой");	

			ЖурналСобытий.Ошибка(ТекстОшибки);
		КонецПопытки;
		ОчередьЗаданий.Удалить(Задание);
		Приостановить(1000);

	КонецЕсли;

	ОчередьОбрабатывается = Ложь;

	ЗапуститьОбработкуОчереди();
	
КонецПроцедуры