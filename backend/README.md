# AIE API

AIE API to backendowa aplikacja RESTful napisana w .NET 9, s³u¿¹ca do zarz¹dzania u¿ytkownikami, kampaniami, postaciami i przedmiotami w systemie RPG.

## Funkcjonalnoœci

- Rejestracja i logowanie u¿ytkowników (JWT)
- Zarz¹dzanie rolami u¿ytkowników (Gracz, Mistrz Gry, Admin)
- Obs³uga kampanii, postaci i przedmiotów
- Walidacja danych (FluentValidation)
- Dokumentacja i testowanie endpointów (Swagger)
- Logowanie zdarzeñ (NLog)
- Obs³uga CORS dla aplikacji frontendowej (np. Flutter)

## Wymagania

- .NET 9 SDK
- SQL Server (lub kompatybilna baza danych)
- Visual Studio 2022 lub nowszy

## Uruchomienie

1. Skonfiguruj po³¹czenie do bazy danych w `appsettings.json` (`DefaultConnection`).
2. Przygotuj bazê danych (np. `dotnet ef database update`).
3. Uruchom aplikacjê: