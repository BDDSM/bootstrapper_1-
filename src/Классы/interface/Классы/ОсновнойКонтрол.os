&Пластилин Перем УведомленияПользователям;
&Пластилин Перем ЗапускательКонфигуратора;
&Пластилин Перем ОчередьЗаданийПользователя;
&Пластилин Перем НастройкиПроекта;
&Пластилин Перем ЧтениеИсходников;
&Пластилин Перем КомпиляторИсходников;

&Пластилин(Значение = "ЭлементГлавноеМеню", Тип = "Массив")
Перем ЭлементыГлавноеМеню;

&Контроллер("/")
Процедура ПриСозданииОбъекта()
КонецПроцедуры

&ТочкаМаршрута("")
&Отображение("./src/Классы/interface/view/index.html")
Процедура Главная() Экспорт
	
КонецПроцедуры

&ТочкаМаршрута("leftMenu")
&Отображение("./src/Классы/interface/view/leftMenu.html")
Процедура ЛевоеМеню(Ответ) Экспорт
	Ответ.Модель = Новый Структура("ЭлементыМеню", ЭлементыГлавноеМеню);
КонецПроцедуры

&ТочкаМаршрута("topMenu")
&Отображение("./src/Классы/interface/view/topMenu.html")
Процедура МенюШапки(Ответ) Экспорт
	
КонецПроцедуры

&ТочкаМаршрута("cfInfo")
&Отображение("./src/Классы/interface/view/cfInfo.html")
Процедура ИнформацияОКонфигурации(Ответ) Экспорт

	Ответ.Модель = Новый Структура("Описание, Цель", ЧтениеИсходников.ОписаниеКонфигурации(НастройкиПроекта.КаталогКонфигурации()), "-conf");

КонецПроцедуры

&ТочкаМаршрута("extInfo/{ИмяРасширения}")
&Отображение("./src/Классы/interface/view/cfInfo.html")
Процедура ИнформацияОРасширении(Ответ, ИмяРасширения) Экспорт

	Для каждого Расширение Из НастройкиПроекта.Расширения() Цикл

		Если НЕ Расширение["Имя"] = ИмяРасширения Тогда
			Продолжить;
		КонецЕсли;

		ДанныеРасширения = ЧтениеИсходников.ОписаниеКонфигурации(Расширение["Каталог"]);

		Ответ.Модель = Новый Структура("Описание, Цель", ДанныеРасширения, ИмяРасширения);

		Прервать;
		
	КонецЦикла;

КонецПроцедуры

&ТочкаМаршрута("extList")
&Отображение("./src/Классы/interface/view/extList.html")
Процедура СписокРасширений(Ответ) Экспорт

	Ответ.Модель = Новый Структура("МассивРасширений", Новый Массив);

	Для каждого Расширение Из НастройкиПроекта.Расширения() Цикл
		ДанныеРасширения = ЧтениеИсходников.ОписаниеКонфигурации(Расширение["Каталог"]);
		Ответ.Модель.МассивРасширений.Добавить(ДанныеРасширения);
	КонецЦикла;

КонецПроцедуры

&ТочкаМаршрута("runDesigner")
Процедура ЗапускКонфигуратора() Экспорт

	ОчередьЗаданийПользователя.Добавить("Запуск конфигуратора", 
		Новый Действие(ЭтотОбъект, "ЗапуститьКонфигураторВспомогательный")
	);

КонецПроцедуры

&ТочкаМаршрута("DecompileToFile/{Цель}")
Процедура РазобратьВИсходники(Цель) Экспорт

	Если Цель = "-conf" Тогда

		ОчередьЗаданийПользователя.Добавить("Разбор конфигурации", 
			Новый Действие(ЭтотОбъект, "РазобратьКонфигурациюВспомогательный")
		);

	Иначе

		ОчередьЗаданийПользователя.Добавить("Разбор расширения: " + Цель, 
			Новый Действие(ЭтотОбъект, "РазобратьРасширениеВспомогательный"),
			Цель
		);

	КонецЕсли;

КонецПроцедуры

&ТочкаМаршрута("CompileFromFile/{Цель}")
Процедура СобратьИзИсходников(Цель) Экспорт

	Если Цель = "-conf" Тогда

		ОчередьЗаданийПользователя.Добавить("Сборка конфигурации", 
			Новый Действие(ЭтотОбъект, "СобратьКонфигурациюВспомогательный")
		);

	Иначе

		ОчередьЗаданийПользователя.Добавить("Сборка расширения: " + Цель, 
			Новый Действие(ЭтотОбъект, "СобратьРасширениеВспомогательный"), 
			Цель
		);

	КонецЕсли;

КонецПроцедуры

#Область Вспомогательные

Процедура СобратьКонфигурациюВспомогательный() Экспорт
	РезультатРазбора = КомпиляторИсходников.СобратьКонфигурацию();
	УведомленияПользователям.СобытиеЛога(РезультатРазбора);
КонецПроцедуры

Процедура РазобратьКонфигурациюВспомогательный() Экспорт
	РезультатРазбора = КомпиляторИсходников.РазобратьКонфигурацию();
	УведомленияПользователям.СобытиеЛога(РезультатРазбора);
КонецПроцедуры

Процедура СобратьРасширениеВспомогательный(ИмяРасширения) Экспорт
	РезультатРазбора = КомпиляторИсходников.СобратьРасширение(ИмяРасширения);
	УведомленияПользователям.СобытиеЛога(РезультатРазбора);
КонецПроцедуры

Процедура РазобратьРасширениеВспомогательный(ИмяРасширения) Экспорт
	РезультатРазбора = КомпиляторИсходников.РазобратьРасширение(ИмяРасширения);
	УведомленияПользователям.СобытиеЛога(РезультатРазбора);
КонецПроцедуры

Процедура ЗапуститьКонфигураторВспомогательный() Экспорт
	РезультатЗапуска = ЗапускательКонфигуратора.ЗапуститьКонфигуратор();
	УведомленияПользователям.СобытиеЛога(РезультатЗапуска);
КонецПроцедуры

#КонецОбласти